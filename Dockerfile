FROM quay.io/jeani/base_ubuntu_mpich_ucx_cuda:latest

# Authors Jean Iaquinta
# Contact jeani@uio.no
# Version v1.0.0
#
# This is a definition file to build NAMD 3.0 using a base container image with Ubuntu22.04 and MPIch4.2.1 (including support for UCX1.17.0 and Cuda12.1.0)
# It is the responsibility of the user to accept the End User License Agreement and download locally NAMD_3.0_Source.tar.gz (in the same folder as this file)
#

# Copying from user local download of NAMD_3.0_Source.tar.gz (requires accepting EULA)
COPY ./NAMD_3.0_Source.tar.gz /opt/uio/NAMD_3.0_Source.tar.gz

# NAMD version 3.0
RUN tar -x -f /opt/uio/NAMD_3.0_Source.tar.gz -C /usr/local -z && \
    rm /opt/uio/NAMD_3.0_Source.tar.gz

WORKDIR /usr/local/NAMD_3.0_Source

# Charm
RUN tar xf charm-8.0.0.tar && \
    cd charm-8.0.0 && \
    ./build charm++ mpi-linux-x86_64 --with-production 

# FFTW with -fPIC and single-precision support
RUN wget -q -nc --no-check-certificate http://www.fftw.org/fftw-3.3.9.tar.gz && \
    tar -xzvf fftw-3.3.9.tar.gz && \
    cd fftw-3.3.9 && \
    ./configure --enable-float --enable-threads --prefix=/usr/local/NAMD_3.0_Source/fftw CFLAGS="-fPIC" && \
    make -j$(nproc) && make -j$(nproc) install && \
    rm -rf /usr/local/NAMD_3.0_Source/fftw-3.3.9 /usr/local/NAMD_3.0_Source/fftw-3.3.9.tar.gz

# TCL version 8.6.13
RUN wget -q -nc --no-check-certificate http://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64.tar.gz && \
    tar xzf tcl8.6.13-linux-x86_64.tar.gz && \
    mv tcl8.6.13-linux-x86_64 tcl && \
    rm tcl8.6.13-linux-x86_64.tar.gz && \
    wget -q -nc --no-check-certificate http://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64-threaded.tar.gz && \
    tar xzf tcl8.6.13-linux-x86_64-threaded.tar.gz && \
    mv tcl8.6.13-linux-x86_64-threaded tcl-threaded && \
    rm tcl8.6.13-linux-x86_64-threaded.tar.gz

# NAMD
RUN ./config Linux-x86_64-g++ --charm-base /usr/local/NAMD_3.0_Source/charm-8.0.0 --charm-arch mpi-linux-x86_64 && \
    cd Linux-x86_64-g++ && \
    make -j$(nproc) 

ENV PATH=/usr/local/NAMD_3.0_Source/Linux-x86_64-g++:$PATH
