FROM ubuntu:18.04

# README FIRST!!!
# If you need to make changes to this image, please place them below the OpenCV build
# unless they are required to build OpenCV.
# This is because the OpenCV build is really time consuming, but will remain cached
# if changes are made after it, but not if they are made before.

# Based on https://github.com/shimat/opencvsharp/blob/master/docker/ubuntu.18.04-x64/Dockerfile
# and https://www.learnopencv.com/install-opencv-4-on-ubuntu-18-04/
ENV OPENCV_VERSION=4.3.0

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    software-properties-common \
    wget \
    unzip \
    curl \
    ca-certificates
    #bzip2 \
    #grep sed dpkg 

# Install opencv dependencies
RUN cd ~
RUN apt-get update && apt-get install -y \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    git \
    gfortran \
    libjpeg8-dev \
    libpng-dev \
    software-properties-common
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" && apt-get update && apt-get install -y \
    libjasper1 \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev \
    libv4l-dev

RUN cd /usr/include/linux
RUN ln -s -f ../libv4l1-videodev.h videodev.h
RUN cd /

RUN apt-get install -y \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev libtbb-dev qt5-default \
    libatlas-base-dev \
    libfaac-dev \
    libmp3lame-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libavresample-dev \
    x264 \
    v4l-utils

# Install Python Libraries
# Do we need any of this?
RUN apt-get install -y python3-dev python3-pip python3-testresources
RUN pip3 install pip numpy wheel scipy matplotlib scikit-image scikit-learn ipython dlib

# Setup OpenCV source
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm ${OPENCV_VERSION}.zip && \
    mv opencv-${OPENCV_VERSION} opencv

# Setup opencv-contrib Source
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm ${OPENCV_VERSION}.zip && \
    mv opencv_contrib-${OPENCV_VERSION} opencv_contrib

# Build OpenCV
RUN cd opencv && mkdir build && cd build && \
    cmake \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D ENABLE_CXX11=ON \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_QT=ON \
    -D WITH_OPENGL=ON \
    -D OPENCV_ENABLE_PRECOMPILED_HEADERS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_DOCS=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    .. && make -j$(nproc) && make install && ldconfig
# Usually -j4 on the above line, but hopefully this will use all available CPU cores
######################################################################################
# Finished the really slow bit
######################################################################################

WORKDIR /

# Install dotnet2.2
# This section based on https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#1804-
RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.2 aspnetcore-runtime-2.2

# Install deps for datacore
RUN apt-get install -y libtesseract-dev npm

# Build Leptonica
WORKDIR /
RUN git clone https://github.com/DanBloomberg/leptonica.git
WORKDIR /leptonica
RUN git checkout 1.75.3
RUN mkdir build
WORKDIR /leptonica/build
RUN cmake ..
RUN make -j$(nproc)
RUN make install

# Build Tesseract
WORKDIR /
RUN git clone https://github.com/tesseract-ocr/tesseract.git
WORKDIR /tesseract
RUN git checkout 3.05
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN make install
RUN ldconfig

# Install other useful tools
RUN apt-get install -y nano cron

# copy blank config into container
ADD dataorig /

# Update npm and install pm2
RUN npm install -g n pm2
RUN n latest

# Clone repos
WORKDIR /
RUN git clone https://github.com/stt-datacore/website.git
RUN git clone https://github.com/stt-datacore/image-analysis.git
RUN git clone https://github.com/stt-datacore/bot.git
RUN git clone https://github.com/stt-datacore/asset-server.git
RUN git clone https://github.com/stt-datacore/site-server.git

# Build image-analysis
WORKDIR /image-analysis
RUN dotnet restore
RUN dotnet build
WORKDIR /

# Build asset parser
WORKDIR /asset-server
RUN npm install
# Let it know we don't have anything already downloaded
RUN rm /asset-server/out/data/latestVersion.txt
RUN touch /asset-server/out/data/latestVersion.txt

# Build bot
WORKDIR /bot
RUN npm install
RUN ln -s /data/config/env /bot/.env

WORKDIR /

# Link some libraries into silly places - this needs work
RUN ln -s /usr/local/lib/libtesseract.so.3.0.5 /image-analysis/src/DataCore.Daemon/bin/Debug/netcoreapp2.2/x64/libtesseract3052.so
RUN ln -s /usr/local/lib/libleptonica.so.1.75.3 /image-analysis/src/DataCore.Daemon/bin/Debug/netcoreapp2.2/x64/liblept1753.so

# Create config Dir
RUN mkdir -p /data/config

# Create blank config Dir (contains source files for user to fill)
RUN mkdir -p /dataorig/asset-server
RUN touch /dataorig/runcomplete

# Trained behold data goes here
RUN mkdir /data/traindata
RUN rm -rf /image-analysis/data/traindata
RUN ln -s /data/traindata /image-analysis/data/traindata

# Asset server data goes here
RUN mkdir /data/asset-server
RUN mv /asset-server/out/* /dataorig/asset-server/
RUN rm -rf /asset-server/out
RUN ln -s /data/asset-server /asset-server/out

ADD ./firstrun.sh /firstrun.sh
RUN chmod +x /firstrun.sh
CMD /firstrun.sh
