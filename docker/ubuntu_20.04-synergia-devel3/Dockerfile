FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update -y \
    && apt-get -y install \
        apt-utils \
        cmake \
        g++ \
        git \
        libfftw3-dev \
        libfftw3-mpi-dev \
        libgsl-dev \
        libhdf5-dev \
	libhdf5-mpi-dev \
        libopenmpi-dev \
        ninja-build \
	python-is-python3 \
        python3-dev \
        python3-h5py \
        python3-matplotlib \
        python3-mpi4py \
        python3-numpy \
        python3-pip \
        python3-pyparsing \
        python3-pyqt5 \
	python3-h5py \
        python3-pytest \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

  
RUN mkdir /home/workdir \
  && useradd -ms /bin/bash synergia \
  && mkdir -p /tmp/xdg \
  && chown -R synergia /tmp/xdg \
  && chmod 0700 /tmp/xdg

USER synergia
ENV SRC=/home/synergia/src
ENV BLD=/home/synergia/build
ENV INSTALL=/home/synergia/install
ENV PATH=${INSTALL}/bin:${PATH}
ENV LD_LIBRARY_PATH=${INSTALL}/lib
ENV PYTHONPATH=${INSTALL}/lib:${INSTALL}/lib/python3.8/site-packages

ENV XDG_RUNTIME_DIR=/tmp/xdg

RUN mkdir ${SRC} \
  && mkdir ${BLD} \
  && mkdir ${INSTALL} \
  && mkdir ${INSTALL}/bin \
  && mkdir ${INSTALL}/share

WORKDIR ${SRC}
RUN echo "echo there"

RUN git clone -b devel3 --recursive https://github.com/fnalacceleratormodeling/synergia2.git \
  && mkdir ${BLD}/synergia2
WORKDIR ${BLD}/synergia2

RUN cmake -DCMAKE_INSTALL_PREFIX=${INSTALL} \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_KOKKOS_BACKEND=OpenMP \
  -DALLOW_PADDING=ON \
  -DSIMPLE_TIMER=OFF \
  ${SRC}/synergia2 \
  && make -j 2 \
  && make install

WORKDIR /home/workdir
