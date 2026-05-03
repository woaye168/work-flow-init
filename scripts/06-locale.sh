#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $1"; }

info "配置中文 locale..."
sudo sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen || warn "locale-gen 部分失败"
sudo cp "$REPO_ROOT/configs/default-locale" /etc/default/locale
sudo timedatectl set-timezone Asia/Shanghai || warn "设置时区失败"
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh
