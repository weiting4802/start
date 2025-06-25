#!/bin/bash

echo "🛠 安裝基礎開發工具..."

# 更新系統
sudo apt update
sudo apt upgrade -y

# 安裝基本開發工具
sudo apt install -y \
  build-essential \
  git \
  curl \
  wget \
  make \
  zsh \
  unzip \
  software-properties-common \
  python3 \
  python3-pip \
  tmux \
  vim \
  neovim

# 安裝 nvm 與 Node.js 最新 LTS
echo "➡️ 安裝 nvm 和 Node.js"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts
fi

# 設定 zsh 為預設 shell（選擇性）
if command -v zsh &> /dev/null; then
  chsh -s $(which zsh) vagrant
fi

echo "✅ 開發工具安裝完成"
