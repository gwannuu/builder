#sudo apt update -y
#sudo apt upgrade -y
#sudo apt install -y zsh
#sudo apt install -y build-essentials gcc
#sudo apt install -y ca-certificates curl tig vim direnv
#git config --global core.editor "vim"
#git config --global user.email "kwanwow1999@gmail.com"
#git config --global user.name "gwanwoochoi"

## add ppa nvidia
#sh add-ppa-nvidia.sh

## docker
#for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
#sudo install -m 0755 -d /etc/apt/keyrings
#sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
#sudo chmod a+r /etc/apt/keyrings/docker.asc
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update
#sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#sudo usermod -aG docker $USERNAME
#newgrp docker
## sudo systemctl restart docker

##omz install
#sh ./omz-installer.sh
#omz plugin enable tmux

##uv install
#sh ./uv_install.sh
#uv self update

##ssh-keygen
#sh ./ssh-keygen.sh

##alias add
#sh ./alias.sh

#source ~/.zshrc

#!/bin/bash

# 에러 발생 시 스크립트 중단 (안전 장치)
# set -e

# # 현재 사용자 확인 (sudo로 실행했더라도 원래 사용자 계정을 찾음)
# REAL_USER=${SUDO_USER:-$USER}
# echo "Setting up environment for user: $REAL_USER"

# # 1. 기본 패키지 업데이트 및 설치
# echo "--- Updating Apt & Installing Basics ---"
# sudo apt update -y
# sudo apt upgrade -y
# sudo apt install -y zsh git build-essential gcc ca-certificates curl tig vim direnv

# # 2. Git 설정
# echo "--- Configuring Git ---"
# git config --global core.editor "vim"
# git config --global user.email "kwanwow1999@gmail.com"
# git config --global user.name "gwanwoochoi"

# # 3. Nvidia PPA (필요한 경우 주석 해제, 스크립트가 있는지 확인 필요)
# # sh add-ppa-nvidia.sh

# # 4. Docker 설치
# echo "--- Installing Docker ---"
# # 기존 패키지 삭제 (에러 무시)
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

# # GPG 키 및 저장소 설정
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt update
# sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # Docker 그룹 추가 (수정된 부분)
# echo "--- Adding $REAL_USER to docker group ---"
# sudo usermod -aG docker $REAL_USER

# # 5. Oh My Zsh (OMZ) 설치
# # 외부 스크립트 대신 공식 설치 명령어 사용 (--unattended 옵션으로 입력 대기 방지)
# echo "--- Installing Oh My Zsh ---"
# if [ ! -d "/home/$REAL_USER/.oh-my-zsh" ]; then
#   # 유저 권한으로 실행하기 위해 sudo -u 사용
#   sudo -u $REAL_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# else
#   echo "Oh My Zsh already installed."
# fi

# # OMZ 플러그인 활성화 (zshrc 수정 필요)
# # 단순 명령어로는 안되고 .zshrc 파일을 sed 등으로 수정해야 함.
# # 일단 설치만 진행하고 플러그인은 나중에 설정하거나 sed 명령어를 추가해야 합니다.

# # 6. uv 설치 (Python tool)
# echo "--- Installing uv ---"
# # 공식 설치 스크립트 사용
# sudo -u $REAL_USER curl -LsSf https://astral.sh/uv/install.sh | sudo -u $REAL_USER sh

# # 7. SSH Keygen (자동화)
# # 파일이 없을 때만 생성, 비밀번호 없이(-N "") 생성
# echo "--- Generating SSH Key ---"
# if [ ! -f "/home/$REAL_USER/.ssh/id_rsa" ]; then
#   sudo -u $REAL_USER ssh-keygen -t rsa -b 4096 -C "kwanwow1999@gmail.com" -f "/home/$REAL_USER/.ssh/id_rsa" -N ""
#   echo "SSH key generated."
# else
#   echo "SSH key already exists."
# fi

# # 8. 마무리 및 안내
# echo "----------------------------------------------------------------"
# echo "Setup Finished!"
# echo "1. Docker 권한 적용을 위해 로그아웃 후 다시 로그인해주세요."
# echo "2. 기본 쉘을 zsh로 변경하려면 'chsh -s \$(which zsh)'를 실행하세요."
# echo "----------------------------------------------------------------"




#!/bin/bash

# 스크립트 실행 도중 에러 발생 시 멈춤 (디버깅용, 필요 시 주석 처리)
# set -e

# 1. 사용자 감지 (sudo로 실행해도 원래 사용자 계정을 찾아냄)
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$REAL_USER)

echo "=========================================="
echo " Setup Environment for User: $REAL_USER"
echo "=========================================="

# 2. 기본 패키지 업데이트 및 설치
echo ">>> [1/7] Installing Basic Packages..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y zsh git build-essential gcc ca-certificates curl tig vim direnv

# 3. Git 설정
echo ">>> [2/7] Configuring Git..."
git config --global core.editor "vim"
git config --global user.email "kwanwow1999@gmail.com"
git config --global user.name "gwanwoochoi"

# 4. Docker 설치 (기존 충돌 패키지 제거 포함)
echo ">>> [3/7] Installing Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 그룹 추가
sudo usermod -aG docker $REAL_USER

# 5. Oh My Zsh 설치 및 권한 강제 수정 (문제 해결 파트)
echo ">>> [4/7] Installing Oh My Zsh..."

if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
  # 설치
  sudo -u $REAL_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # [중요] Zsh 보안 에러 방지: 그룹 및 기타 사용자의 쓰기 권한 강제 제거
  echo "Fixing Zsh permissions to prevent 'Insecure completion-dependent directories' error..."
  sudo chmod -R 755 "$USER_HOME/.oh-my-zsh"
  sudo chmod -R g-w,o-w "$USER_HOME/.oh-my-zsh"

  # .zshrc 플러그인 설정 (tmux 추가)
  sed -i 's/plugins=(git)/plugins=(git tmux)/' "$USER_HOME/.zshrc"
  echo "OMZ installed and tmux plugin enabled."
else
  echo "Oh My Zsh already installed."
fi
# chsh 대신 usermod를 쓰면 비밀번호 입력 없이 강제로 변경 가능
sudo usermod --shell $(which zsh) $REAL_USER
echo "Default shell changed to $(which zsh) for user $REAL_USER."

# 6. uv 설치
echo ">>> [5/7] Installing uv..."
sudo -u $REAL_USER curl -LsSf https://astral.sh/uv/install.sh | sudo -u $REAL_USER sh

# 7. SSH Key 생성
echo ">>> [6/7] Generating SSH Key..."
if [ ! -f "$USER_HOME/.ssh/id_rsa" ]; then
  sudo -u $REAL_USER ssh-keygen -t rsa -b 4096 -C "kwanwow1999@gmail.com" -f "$USER_HOME/.ssh/id_rsa" -N ""
  echo "SSH key generated."
else
  echo "SSH key already exists."
fi

# 8. Alias 및 사용자 설정 추가 (alias.sh 내용 통합)
echo ">>> [7/7] Adding Aliases..."
ZSHRC="$USER_HOME/.zshrc"

# 이미 설정이 들어가 있는지 확인 후 없으면 추가
if ! grep -q "# Custom Aliases" "$ZSHRC"; then
  cat <<EOT >> "$ZSHRC"

# Custom Aliases added by setup script
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias d='docker'
alias dc='docker compose'
alias tiga='tig --all'
# 필요한 alias가 더 있으면 여기에 추가하세요
EOT
  echo "Aliases added to .zshrc"
fi

echo "=========================================="
echo "       ALL DONE! Setup Finished.          "
echo "=========================================="
echo "1. Log out and log back in to apply Docker group changes."
echo "2. Type 'zsh' to start your new shell."
