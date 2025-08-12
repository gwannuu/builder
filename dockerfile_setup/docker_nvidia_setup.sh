#!/bin/bash

# Define the path to the Docker daemon configuration file.
DAEMON_FILE="/etc/docker/daemon.json"
RESPONSE=""

# Check if the DAEMON_FILE already exists.
if [ -f "$DAEMON_FILE" ]; then
    echo "Warning: $DAEMON_FILE already exists. Current file contents:"
    echo "--------------------------------------------------------------------------------"
    cat "$DAEMON_FILE"
    echo "--------------------------------------------------------------------------------"

    # Ask the user for confirmation to overwrite the file.
    read -p "Do you want to overwrite this file? (y/n): " RESPONSE

    if [[ ! "$RESPONSE" =~ ^([yY])$ ]]; then
        echo "Aborting script. No changes have been made."
        exit 0
    fi
fi

# If the file doesn't exist or the user confirmed overwriting, proceed.
echo "Info: Proceeding with NVIDIA Container Toolkit setup."
echo "--------------------------------------------------------------------------------"

# 1. Add the GPG key and APT repository list for the NVIDIA Container Toolkit.
echo ">> Adding NVIDIA APT repository key and list..."
# Note: Using 'tee' without the '-a' flag ensures a clean file, preventing duplicate entries.
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

echo ">> Success: NVIDIA APT repository added."
echo ""

# 2. Update the package list and install the nvidia-container-toolkit.
echo ">> Updating packages and installing nvidia-container-toolkit..."
sudo apt update -y
sudo apt install -y nvidia-container-toolkit

echo ">> Success: nvidia-container-toolkit installed."
echo ""

# 3. Configure Docker runtime settings and restart the Docker daemon.
echo ">> Configuring Docker runtime and restarting daemon..."
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
sudo chmod 666 /var/run/docker.sock

echo ">> Success: Docker runtime configured."
echo ""

# 4. Create the daemon.json file with default-runtime settings.
echo ">> Creating $DAEMON_FILE..."
sudo tee "$DAEMON_FILE" > /dev/null << EOF
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    }
}
EOF

echo ">> Success: $DAEMON_FILE has been successfully created."
echo "--------------------------------------------------------------------------------"
echo "Setup complete: You can now use NVIDIA GPUs without the --gpus all and --runtime options."
