# All In One 远程开发环境

一键初始化 Debian 13 服务器，部署 Docker + Devbox 容器，实现 IDE 直连容器开发。

## 架构

```
本地 IDE ──SSH──▶ 宿主机(Debian) ──port 36000──▶ Devbox 容器
                      22                         22
```

- **宿主机**：Debian 13，运行 Docker，管理容器生命周期
- **Devbox 容器**：开发环境，SSH 暴露到宿主机 36000 端口
- **workspace**：宿主机 `~/workspace` 挂载到容器 `/workspace`，代码持久化

## 一键初始化

在服务器上执行：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/woaye168/work-flow-init/main/bootstrap.sh)"
```

完成后重新登录 SSH 即可使用 zsh。

## IDE 连接容器

使用**登录宿主机的同一套 SSH Key**，连接信息：

| 项 | 值 |
|---|---|
| Host | 服务器公网 IP |
| Port | 36000 |
| User | root |
| Auth | SSH Key（与登录宿主机相同） |

### VSCode

1. 安装 Remote - SSH 插件
2. `Ctrl+Shift+P` → `Remote-SSH: Connect to Host...`
3. 输入：`ssh -p 36000 root@服务器IP`
4. 打开 `/workspace` 开始开发

### JetBrains Gateway

1. New Connection → SSH
2. Host: `服务器IP`, Port: `36000`, User: `root`
3. Authentication: 选择本地私钥文件

### Codebuddy

SSH 配置同上，直接使用即可。

## 文件结构

```
work-flow-init/
├── bootstrap.sh              # 一键入口
├── docker-compose.yml        # Devbox 容器配置
├── ansible/
│   ├── playbook.yml          # 初始化任务
│   └── files/
│       ├── apt-sources.list  # 腾讯云镜像源
│       ├── default-locale    # 中文 locale
│       └── zshrc             # Oh My Zsh 配置
```

## 日常操作

```bash
# 进入容器
ssh -p 36000 root@服务器IP

# 容器内代码目录
cd /workspace

# 宿主机管理容器
docker ps
docker compose restart devbox
docker compose logs -f devbox
```

## 环境要求

- Debian 13 (Trixie) 或兼容系统
- 腾讯云安全组放行 **TCP 22** 和 **TCP 36000**
- 使用 SSH 密钥登录服务器（不支持密码登录）

## License

MIT
