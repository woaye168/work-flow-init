#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

info "配置腾讯云镜像源..."
if [ -f /etc/apt/sources.list ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.$(date +%Y%m%d_%H%M%S)
fi
sudo cp "$REPO_ROOT/configs/apt-sources.list" /etc/apt/sources.list
