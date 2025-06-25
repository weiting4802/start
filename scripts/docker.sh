#!/bin/bash

echo "🐳 開始安裝 Docker Engine..."

# 移除舊版本（如果有）
sudo apt remove -y docker docker-engine docker.io containerd runc

# 更新套件庫
sudo apt update

# 安裝必要工具
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  apt-transport-https

# 新增 Docker 官方 GPG 金鑰
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 新增官方 repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安裝 Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 加入目前使用者到 docker 群組（避免每次用 sudo）
sudo usermod -aG docker $USER

echo "✅ Docker 安裝完成！請重新登入一次或執行 'newgrp docker' 以啟用 docker 群組權限"
docker --version
docker compose version
