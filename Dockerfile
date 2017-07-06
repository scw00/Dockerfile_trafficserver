FROM ubuntu:17.04

RUN apt-get update

RUN apt-get install -y          \
            git                 \
            gcc                 \
            autoconf            \
            automake            \
            pkg-config          \
            make                \
            libtool             \
            libpcre3-dev        \
            libcap-dev          \
            libncurses5-dev     \
            openssl             \
            tcl-dev             \
            expat               \
            flex                \
            hwloc               \
            curl                \
            zlib1g-dev          \
            libcunit1-dev       \
            libevent-dev        \
            libssl-dev          \
            libxml2-dev         \
            libjansson-dev      \
            libjemalloc-dev

WORKDIR /opt
USER scw00

RUN ldconfig

RUN git clone --depth 1 https://github.com/tatsuhiro-t/spdylay.git
RUN cd spdylay &&       \
    autoreconf -i &&    \
    automake &&         \
    autoconf &&         \
    ./configure &&      \
    make &&             \
    make install

RUN git clone --depth 1 https://github.com/tatsuhiro-t/nghttp2.git
RUN cd nghttp2 &&               \
    autoreconf -i &&            \
    automake &&                 \
    autoconf &&                 \
    ./configure --enable-app && \
    make &&                     \
    make install

RUN git clone --depth 1 https://github.com/apache/trafficserver.git
RUN cd trafficserver &&                 \
    git submodule update --depth 1 &&   \
    autoreconf -if &&                   \
    ./configure --enable-spdy &&        \
    make &&                             \
    make check &&                       \
    make install

RUN ldconfig
CMD service rsyslog start
