#

# Use Ubuntu 18.04 as a base image
FROM ubuntu:18.04

# Install general tools and libraries
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    build-essential \
    apt-utils \
    sudo \
    locales \
    git \
    cmake

RUN apt-get update && apt-get install -y \
        git \
        jq \
        wget \
        xz-utils

#Make a HYPSO user
RUN adduser --disabled-password --gecos '' hypso && \
    usermod -aG sudo hypso && \
    echo "hypso ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN locale-gen en_US.UTF-8 && update-locale

# Install necessary libraries to download, compile and install nng
RUN apt-get update && apt-get install -y \
    ninja-build \
    python

# Compile and install nng. Remove source files afterwards
RUN git clone https://github.com/nanomsg/nng /home/hypso/nng && \
    cd /home/hypso/nng && \
    git checkout 8d3b53879bdaf1b1d617a40633a66eea9eb345ef && \
    mkdir build && \
    cd build && \
    cmake -G Ninja .. && \
    ninja && \
    ninja install && \
    rm -rf /home/hypso/nng

# Download dependencies of building libsocketcan
Run apt-get install -y \
    autotools-dev \
    autoconf \
    libtool

# Download packages required to build hypso-sw
RUN apt-get install -y \
    check \
    make


# Download packages for cross compiling
RUN apt-get install -y \
    binutils-arm-linux-gnueabihf \
    gcc-arm-linux-gnueabihf

# Packages for producing doxygen output. F.ex callgraphs
RUN apt-get update && apt-get install -y \
    doxygen \
    graphviz

COPY entrypoint.sh /entrypoint.sh
COPY check.sh /check.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
