#!/bin/bash
###############################################################################
# Debian 13 (Trixie) 新机器一键初始化脚本
# Author: woaye
# Description: 自动配置软件源、安装常用工具、设置中文 locale 和时区
###############################################################################

set -euo pipefail
# -e: 任何命令失败立即退出
# -u: 使用未定义变量时报错
# -o pipefail: 管道中任一命令失败则整体失败

# 颜色定义（用于输出高亮）
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的信息
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

###############################################################################
# 1. 备份原有软件源列表
###############################################################################
info "Step 1: 备份原有软件源列表..."
if [ -f /etc/apt/sources.list ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d_%H%M%S)
    info "已备份到 /etc/apt/sources.list.bak.$(date +%Y%m%d_%H%M%S)"
else
    warn "/etc/apt/sources.list 不存在，跳过备份"
fi

###############################################################################
# 2. 写入腾讯云镜像源（覆盖原有内容）
###############################################################################
info "Step 2: 配置腾讯云 Debian 镜像源..."

# 使用 tee 直接写入，无需手动 nano 编辑
sudo tee /etc/apt/sources.list > /dev/null <<'EOF'
# Debian 13 (Trixie) 腾讯云镜像源
# 主仓库
deb https://mirrors.cloud.tencent.com/debian/ trixie main contrib non-free non-free-firmware
# 更新仓库
deb https://mirrors.cloud.tencent.com/debian/ trixie-updates main contrib non-free non-free-firmware
# 回溯仓库
deb https://mirrors.cloud.tencent.com/debian/ trixie-backports main contrib non-free non-free-firmware
# 安全更新仓库
deb https://mirrors.cloud.tencent.com/debian-security/ trixie-security main contrib non-free non-free-firmware
EOF

info "软件源已更新为腾讯云镜像"

###############################################################################
# 3. 更新软件包列表
###############################################################################
info "Step 3: 更新软件包列表 (apt update)..."
sudo apt update || error "apt update 失败，请检查网络连接"

###############################################################################
# 4. 升级已安装的软件包
###############################################################################
info "Step 4: 升级已安装的软件包 (apt upgrade)..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" || error "apt upgrade 失败"

###############################################################################
# 5. 安装常用工具
###############################################################################
info "Step 5: 安装常用工具包..."

# 包列表说明：
# - build-essential: 编译工具链 (gcc, make, etc.)
# - git: 版本控制
# - curl/wget: 下载工具
# - vim/nano: 文本编辑器
# - htop: 交互式进程查看器
# - tree: 目录树显示
# - zip/unzip/p7zip-full: 压缩解压工具
# - net-tools: 网络工具 (ifconfig, netstat)
# - dnsutils: DNS 工具 (dig, nslookup)
# - iputils-ping: ping 命令
# - socat: 多功能网络工具
# - netcat-openbsd: 网络瑞士军刀 (nc)
# - jq: JSON 处理器
# - zsh: 更强大的 shell
# - openssh-server: SSH 服务端
# - webp: WebP 图片工具
# - locales: 本地化支持
# - fonts-noto-cjk: 中日韩字体
# - tzdata: 时区数据

sudo DEBIAN_FRONTEND=noninteractive apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    build-essential \
    git \
    curl \
    wget \
    vim \
    nano \
    htop \
    tree \
    zip \
    unzip \
    p7zip-full \
    net-tools \
    dnsutils \
    iputils-ping \
    socat \
    netcat-openbsd \
    jq \
    zsh \
    openssh-server \
    webp \
    locales \
    fonts-noto-cjk \
    tzdata \
    || error "软件包安装失败"

info "常用工具安装完成"

###############################################################################
# 6. 切换默认 shell 为 zsh
###############################################################################
info "Step 6: 切换默认 shell 为 zsh..."

ZSH_PATH=$(command -v zsh)
if [ -z "$ZSH_PATH" ]; then
    error "zsh 安装失败，无法找到可执行文件"
fi

# 检查当前 shell 是否已经是 zsh
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" = "zsh" ]; then
    info "当前 shell 已经是 zsh，跳过切换"
else
    chsh -s "$ZSH_PATH" || error "切换 shell 失败"
    info "已切换默认 shell 为: $ZSH_PATH"
    warn "请重新登录以使用 zsh"
fi

###############################################################################
# 7. 设置字符集（中文 locale）和时区
###############################################################################
info "Step 7: 配置中文 locale 和时区..."

# 7.1 生成 locale 数据
info "  - 生成 locale 数据..."
sudo sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen || warn "locale-gen 部分失败"

# 7.2 写入系统级默认 locale 配置
info "  - 写入系统 locale 配置..."
sudo tee /etc/default/locale > /dev/null <<'EOF'
LANG=zh_CN.UTF-8
LC_ALL=zh_CN.UTF-8
LANGUAGE="zh_CN:zh"
EOF

# 7.3 设置时区为亚洲/上海
info "  - 设置时区为 Asia/Shanghai..."
sudo timedatectl set-timezone Asia/Shanghai || warn "timedatectl 设置时区失败"

# 7.4 写入当前用户的 shell 配置文件（持久化环境变量）
info "  - 写入用户 shell 配置..."

# 检查 ~/.bashrc 中是否已有相关配置，避免重复写入
if ! grep -q "LANG=zh_CN.UTF-8" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc <<'EOF'

# 中文 locale 配置（由 init-debian.sh 自动添加）
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh
EOF
    info "  - 已追加 locale 配置到 ~/.bashrc"
else
    warn "  - ~/.bashrc 中已存在 locale 配置，跳过写入"
fi

# 7.5 当前终端立即生效（无需重新登录）
info "  - 当前终端立即生效..."
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh

###############################################################################
# 8. 最终验证
###############################################################################
info "Step 8: 验证配置结果..."

echo ""
echo "=== Locale 配置 ==="
locale | grep -E "LANG|LC_ALL|LANGUAGE" || warn "locale 验证失败"

echo ""
echo "=== 时区配置 ==="
timedatectl | grep "Time zone" || warn "时区验证失败"

echo ""
echo "=== Shell 配置 ==="
echo "当前 SHELL: $SHELL"
echo "zsh 路径: $(command -v zsh)"

echo ""
echo "=== 中文显示测试 ==="
TEST_FILE="/tmp/中文测试_$(date +%s).txt"
touch "$TEST_FILE"
ls --show-control-chars -la "$TEST_FILE" && rm -f "$TEST_FILE"

###############################################################################
# 完成
###############################################################################
echo ""
info "========================================"
info "Debian 13 初始化脚本执行完成！"
info "========================================"
echo ""
info "已完成的配置："
echo "  ✓ 软件源更换为腾讯云镜像"
echo "  ✓ 系统软件包已更新"
echo "  ✓ 常用开发工具已安装"
echo "  ✓ 默认 shell 切换为 zsh（重新登录后生效）"
echo "  ✓ 中文 locale 配置完成"
echo "  ✓ 时区设置为 Asia/Shanghai"
echo ""
warn "重要提示："
echo "  1. 请重新登录 SSH 以使用 zsh 作为默认 shell"
echo "  2. 如果使用 Windows Terminal / PuTTY，请确认终端编码为 UTF-8"
echo "  3. 建议安装 Oh My Zsh 增强 zsh 体验："
echo '     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
echo ""
