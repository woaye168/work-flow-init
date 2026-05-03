#!/bin/bash
###############################################################################
# Debian 13 (Trixie) 新机器一键初始化脚本
# Author: woaye
# Description: 自动配置软件源、安装常用工具、Docker、Devbox、Oh My Zsh、中文 locale 和时区
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="https://github.com/woaye168/work-flow-init.git"

# 如果不在仓库目录中（curl 方式运行），先 clone 仓库
if [ ! -f "$SCRIPT_DIR/configs/docker-compose.yml" ]; then
    echo "[INFO] 下载仓库文件..."
    WORK_DIR="${HOME}/.work-flow-init"
    rm -rf "$WORK_DIR"
    git clone --depth=1 "$REPO_URL" "$WORK_DIR"
    SCRIPT_DIR="$WORK_DIR"
fi

cd "$SCRIPT_DIR"

echo "========================================"
echo "  Debian 13 一键初始化"
echo "========================================"

# 显式定义执行顺序，避免依赖文件名排序
STEPS=(
    setup-sources.sh
    update-system.sh
    install-packages.sh
    install-docker.sh
    setup-devbox.sh
    setup-locale.sh
    setup-zsh.sh
    verify.sh
)

for step in "${STEPS[@]}"; do
    script="$SCRIPT_DIR/scripts/$step"
    if [ -f "$script" ]; then
        echo ""
        echo ">>> $step"
        bash "$script"
    else
        echo "[WARN] 脚本不存在，跳过: $step"
    fi
done

echo ""
echo "========================================"
echo "  初始化完成"
echo "========================================"
