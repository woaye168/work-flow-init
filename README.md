# Debian 13 (Trixie) 一键初始化脚本

自动配置软件源、安装常用工具、Docker、Devbox 开发环境、Oh My Zsh、中文 locale 和时区。

## 功能

- 备份并替换软件源为**腾讯云镜像**
- 自动更新和升级系统软件包
- 安装常用开发工具（git、vim、htop、jq、zsh 等）
- 安装 **Docker** 并配置腾讯云镜像加速
- 自动启动 **Devbox** 开发环境容器
- 安装 **Oh My Zsh** + 插件（autosuggestions、syntax-highlighting）
- 配置中文 locale（`zh_CN.UTF-8`）和时区（`Asia/Shanghai`）

## 使用方式

### 方式一：git clone（推荐）

```bash
git clone --depth=1 https://github.com/woaye168/work-flow-init.git
cd work-flow-init
bash init-debian-13.sh
```

### 方式二：curl 一键运行

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/woaye168/work-flow-init/main/init-debian-13.sh)"
```

> curl 方式会先自动 clone 仓库到 `~/.work-flow-init`，然后执行各模块。

## 文件结构

```
work-flow-init/
├── init-debian-13.sh       # 主入口脚本
├── docker-compose.yml      # Devbox 容器配置
├── README.md
├── .gitattributes
├── CLAUDE.md
└── scripts/                # 功能模块（按顺序执行）
    ├── 01-sources.sh       # 配置软件源
    ├── 02-system.sh        # 更新系统
    ├── 03-packages.sh      # 安装常用工具
    ├── 04-docker.sh        # 安装 Docker
    ├── 05-devbox.sh        # 启动 Devbox 开发环境
    ├── 06-locale.sh        # 配置中文 locale 和时区
    ├── 07-zsh.sh           # 安装 Oh My Zsh 和插件
    └── 08-verify.sh        # 验证配置结果
```

## 环境要求

- Debian 13 (Trixie) 或兼容系统
- 需要 `sudo` 权限
- 可访问 `mirrors.cloud.tencent.com`

## 安装后访问

脚本完成后：
- 重新登录 SSH 以使用 **zsh + Oh My Zsh**
- 访问 `http://服务器IP:36000` 进入 **Devbox** 开发环境

## 提示

- Windows Terminal / PuTTY 用户请确认终端编码为 UTF-8
- Devbox 容器会自动重启（`restart: unless-stopped`）
- `~/workspace` 目录会挂载到 Devbox 容器的 `/workspace`

## License

MIT
