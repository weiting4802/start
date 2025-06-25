#!/bin/bash

echo "🔧 安裝 Kubernetes CLI 工具..."

# 更新套件庫
sudo apt update

# 安裝 kubectl
echo "➡️ 安裝 kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# 安裝 kubectx / kubens
echo "➡️ 安裝 kubectx 和 kubens..."
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# 安裝 bash 補全
echo "➡️ 啟用 bash/zsh 補全..."
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
/opt/kubectx/completion/kubens.bash | sudo tee /etc/bash_completion.d/kubens > /dev/null
/opt/kubectx/completion/kubectx.bash | sudo tee /etc/bash_completion.d/kubectx > /dev/null

# 可選安裝 helm
echo "➡️ 安裝 Helm（選用工具）..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 可選安裝 stern（log tail）
echo "➡️ 安裝 stern（選用工具）..."
curl -Lo stern https://github.com/stern/stern/releases/latest/download/stern_linux_amd64
chmod +x stern
sudo mv stern /usr/local/bin/

echo "✅ 所有工具安裝完成！"
