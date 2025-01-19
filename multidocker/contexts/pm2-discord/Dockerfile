FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    apt-transport-https \
    software-properties-common \
    wget \
    unzip \
    curl \
    ca-certificates \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    git \
    nano \
    cron \
    dialog \
    net-tools \
    openssl \
    libssl-dev

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

ARG node_version=v18.20.2
RUN cd /opt \
 && curl -LO https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz \
 && tar xJf node-${node_version}-linux-x64.tar.xz \
 && rm node-${node_version}-linux-x64.tar.xz
ENV PATH=/opt/node-${node_version}-linux-x64/bin:${PATH}

COPY discord-setup.sh .

RUN npm install pm2 -g
RUN pm2 install pm2-discord-webhook

# Don't forward stdout - too spammy
RUN pm2 set pm2-discord-webhook:log false

# Do forward stderr - useful
RUN pm2 set pm2-discord-webhook:error true

# Send messages when service starts or restarts
RUN pm2 set pm2-discord-webhook:start true
RUN pm2 set pm2-discord-webhook:online true
RUN pm2 set pm2-discord-webhook:stop true
RUN pm2 set pm2-discord-webhook:restart true

# Set destinations for webhooks (URLs sourced from env)
ARG PM2_INFO_URL
RUN pm2 set pm2-discord-webhook:webhook_url_logs $PM2_INFO_URL
ARG PM2_ERROR_URL
RUN pm2 set pm2-discord-webhook:webhook_url_errors $PM2_ERROR_URL