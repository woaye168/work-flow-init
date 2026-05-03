#!/bin/bash
###############################################################################
# Debian 13 (Trixie) 一键初始化 - Bootstrap
# Author: woaye
# Description: 安装 Ansible 并运行 playbook 完成全部初始化
###############################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="https://github.com/woaye168/work-flow-init.git"

# 如果不在仓库目录中（curl 方式运行），先 clone 仓库
if [ ! -f "$SCRIPT_DIR/ansible/playbook.yml" ]; then
    echo "[INFO] 下载仓库文件..."
    WORK_DIR="${HOME}/.work-flow-init"
    rm -rf "$WORK_DIR"
    git clone --depth=1 "$REPO_URL" "$WORK_DIR"
    SCRIPT_DIR="$WORK_DIR"
fi

cd "$SCRIPT_DIR"

# 安装 Ansible（如未安装）
if ! command -v ansible-playbook &> /dev/null; then
    echo "[INFO] 安装 Ansible..."
    apt update
    apt install -y ansible
fi

echo "========================================"
echo "  Debian 13 一键初始化 (Ansible)"
echo "========================================"

# 运行 playbook
ansible-playbook \
    -i localhost, \
    -c local \
    ansible/playbook.yml

echo ""
echo "========================================"
echo "  初始化完成"
echo "========================================"
