#!/bin/bash

set -e

PUSH=false
for arg in "$@"; do
  case "$arg" in
    --push) PUSH=true ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--push]" >&2
      exit 1
      ;;
  esac
done

# 镜像版本
VERSION="1.0.0"
IMAGE_NAME="zbjumper/builder-node"

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

TAGS=()
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
  TAGS+=("${tag}")

  echo "Done: ${tag}"
  echo ""
done

echo "All images built successfully!"

if [ "$PUSH" = true ]; then
  for tag in "${TAGS[@]}"; do
    echo "Pushing: ${tag}"
    sudo docker push "${tag}"
  done
  echo "All images pushed successfully!"
fi
