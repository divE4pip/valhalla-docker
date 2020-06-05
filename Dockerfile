FROM ubuntu:18.04

env HOME=/build
env NODEJS_INCLUDE_DIRS=$HOME/.nvm/versions/node/v10.15.0/include

RUN  apt-get update
RUN  apt-get upgrade -y

RUN  apt-get install -y mc git \
       cmake make libtool pkg-config g++ gcc jq lcov protobuf-compiler vim-common libboost-all-dev libboost-all-dev libcurl4-openssl-dev zlib1g-dev liblz4-dev libprotobuf-dev


#if you plan to compile with data building support, see below for more info

RUN  apt-get install -y libgeos-dev libgeos++-dev libluajit-5.1-dev libspatialite-dev libsqlite3-dev luajit wget
RUN if [[ $(grep -cF bionic /etc/lsb-release) > 0 ]]; then  apt install -y libsqlite3-mod-spatialite; fi

#if you plan to compile with python bindings, see below for more info

RUN apt-get install -y python-all-dev curl


#if you plan to compile with node bindings, run
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

ENV NVM_DIR="$HOME/.nvm"
ENV NODE_VERSION=10.15.0

RUN . $NVM_DIR/nvm.sh && nvm install 10 && nvm use install 10 && nvm use 10 # must use node 8.11.1 and up because of N-API

RUN ln -s /root/.nvm/versions/node/v10.15.0/include/node/node.h /usr/include/node.h
RUN ln -s /root/.nvm/versions/node/v10.15.0/include/node/uv.h /usr/include/uv.h
RUN ln -s /root/.nvm/versions/node/v10.15.0/include/node/v8.h /usr/include/v8.h


WORKDIR $HOME

RUN git clone https://github.com/valhalla/valhalla.git

# Clone and build prime_server

WORKDIR $HOME

RUN git clone https://github.com/kevinkreiser/prime_server.git


# grab some standard autotools stuff
RUN  apt install -y autoconf automake libtool make gcc g++ lcov
# grab curl (for url de/encode) and zmq for the awesomeness
RUN  apt install -y libcurl4-openssl-dev libzmq3-dev libczmq-dev

WORKDIR $HOME/prime_server

# dont forget submodules
RUN git submodule update --init --recursive
# standard autotools:
RUN ./autogen.sh
RUN ./configure
RUN make test -j8
RUN  make install

RUN echo -e "\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/" >> /etc/profile
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

WORKDIR $HOME/valhalla

RUN . $NVM_DIR/nvm.sh && npm install --ignore-scripts

RUN git submodule update --init --recursive
RUN mkdir build
WORKDIR build
RUN . $NVM_DIR/nvm.sh && cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make -j$(nproc)
RUN make install

