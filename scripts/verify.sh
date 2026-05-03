#!/bin/bash

info()  { echo -e "\033[0;32m[INFO]\033[0m $1"; }

IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=== 配置验证 ==="
echo "Shell: $(command -v zsh)"
echo "Locale: $(locale | grep LANG | head -1)"
echo "时区: $(timedatectl | grep 'Time zone')"
echo "Oh My Zsh: $([ -d ~/.oh-my-zsh ] && echo '已安装' || echo '未安装')"
echo "Docker: $(docker --version 2>/dev/null || echo '未安装')"
echo "Devbox: $(docker ps --format '{{.Names}}' | grep -q '^devbox$' && echo '运行中' || echo '未启动')"
touch /tmp/中文测试_$(date +%s).txt && ls --show-control-chars /tmp/中文测试_*.txt && rm -f /tmp/中文测试_*.txt
echo ""
info "初始化完成，请重新登录以使用 zsh + Oh My Zsh"
echo "访问 http://${IP}:36000 进入 Devbox"
