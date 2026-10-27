#!/bin/bash

set -e

# 镜像版本
VERSION="1.0.0"
IMAGE_NAME="builder-node"

# Dockerfile 目录列表
DIRS=(
  "node22/pnpm11"
  "node22/pnpm10"
  "node22/pnpm9"
  "node22/pnpm12"
  "node24/pnpm11"
  "node24/pnpm10"
  "node24/pnpm9"
  "node24/pnpm12"
)

for dir in "${DIRS[@]}"; do
  # 从路径提取 node 版本 (e.g., "node22")
  node_ver=$(echo "$dir" | cut -d'/' -f1)
  # 从路径提取 pnpm 版本 (e.g., "pnpm9")
  pm_ver=$(echo "$dir" | cut -d'/' -f2)

  tag="${IMAGE_NAME}:${VERSION}-${node_ver}-${pm_ver}"

  echo "=========================================="
  echo "Building: ${tag}"
  echo "Dockerfile: ${dir}/Dockerfile"
  echo "=========================================="

  sudo docker build -t "${tag}" -f "${dir}/Dockerfile" .

  echo "Done: ${tag}"
  echo ""
done

echo "All images built successfully!"
