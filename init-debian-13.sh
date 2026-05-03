#!/bin/bash
###############################################################################
# Debian 13 (Trixie) 新机器一键初始化脚本
# Author: woaye
# Description: 自动配置软件源、安装常用工具、Oh My Zsh、中文 locale 和时区
###############################################################################

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

###############################################################################
# 1. 备份并配置软件源
###############################################################################
info "配置腾讯云镜像源..."
if [ -f /etc/apt/sources.list ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d_%H%M%S)
fi
sudo tee /etc/apt/sources.list > /dev/null <<'EOF'
# Debian 13 (Trixie) 腾讯云镜像源
deb https://mirrors.cloud.tencent.com/debian/ trixie main contrib non-free non-free-firmware
deb https://mirrors.cloud.tencent.com/debian/ trixie-updates main contrib non-free non-free-firmware
deb https://mirrors.cloud.tencent.com/debian/ trixie-backports main contrib non-free non-free-firmware
deb https://mirrors.cloud.tencent.com/debian-security/ trixie-security main contrib non-free non-free-firmware
EOF

###############################################################################
# 2. 更新系统
###############################################################################
info "更新软件包列表..."
sudo apt update || error "apt update 失败"
info "升级已安装软件包..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" || error "apt upgrade 失败"

###############################################################################
# 3. 安装常用工具
###############################################################################
info "安装常用工具..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    build-essential git curl wget vim nano htop tree zip unzip p7zip-full \
    net-tools dnsutils iputils-ping socat netcat-openbsd jq zsh \
    openssh-server webp locales fonts-noto-cjk tzdata \
    || error "软件包安装失败"

###############################################################################
# 4. 配置中文 locale 和时区
###############################################################################
info "配置中文 locale..."
sudo sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen || warn "locale-gen 部分失败"
sudo tee /etc/default/locale > /dev/null <<'EOF'
LANG=zh_CN.UTF-8
LC_ALL=zh_CN.UTF-8
LANGUAGE="zh_CN:zh"
EOF
sudo timedatectl set-timezone Asia/Shanghai || warn "设置时区失败"
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh

###############################################################################
# 5. 安装 Oh My Zsh
###############################################################################
info "安装 Oh My Zsh..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth=1 "https://github.com/ohmyzsh/ohmyzsh.git" "$HOME/.oh-my-zsh"
else
    warn "Oh My Zsh 已存在，跳过安装"
fi

###############################################################################
# 6. 安装 Zsh 插件
###############################################################################
info "安装 Zsh 插件..."

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

###############################################################################
# 7. 配置 .zshrc
###############################################################################
info "配置 zsh..."
cat > ~/.zshrc <<'ZSHRC'
# Oh My Zsh 配置
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# 中文 locale
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh

# 历史记录
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# 别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# 其他
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
ZSHRC

###############################################################################
# 8. 切换默认 shell 为 zsh
###############################################################################
info "切换默认 shell 为 zsh..."
ZSH_PATH=$(command -v zsh)
if [ -z "$ZSH_PATH" ]; then
    error "zsh 未找到"
fi
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s "$ZSH_PATH" || warn "chsh 失败，请手动切换"
fi

###############################################################################
# 9. 验证
###############################################################################
echo ""
echo "=== 配置验证 ==="
echo "Shell: $(command -v zsh)"
echo "Locale: $(locale | grep LANG | head -1)"
echo "时区: $(timedatectl | grep 'Time zone')"
echo "Oh My Zsh: $([ -d ~/.oh-my-zsh ] && echo '已安装' || echo '未安装')"
touch /tmp/中文测试_$(date +%s).txt && ls --show-control-chars /tmp/中文测试_*.txt && rm -f /tmp/中文测试_*.txt
echo ""
info "初始化完成，请重新登录以使用 zsh + Oh My Zsh"
