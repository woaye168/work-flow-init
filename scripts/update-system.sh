#!/bin/bash
set -euo pipefail

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

info "更新软件包列表..."
sudo apt update || error "apt update 失败"
info "升级已安装软件包..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    || error "apt upgrade 失败"
