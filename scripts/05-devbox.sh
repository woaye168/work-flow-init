#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $1"; }

info "创建 Devbox 开发环境..."
mkdir -p ~/workspace
cp "$REPO_ROOT/docker-compose.yml" ~/docker-compose.yml
cd ~ && docker compose up -d || warn "Devbox 启动失败"
