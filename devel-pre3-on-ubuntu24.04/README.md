## Building on ubuntu 22.04

Install all the good packages with apt

edit the file 10_create_directories.sh to set SYNHOME to the directory
that will receive the src, build and install.

1. bash 25_instell_chef.sh

2. bash 55_install_synergia2.sh

Source is cloned into ${SYNHOME}/src/chef and ${SYNHOME}/src/synergia2

Build products are in ${SYNHOME}/build/chef and ${SYNHOME}/build/synergia2

Libraries are installed in ${SYNHOME}/install.

Good packages are

```
g++-13
cmake
libboost-dev --install-suggests
libfftw3-dev
libfftw3-mpi3
openmpi-bin
libopenmpi-dev
libeigen3-dev
libgsl-dev
libpython3-dev
libhdf5-dev
libeigen3-dev
python3-numpy
python3-pyparsing
python3-nose
python3-mpi4py
