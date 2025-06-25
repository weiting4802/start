#!/bin/bash

echo "🐚 安裝 zsh 與開發者插件環境..."

# 安裝 zsh
sudo apt update
sudo apt install -y zsh git curl wget

# 設定 zsh 為預設 shell
chsh -s $(which zsh) vagrant

# 安裝 Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH" ]; then
  echo "⬇️ 安裝 Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 安裝外掛 plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# zsh-autosuggestions（指令提示）
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting（語法上色）
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

# zsh-completions（額外補全）
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions

# powerlevel10k 主題
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

# 設定 ~/.zshrc
echo "⚙️ 設定 .zshrc..."
cat > ~/.zshrc <<EOF
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source \$ZSH/oh-my-zsh.sh
EOF

echo "✅ Zsh 安裝與設定完成。請執行 'zsh' 或重新登入啟用環境。"
