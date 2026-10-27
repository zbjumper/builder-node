# AGENTS.md

This file provides guidance to Codex and other AI coding agents when working with this repository.

## MUST

以下规则是强制规则，AI Agent 必须遵守。

* 在对话中，输出结论或者让用户决策时，必须使用中文
* 当需要在项目任意目录创建 `AGENTS.md` 文件时，都要在同目录创建软连接 `CLAUDE.md` 文件：

  ```bash
  ln -s AGENTS.md path/to/CLAUDE.md
  ```
* 同理，当需要创建 `CLAUDE.md` 文件时，必须实际创建 `AGENTS.md`，并创建 `CLAUDE.md` → `AGENTS.md` 的软连接。

## Project Overview

Docker image builder for Node.js applications with multiple Node.js and pnpm version combinations. Each combination has its own Dockerfile under the root directory structure.

## Build Commands

### Build All Variants
```bash
./build.sh
```
Builds all Docker image variants defined in the `DIRS` array. Current version: `0.3.3`

### Build Single Image
```bash
# Build one variant using its Dockerfile path (tag format: see "Version Tagging")
sudo docker build -t builder-node:0.3.3-node24-pnpm9 -f node24/pnpm9/Dockerfile .
```

### Available Variants
- `node22/pnpm9` - Node 22.23.2 + pnpm 9
- `node22/pnpm10` - Node 22.23.2 + pnpm 10
- `node22/pnpm11` - Node 22.23.2 + pnpm 11
- `node22/pnpm12` - Node 22.23.2 + pnpm 12
- `node24/pnpm9` - Node 24.21.0 + pnpm 9
- `node24/pnpm10` - Node 24.21.0 + pnpm 10
- `node24/pnpm11` - Node 24.21.0 + pnpm 11
- `node24/pnpm12` - Node 24.21.0 + pnpm 12

## Architecture

**Directory Structure:**
```
├── node22/
│   ├── pnpm9/Dockerfile
│   ├── pnpm10/Dockerfile
│   ├── pnpm11/Dockerfile
│   └── pnpm12/Dockerfile
└── node24/
    ├── pnpm9/Dockerfile
    ├── pnpm10/Dockerfile
    ├── pnpm11/Dockerfile
    └── pnpm12/Dockerfile
```

**Dockerfile Pattern:**
All Dockerfiles follow the same structure:
1. Base: Alpine-based Node.js image (node:XX.XX.X-alpine3.24)
2. Timezone: Asia/Shanghai
3. Mirror: USTC Alpine mirrors for faster builds in China
4. Build deps: python3, make, g++ (for native modules)
5. pnpm: Installed globally via npm, then build deps removed
6. glab + git: glab 1.124.0 is downloaded from the official GitLab release for the
   image architecture (amd64 or arm64). git is installed explicitly via apk.
   The temporary curl dependency and archive are removed after installation.

**Version Tagging:**
Format: `builder-node:{VERSION}-node{NODE_VER}-pnpm{PNPM_VER}`
Example: `builder-node:0.3.3-node24-pnpm9`

`VERSION` comes from `build.sh`; `NODE_VER` / `PNPM_VER` are taken from the directory name.

**Image Distribution:**
Images are **not** pushed to any registry — `build.sh` only runs `docker build` locally.
Consumers (e.g. GitLab CI) reference the bare tag, and the GitLab Runner resolves it from
its own Docker daemon (`pull_policy: if-not-present`). So after changing a Dockerfile:
bump `VERSION`, rebuild on the Runner host, and only then point the consumer at the new tag —
otherwise the runner won't find it locally and will try to pull it from Docker Hub.

## Adding New Variants

1. Create directory: `node{VERSION}/pnpm{VERSION}/`
2. Copy and adapt a Dockerfile from existing variant
3. Add path to `DIRS` array in `build.sh`
4. Update `VERSION` in `build.sh` if needed
5. Update the version numbers written in this file (Build Commands / Version Tagging)
