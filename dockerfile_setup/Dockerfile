# Specifies the Ubuntu version to use.
FROM ubuntu:jammy-20250714

# Defines build arguments for user and group IDs with default values.
# Defaults to 1000 to match the local user's ID.
ARG HOST_UID=1000
ARG HOST_GID=1000
ARG USER=gwanwoo

# Updates package lists, upgrades packages, and installs necessary tools.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y zsh build-essential ninja-build gettext cmake gcc sudo ca-certificates wget curl tig vim direnv nvtop tmux

# Creates a '$USER' group and user using HOST_UID and HOST_GID.
# The '-m' option creates a home directory ($HOME), and '-s /bin/bash' sets the default shell.
RUN groupadd -g ${HOST_GID} $USER && \
    useradd -m -s /usr/bin/zsh -u ${HOST_UID} -g $USER $USER

# Configures '$USER' to be able to use the 'sudo' command without a password.
RUN mkdir -p /etc/sudoers.d && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

# Switches the container to run as '$USER' from this point on.
# All subsequent RUN, CMD, and ENTRYPOINT instructions will be executed with '$USER' privileges.
USER $USER

SHELL ["/usr/bin/zsh", "-c"]


# Install Oh-My-Zsh
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN cp /home/$USER/.oh-my-zsh/templates/zshrc.zsh-template /home/$USER/.zshrc

# Add direnv oh-my-zsh plugin
RUN source ~/.zshrc && \
    omz plugin enable direnv && \
    omz plugin enable tmux

COPY zshrc_custom /tmp/zshrc_custom
COPY tmux_conf /home/$USER/.tmux.conf
RUN cat /tmp/zshrc_custom >> /home/$USER/.zshrc


WORKDIR /home/$USER/downloads

# Copies the uv_installer.sh script from the build context to a temporary location inside the container.
COPY uv_installer.sh uv_installer.sh
# Executes the 'uv_installer.sh' script and adds the path where uv is installed to '$USER's PATH environment variable.
RUN sh ./uv_installer.sh
#RUN sh /home/$USER/uv_installer.sh && \
#    echo "export PATH=\$PATH:\$HOME/.local/bin:" >> home/$USER/.zshrc

# Install neovim

# Set git config
RUN git config --global user.email "kwanwow1999@gmail.com" && \
    git config --global user.name "gwanwoochoi" && \
    git config --global core.editor vim && \
    git config --global init.defaultBranch main

RUN git clone https://github.com/neovim/neovim && \
    cd neovim && \
    git checkout stable && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    sudo make install

WORKDIR /home/$USER/workdir

CMD ["/usr/bin/zsh"]
