# Specifies the Ubuntu version to use.
FROM ubuntu:jammy-20250714

# Defines build arguments for user and group IDs with default values.
# Defaults to 1000 to match the local user's ID.
ARG HOST_UID=1000
ARG HOST_GID=1000

# Updates package lists, upgrades packages, and installs necessary tools.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential gcc sudo ca-certificates wget curl tig vim direnv nvtop

# Creates a 'myuser' group and user using HOST_UID and HOST_GID.
# The '-m' option creates a home directory ($HOME), and '-s /bin/bash' sets the default shell.
RUN groupadd -g ${HOST_GID} myuser && \
    useradd -m -s /bin/bash -u ${HOST_UID} -g myuser myuser

# Configures 'myuser' to be able to use the 'sudo' command without a password.
RUN mkdir -p /etc/sudoers.d && \
    echo "myuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/myuser

# Switches the container to run as 'myuser' from this point on.
# All subsequent RUN, CMD, and ENTRYPOINT instructions will be executed with 'myuser' privileges.
USER myuser

# Creates and navigates to the 'developer' working directory inside 'myuser's home directory.
WORKDIR /home/myuser/developer

# Copies the uv_installer.sh script from the build context to a temporary location inside the container.
COPY uv_installer.sh /home/myuser/uv_installer.sh

# Executes the 'uv_installer.sh' script and adds the path where uv is installed to 'myuser's PATH environment variable.
RUN sh /home/myuser/uv_installer.sh && \
    echo "export PATH=\$PATH:\$HOME/.local/bin:" >> $HOME/.bashrc
