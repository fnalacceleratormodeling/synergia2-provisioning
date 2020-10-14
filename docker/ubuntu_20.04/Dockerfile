FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y git
RUN apt-get install -y g++
RUN apt-get install -y cmake
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-numpy
RUN apt-get install -y python3-pyparsing
RUN apt-get install -y python3-nose
RUN apt-get install -y libboost-python-dev
RUN apt-get install -y libboost-regex-dev
RUN apt-get install -y libboost-system-dev
RUN apt-get install -y libboost-filesystem-dev
RUN apt-get install -y libboost-serialization-dev
RUN apt-get install -y libboost-iostreams-dev
RUN apt-get install -y libboost-test-dev
RUN apt-get install -y openmpi-bin
RUN apt-get install -y libopenmpi-dev
RUN apt-get install -y libhdf5-dev
RUN apt-get install -y python3-mpi4py
RUN apt-get install -y python3-h5py
RUN apt-get install -y python3-tables
RUN apt-get install -y libfftw3-dev libfftw3-mpi-dev
RUN apt-get install -y libeigen3-dev
RUN apt-get install -y libgsl-dev
RUN apt-get install -y vim
RUN mkdir /home/workdir
RUN useradd -ms /bin/bash synergia
USER synergia
ENV SRC=/home/synergia/src
ENV BLD=/home/synergia/build
ENV INSTALL=/home/synergia/install
RUN mkdir ${SRC}
RUN mkdir ${BLD}
RUN mkdir ${INSTALL}
WORKDIR ${SRC}
RUN git clone -b mastern https://bitbucket.org/fnalacceleratormodeling/chef.git
RUN mkdir ${BLD}/chef
WORKDIR ${BLD}/chef
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL} -DBUILD_PARSER_MODULES=0 -DBUILD_PYTHON_BINDINGS=1 -DBUILD_SHARED_LIBS=1 -DUSE_PYTHON_3=1 ${SRC}/chef
RUN make
RUN ctest
RUN make install
#
#
ENV LD_LIBRARY_PATH=${INSTALL}/lib

WORKDIR ${SRC}
RUN git clone -b devel-pre3 https://bitbucket.org/fnalacceleratormodeling/synergia2.git

RUN mkdir ${BLD}/synergia2
WORKDIR ${BLD}/synergia2
RUN cmake -DBUILD_PYTHON_BINDINGS=1 -DCHEF_DIR=${INSTALL}/lib/chef/cmake -DUSE_SIMPLE_TIMER=0 -DUSE_PYTHON_3=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL} -DPYTHON_EXECUTABLE=/usr/bin/python3 ${SRC}/synergia2

RUN make -j 2
RUN make install

ENV PYTHONPATH=${INSTALL}/lib:${INSTALL}/lib/python3.8/site-packages

WORKDIR /home/workdir
