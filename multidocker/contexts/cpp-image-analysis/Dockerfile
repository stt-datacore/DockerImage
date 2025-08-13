FROM datacore/pm2-discord AS development
#FROM ubuntu:20.04

ENV LANG=C.UTF-8

WORKDIR /usr/src/dcimageanalysis
COPY --from=source . .

WORKDIR /traindata
RUN mkdir train
RUN cp /usr/src/dcimageanalysis/data . -r

WORKDIR /usr/src/dcimageanalysis

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


RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN mkdir ./build
WORKDIR /usr/src/dcimageanalysis/build
RUN cmake ..
RUN make -j$(nproc)

WORKDIR /usr/src/dcimageanalysis/build
CMD ./imserver --jsonpath=/sitebuild/structured/ --trainpath=$CPP_TRAIN_PATH --datapath=$CPP_DATA_PATH --asseturl=$ASSETS_URL

FROM development AS production
RUN pm2 set pm2-discord-webhook:process_name imageAnalysis
CMD pm2-runtime start "./imserver --jsonpath=/sitebuild/structured/ --trainpath=$CPP_TRAIN_PATH --datapath=$CPP_DATA_PATH --asseturl=$ASSETS_URL" --name "imageAnalysis"
