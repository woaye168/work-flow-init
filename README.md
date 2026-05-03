# Debian 13 (Trixie) 一键初始化脚本

自动配置软件源、安装常用工具、设置中文 locale 和时区。

## 功能

- 备份并替换软件源为**腾讯云镜像**
- 自动更新和升级系统软件包
- 安装常用开发工具（git、vim、htop、jq、zsh 等）
- 切换默认 shell 为 **zsh**
- 设置中文 locale（`zh_CN.UTF-8`）和时区（`Asia/Shanghai`）

## 一键使用

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/你的用户名/你的仓库名/main/init-debian-13.sh)"
```

或使用 `wget`：

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/你的用户名/你的仓库名/main/init-debian-13.sh)"
```

## 手动使用

```bash
git clone https://github.com/你的用户名/你的仓库名.git
cd 你的仓库名
bash init-debian-13.sh
```

## 环境要求

- Debian 13 (Trixie) 或兼容系统
- 需要 `sudo` 权限
- 可访问 `mirrors.cloud.tencent.com`

## 安装的软件包

| 包名 | 说明 |
|------|------|
| build-essential | 编译工具链 |
| git | 版本控制 |
| curl / wget | 下载工具 |
| vim / nano | 文本编辑器 |
| htop | 进程查看器 |
| tree | 目录树显示 |
| zip / unzip / p7zip-full | 压缩解压 |
| net-tools / dnsutils / iputils-ping | 网络工具 |
| socat / netcat-openbsd | 网络工具 |
| jq | JSON 处理器 |
| zsh | 更强大的 shell |
| openssh-server | SSH 服务端 |
| webp | WebP 图片工具 |
| locales / fonts-noto-cjk / tzdata | 中文支持 |

## 提示

- 执行完毕后请**重新登录**以使用 zsh 作为默认 shell
- Windows Terminal / PuTTY 用户请确认终端编码为 UTF-8
- 建议安装 Oh My Zsh：
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

## License

MIT
