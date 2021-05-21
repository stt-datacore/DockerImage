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
    nginx \
    libboost-all-dev \
    libopencv-dev \
    libtesseract-dev \
    openssl \
    libssl-dev

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
RUN apt-get install -y nodejs

WORKDIR /

# Update npm and install pm2
#RUN npm install -g n
#RUN n latest
#ENV PATH="${PATH}"
RUN npm install -g pm2

# Install nginx
EXPOSE 80 443
RUN rm -v /etc/nginx/nginx.conf
RUN ln -s /data/config/nginx.conf /etc/nginx/nginx.conf
COPY mime.types /etc/nginx/

# copy blank config into container
COPY dataorig /dataorig/

# Clone repos
WORKDIR /
#RUN git clone https://github.com/stt-datacore/website.git #- run script should do this
RUN git clone https://github.com/stt-datacore/cpp-image-analysis.git
RUN git clone https://github.com/stt-datacore/bot.git
RUN git clone https://github.com/stt-datacore/asset-server.git
RUN git clone https://github.com/stt-datacore/site-server.git

# Build asset parser
WORKDIR /asset-server
RUN npm install
RUN npm run build

# Build image-analysis
#WORKDIR /image-analysis
#RUN dotnet restore
#RUN dotnet build
#WORKDIR /
#RUN ln -s /data/config/img-analysis-settings.json /image-analysis/src/DataCore.Daemon/appsettings.json

# Build bot
WORKDIR /bot
RUN npm install
#RUN ln -s /data/config/env /bot/.env

# Build site server
WORKDIR /site-server
RUN npm install
RUN npm run build
#RUN ln -s /data/config/env /site-server/.env
#RUN ln -s /data/profiles /site-server/static

RUN mkdir /cpp-image-analysis/build
WORKDIR /cpp-image-analysis/build
RUN cmake ..
RUN make -j$(nproc)

# Create config Dir
#RUN mkdir -p /data/config

## Create blank config Dir (contains source files for user to fill)
#RUN mkdir -p /dataorig/asset-server
#RUN touch /dataorig/runcomplete
#
## Asset server data goes here
#RUN mkdir /data/asset-server
#RUN mv /asset-server/out/* /dataorig/asset-server/
#RUN rm -rf /asset-server/out
#RUN ln -s /data/asset-server /asset-server/out

COPY ./runme.sh /runme.sh
ENTRYPOINT /runme.sh
