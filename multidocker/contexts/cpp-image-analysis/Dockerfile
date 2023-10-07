ARG ALPINE_VERSION
FROM datacore/pm2-discord as development

ENV LANG=C.UTF-8

WORKDIR /traindata
RUN mkdir train

WORKDIR /usr/src/dcimageanalysis
COPY --from=source . .

RUN apk add --no-cache --virtual .build \
  build-base \
  pkgconfig \
  cmake \
  coreutils \
  gcc \
  g++ \
  git \
  make \
  unzip \
  linux-headers && \
  apk update && apk upgrade && apk --no-cache add \
  libc-dev \
  tesseract-ocr-dev \
  tesseract-ocr \
  leptonica-dev \
  openssl-dev && \
  cd /usr/src && \
  wget https://github.com/opencv/opencv/archive/4.3.0.zip && \
  unzip -q 4.3.0.zip && rm 4.3.0.zip && \
  cd /usr/src/opencv-4.3.0 && mkdir build && cd build && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -DBUILD_LIST=core,imgproc,imgcodecs,features2d,flann \
    -D ENABLE_CXX11=ON \
    -D WITH_V4L=OFF \
    -D WITH_QT=OFF \
    -D WITH_OPENGL=OFF \
    -D OPENCV_ENABLE_PRECOMPILED_HEADERS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_DOCS=OFF \
    .. \
  && \
  make -j$(nproc) && make install && rm -rf /usr/src/opencv-4.3.0 && \
  cd /usr/src && \
    wget https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.zip && \
    unzip -q boost_1_73_0.zip && rm boost_1_73_0.zip && mv boost_1_73_0 boost && \
    cd /usr/src/dcimageanalysis && \
    mkdir build && cd build && cmake -DDC_BOOST_SRC=/usr/src/boost .. && make -j$(nproc) && cd .. && rm -rf /usr/src/boost && \
  apk del .build

WORKDIR /usr/src/dcimageanalysis/build 
CMD ./imserver

FROM development as production

CMD pm2-runtime start "./imserver --jsonpath=/sitebuild/structured/ --trainpath=/traindata/train/ --datapath=/usr/src/dcimageanalysis/data/ --asseturl=http://NginxServer/assets/" --name "imageAnalysis"
