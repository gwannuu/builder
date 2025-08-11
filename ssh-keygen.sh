#!/bin/bash

# .ssh 디렉터리가 없으면 생성
if [ ! -d "$HOME/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
fi

# SSH 키 파일 경로 설정
KEY_FILE="$HOME/.ssh/id_ed25519"

# 이미 키 파일이 존재하면 사용자에게 알리고 스크립트 종료
if [ -f "$KEY_FILE" ]; then
  echo "SSH 키 파일($KEY_FILE)이 이미 존재합니다. 덮어쓰지 않습니다."
  exit 1
fi

# ssh-keygen 명령어를 사용하여 ed25519 타입의 키 생성
# -t ed25519: 키 타입을 ed25519로 지정
# -f $KEY_FILE: 키 파일 경로 지정
# -N "": passphrase 없이 생성 (필요에 따라 "" 안에 passphrase 입력)
# -q: 조용히(quiet) 모드, 사용자에게 질문하지 않음
ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -q

echo "SSH 키가 성공적으로 생성되었습니다: $KEY_FILE"
echo "공개키 경로: $KEY_FILE.pub"
echo "생성된 키를 확인하세요."
