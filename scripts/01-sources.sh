#!/bin/bash
set -euo pipefail

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

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
