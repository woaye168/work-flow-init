#!/bin/bash
set -euo pipefail

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

info "安装常用工具..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    build-essential git curl wget vim nano htop tree zip unzip p7zip-full \
    net-tools dnsutils iputils-ping socat netcat-openbsd jq zsh \
    openssh-server webp locales fonts-noto-cjk tzdata \
    || error "软件包安装失败"
