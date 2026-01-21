FROM ubuntu:26.04

# SET ENVIRONMENT VARIABLES
# assume 4 threads are available to speed up
ARG NUM_THREADS=6
ENV RISCV=/opt/riscv
ENV PATH="$PATH:${RISCV}/bin"

WORKDIR ${RISCV}

RUN apt-get update && \
    apt-get install -y \
        automake \
        bash \
        curl \
        device-tree-compiler\
        flex bison \
        g++ \
        gawk \
        gcc \
        git \
        libexpat-dev\
        libglib2.0-dev \
        libgmp-dev \
        libisl-dev \
        libmpc-dev \
        libmpfr-dev \
        libncurses-dev \
        libpixman-1-dev \
        make \
        ninja-build \
        pkg-config \
        python3 \
        python3-pip \
        python3-sphinx \
        python3-venv \
        texinfo \
        wget \
        zlib1g-dev \
        zlib1g-dev &&\
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global url."https://github.com/".insteadOf git://github.com/

# TOOLCHAIN
RUN git clone https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain && \
    sed -i 's/https/git/' .gitmodules && git submodule sync && \
    ./configure --prefix=${RISCV} --enable-multilib \
        --with-multilib-generator="rv32e-ilp32e--;rv32i-ilp32--;rv32im-ilp32--;rv32iac-ilp32--;rv32imac-ilp32--;rv32imafc-ilp32f--;rv32imafdc-ilp32d--;rv64i-lp64--;rv64ic-lp64--;rv64iac-lp64--;rv64imac-lp64--;rv64imafdc-lp64d--;rv64im-lp64--;" && \
    make --jobs ${NUM_THREADS} && \
    make install && cd ${RISCV} && \
    rm -rf ${RISCV}/riscv-gnu-toolchain

# elf2hex
RUN git clone https://github.com/sifive/elf2hex.git && \
    cd elf2hex && \
    autoreconf -i && \
    ./configure --target=riscv64-unknown-elf --prefix=${RISCV} && \
    make && \
    make install && \
    rm -rf ${RISCV}/elf2hex

# Spike
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim && \
    mkdir riscv-isa-sim/build && \
    cd riscv-isa-sim/build && \
    ../configure --prefix=$RISCV --enable-commitlog && \
    make --jobs ${NUM_THREADS} && \
    make install && \
    rm -rf ${RISCV}/riscv-isa-sim

# QEMU
RUN git clone --recursive https://github.com/qemu/qemu && \
    cd qemu && \
    ./configure --target-list=riscv64-softmmu --prefix=${RISCV}  && \
    make --jobs ${NUM_THREADS} && \
    make install && \
    rm -rf ${RISCV}/qemu