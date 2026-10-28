# builder-node

## 概述

本仓库提供用来在 gitlab-runner 中执行的 Docker 镜像文件

## 使用

构建所有 Node.js / pnpm 组合的镜像：

```shell
./build.sh
```

### 在 Apple Silicon Mac 上构建 GitLab CI 镜像

GitLab Runner 如果运行在 x86_64（Intel/AMD）的 Ubuntu 机器上，需要使用 `linux/amd64` 镜像。在 Apple Silicon Mac 上构建并推送时执行：

```shell
./build.sh --push --platform linux/amd64
```

`--platform linux/amd64` 指定目标架构，适用于所有 Node.js / pnpm 组合；`--push` 在全部构建成功后推送镜像。不需要推送时去掉 `--push`。

Mac 会通过模拟构建 x86_64 镜像，速度可能较慢，无需另外准备 x86_64 构建机器。不传 `--platform` 时，Docker 使用默认目标平台，在 Apple Silicon Mac 上通常是 `linux/arm64`。
