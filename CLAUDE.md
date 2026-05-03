# CLAUDE.md
这是个用来给新开的服务器初始化脚本的项目，你需要用中文回复.

## Project Overview

This repository contains a single Bash script: `init-debian-13.sh`. It is a one-click initialization script for new Debian 13 (Trixie) machines. It automates:

1. Backing up and replacing `/etc/apt/sources.list` with Tencent Cloud mirrors
2. Running `apt update` and `apt upgrade -y`
3. Installing common development tools (build-essential, git, curl, wget, vim, htop, jq, zsh, openssh-server, etc.)
4. Switching the default shell to zsh via `chsh`
5. Configuring Chinese locale (`zh_CN.UTF-8`) and timezone (`Asia/Shanghai`)
6. Verifying the configuration

## Usage

The script is designed to run directly on a Debian 13 system with `sudo` access:

```bash
bash init-debian-13.sh
```

**Requirements:**
- Debian 13 (Trixie) or compatible
- `sudo` privileges (the script uses `sudo` extensively)
- Internet access to reach `mirrors.cloud.tencent.com`

**Notable behaviors:**
- The script sets `set -euo pipefail` for strict error handling
- It backs up the original `/etc/apt/sources.list` before overwriting
- It appends locale settings to `~/.bashrc` idempotently (checks before appending)
- The zsh shell change requires re-login to take effect
