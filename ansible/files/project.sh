#!/bin/bash
###############################################################################
# 项目管理 - 交互式同步/创建 GitHub 项目
###############################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CONTAINER="devbox"
WORKSPACE="/workspace"

# 检查 gh
if ! command -v gh &>/dev/null; then
    echo -e "${RED}GitHub CLI 未安装${NC}"
    exit 1
fi

# 检查登录
if ! gh auth status &>/dev/null; then
    echo -e "${YELLOW}未登录 GitHub${NC}"
    echo "请先执行: ${BLUE}gh auth login${NC}"
    echo ""
    echo "推荐方式:"
    echo "  1. 选择 'GitHub.com'"
    echo "  2. 选择 'SSH' 或 'HTTPS'"
    echo "  3. 选择 'Login with a web browser'，按提示完成授权"
    exit 1
fi

GITHUB_USER=$(gh api user -q .login 2>/dev/null)
if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}无法获取 GitHub 用户信息${NC}"
    exit 1
fi

# 检查容器
if ! docker ps | grep -q "$CONTAINER"; then
    echo -e "${RED}容器 $CONTAINER 未运行${NC}"
    exit 1
fi

while true; do
    echo ""
    echo "========================================"
    echo "  项目管理 (${GITHUB_USER})"
    echo "========================================"
    echo ""
    echo "  1) 同步项目 (从 GitHub clone)"
    echo "  2) 新建项目 (GitHub + 本地)"
    echo "  3) 退出"
    echo ""
    read -p "选择: " choice

    case $choice in
        1)
            echo ""
            echo "获取仓库列表..."
            repos=$(gh repo list --limit 50 --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null)
            if [ -z "$repos" ]; then
                echo -e "${YELLOW}没有仓库，或 gh 未正确登录${NC}"
                continue
            fi

            echo "$repos" | nl
            echo ""
            read -p "输入编号 (或按回车取消): " num
            [ -z "$num" ] && continue

            repo=$(echo "$repos" | sed -n "${num}p")
            [ -z "$repo" ] && continue

            repo_name=$(basename "$repo")
            echo ""
            echo -e "${GREEN}克隆 $repo ...${NC}"
            docker exec "$CONTAINER" bash -c "cd $WORKSPACE && git clone https://github.com/$repo.git"
            if [ $? -eq 0 ]; then
                echo ""
                echo -e "${GREEN}完成: $WORKSPACE/$repo_name${NC}"
            else
                echo -e "${RED}克隆失败${NC}"
            fi
            ;;

        2)
            echo ""
            read -p "项目名称: " name
            [ -z "$name" ] && continue

            read -p "描述 (可选): " desc
            read -p "私有仓库? (y/n, 默认 n): " private

            vis="--public"
            [ "$private" = "y" ] && vis="--private"

            echo ""
            echo -e "${GREEN}创建 GitHub 仓库...${NC}"
            gh repo create "$name" $vis --description "$desc" --confirm
            if [ $? -ne 0 ]; then
                echo -e "${RED}创建失败${NC}"
                continue
            fi

            echo -e "${GREEN}初始化本地项目...${NC}"
            docker exec "$CONTAINER" bash -c "
                cd $WORKSPACE &&
                mkdir -p $name &&
                cd $name &&
                git init &&
                git config user.name '$GITHUB_USER' &&
                git config user.email '${GITHUB_USER}@users.noreply.github.com' &&
                git remote add origin https://github.com/$GITHUB_USER/$name.git
            "

            echo ""
            echo -e "${GREEN}完成: $WORKSPACE/$name${NC}"
            echo -e "${BLUE}GitHub: https://github.com/$GITHUB_USER/$name${NC}"
            ;;

        3)
            break
            ;;

        *)
            echo -e "${RED}无效选项${NC}"
            ;;
    esac
done
