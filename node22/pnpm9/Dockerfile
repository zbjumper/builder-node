FROM node:22.23.2-alpine3.24

LABEL maintainer="Bill Zhang <zbjumper@gmail.com>"

# 默认编码为 UTF-8
ENV LANG=C.UTF-8

ENV TIME_ZONE=Asia/Shanghai

RUN echo 'http://mirrors.ustc.edu.cn/alpine/v3.24/main' > /etc/apk/repositories \
    && echo 'http://mirrors.ustc.edu.cn/alpine/v3.24/community' >>/etc/apk/repositories \
    && apk update && apk add tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

RUN apk add --no-cache --virtual .build-deps \
    python3 \
    make \
    g++ \
    && npm install -g pnpm@9 \
    && apk del .build-deps

# 按镜像架构下载固定版本的 glab，git 显式安装供 CI 使用
ARG ARG GLAB_VERSION=1.126.0
RUN apk add --no-cache git ca-certificates \
    && apk add --no-cache --virtual .glab-download curl \
    && case "$(apk --print-arch)" in \
         x86_64) glab_arch=amd64 ;; \
         aarch64) glab_arch=arm64 ;; \
         *) echo "Unsupported glab architecture" >&2; exit 1 ;; \
       esac \
    && curl -fL --retry 3 "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_${glab_arch}.tar.gz" -o /tmp/glab.tar.gz \
    && tar -xzf /tmp/glab.tar.gz -C /usr/local/bin --strip-components=1 bin/glab \
    && rm /tmp/glab.tar.gz \
    && apk del .glab-download \
    && glab --version
