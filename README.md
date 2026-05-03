# Debian 13 (Trixie) 一键初始化

基于 Ansible 的服务器初始化方案，自动配置软件源、安装常用工具、Docker、Devbox 开发环境、Oh My Zsh、中文 locale 和时区。

## 功能

- 配置**腾讯云镜像源**
- 系统更新和升级（apt update/upgrade）
- 安装常用开发工具（git、vim、htop、jq、zsh 等）
- 安装 **Docker**（腾讯云镜像加速）
- 自动启动 **Devbox** 开发环境容器
- 安装 **Oh My Zsh** + 插件（autosuggestions、syntax-highlighting）
- 配置中文 locale（`zh_CN.UTF-8`）和时区（`Asia/Shanghai`）

## 一键使用

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/woaye168/work-flow-init/main/bootstrap.sh)"
```

**过程说明：**
1. `bootstrap.sh` 自动安装 Ansible
2. 拉取本仓库到 `~/.work-flow-init`
3. 运行 Ansible playbook 完成全部初始化

## 手动使用

```bash
git clone --depth=1 https://github.com/woaye168/work-flow-init.git
cd work-flow-init
bash bootstrap.sh
```

## 文件结构

```
work-flow-init/
├── bootstrap.sh              # 一键入口：安装 Ansible + 运行 playbook
├── ansible/
│   ├── playbook.yml          # 主 playbook（定义所有任务）
│   └── files/                # 配置文件模板
│       ├── apt-sources.list
│       ├── default-locale
│       └── zshrc
├── docker-compose.yml        # Devbox 容器配置
├── configs/                  # 配置文件备份（与 ansible/files 内容一致）
├── scripts/                  # 原始 Shell 脚本（备选方案）
│   ├── setup-sources.sh
│   ├── update-system.sh
│   ├── install-packages.sh
│   ├── install-docker.sh
│   ├── setup-devbox.sh
│   ├── setup-locale.sh
│   ├── setup-zsh.sh
│   └── verify.sh
├── README.md
└── .gitattributes
```

## 环境要求

- Debian 13 (Trixie) 或兼容系统
- `sudo` 权限（脚本中部分操作需要 root）
- 可访问 `mirrors.cloud.tencent.com`

## 安装后访问

脚本完成后：
- 重新登录 SSH 以使用 **zsh + Oh My Zsh**
- 访问 `http://服务器IP:36000` 进入 **Devbox** 开发环境

## 提示

- 脚本使用 Ansible 执行，天然**幂等**（多次运行不会重复安装或报错）
- Windows Terminal / PuTTY 用户请确认终端编码为 UTF-8
- Devbox 容器会自动重启（`restart: unless-stopped`）
- `~/workspace` 目录会挂载到 Devbox 容器的 `/workspace`

## 备选方案（纯 Shell）

如果不想用 Ansible，可以直接运行原始 Shell 脚本：

```bash
git clone --depth=1 https://github.com/woaye168/work-flow-init.git
cd work-flow-init
bash scripts/setup-sources.sh
bash scripts/update-system.sh
# ... 按顺序执行各脚本
```

## License

MIT
