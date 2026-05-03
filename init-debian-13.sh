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
if [ ! -f "$SCRIPT_DIR/docker-compose.yml" ]; then
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

# 按顺序执行各模块
for script in "$SCRIPT_DIR"/scripts/*.sh; do
    if [ -f "$script" ]; then
        echo ""
        echo ">>> $(basename "$script")"
        bash "$script"
    fi
done

echo ""
echo "========================================"
echo "  初始化完成"
echo "========================================"
