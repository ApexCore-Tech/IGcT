
FROM nodejs:18.20.8-bookworm AS builder

ARG HTTP_PROXY=""
ARG ENV=prod
ARG PM=pnpm

ENV ENV=${ENV} \
    PM=${PM}

RUN rm -f /etc/apt/sources.list /etc/apt/sources.list.d/* && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    apt-get update && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    npm install -g pnpm@8.0.0 --registry https://registry.npm.taobao.org

COPY package.json .

RUN pnpm install && pnpm run build

FROM nginx:1.27.0 AS runtime
