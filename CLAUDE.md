# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is an Ansible-based one-click initialization script for Debian 13 (Trixie) servers. It automates:

1. Configuring Tencent Cloud apt mirrors
2. System update and upgrade
3. Installing common development tools
4. Installing Docker with Tencent Cloud mirror
5. Starting a Devbox development environment container
6. Installing Oh My Zsh with plugins
7. Setting Chinese locale (`zh_CN.UTF-8`) and timezone (`Asia/Shanghai`)

## Architecture

### Entry Point

- `bootstrap.sh` -- One-click entry. Installs Ansible if missing, clones the repo, and runs the playbook.
- Supports two modes:
  1. `git clone` + `bash bootstrap.sh` (recommended)
  2. `bash -c "$(curl -fsSL .../bootstrap.sh)"` (bootstrap auto-clones the repo)

### Ansible Playbook

- `ansible/playbook.yml` -- The main playbook executed by bootstrap.sh. Uses `ansible.builtin` and `community.general` modules.
- Key modules used:
  - `apt` / `apt_repository` -- Package management
  - `locale_gen` / `timezone` -- Locale and timezone
  - `git` -- Clone Oh My Zsh and plugins
  - `copy` -- Deploy config files from `ansible/files/`
  - `service` -- Start Docker
  - `user` -- Switch default shell to zsh

### Config Templates

- `ansible/files/apt-sources.list` -> `/etc/apt/sources.list`
- `ansible/files/default-locale` -> `/etc/default/locale`
- `ansible/files/zshrc` -> `~/.zshrc`
- `docker-compose.yml` -> `~/docker-compose.yml`

## Usage

Run on a Debian 13 system with sudo access:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/woaye168/work-flow-init/main/bootstrap.sh)"
```

Requirements:
- Debian 13 (Trixie) or compatible
- `sudo` privileges
- Internet access to `mirrors.cloud.tencent.com`

## Notes

- The playbook is idempotent -- running multiple times is safe.
- All config files are standalone templates in `ansible/files/` and `docker-compose.yml`.
- After completion, re-login SSH to use zsh as the default shell.
