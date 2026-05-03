#!/bin/bash
set -euo pipefail

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

info "安装 Oh My Zsh..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth=1 "https://github.com/ohmyzsh/ohmyzsh.git" "$HOME/.oh-my-zsh"
else
    warn "Oh My Zsh 已存在，跳过安装"
fi

info "安装 Zsh 插件..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 "https://github.com/zsh-users/zsh-autosuggestions.git" \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

info "配置 zsh..."
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$REPO_ROOT/configs/zshrc" ~/.zshrc

info "切换默认 shell 为 zsh..."
ZSH_PATH=$(command -v zsh)
if [ -z "$ZSH_PATH" ]; then
    error "zsh 未找到"
fi
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s "$ZSH_PATH" || warn "chsh 失败，请手动切换"
fi
