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
1. `bootstrap.sh` 自动安装 Ansible（如未安装）
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
├── docker-compose.yml        # Devbox 容器配置
├── ansible/
│   ├── playbook.yml          # 主 playbook（定义所有初始化任务）
│   └── files/                # 配置文件模板
│       ├── apt-sources.list  # 腾讯云 Debian 镜像源
│       ├── default-locale    # 中文 locale 配置
│       └── zshrc             # zsh + Oh My Zsh 配置
├── README.md
├── CLAUDE.md
└── .gitattributes
```

## 配置定制

所有服务器配置文件都在 `ansible/files/` 下，直接编辑即可：

| 文件 | 作用 | 服务器目标路径 |
|------|------|---------------|
| `ansible/files/apt-sources.list` | 软件源配置 | `/etc/apt/sources.list` |
| `ansible/files/default-locale` | 系统 locale | `/etc/default/locale` |
| `ansible/files/zshrc` | zsh 配置 | `~/.zshrc` |
| `docker-compose.yml` | Devbox 容器 | `~/docker-compose.yml` |

## 环境要求

- Debian 13 (Trixie) 或兼容系统
- `sudo` 权限
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

## License

MIT
