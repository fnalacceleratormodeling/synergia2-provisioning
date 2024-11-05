#!/bin/sh
# Create the directories and set environment variables

# The following directory will be the top level of the Synergia build tree
SYNHOME=${SCRATCH}/saul/syn2-devel-pre3

# modules
module load PrgEnv-gnu
#module load gcc/11.2.0  # problems with Boost and gcc/12.x?
#module load cudatoolkit/11.7
module load python
module load cray-fftw
export CMAKE_PREFIX_PATH=$FFTW_ROOT
module load cray-hdf5
module load cmake

mkdir -p ${SYNHOME}/src
export SRC=${SYNHOME}/src
mkdir -p ${SYNHOME}/build
export BLD=${SYNHOME}/build
mkdir -p ${SYNHOME}/install
export SYNINSTALL=${SYNHOME}/install

# put install directory in paths
if echo ${PATH} | grep -qv syn2-dev
then
    PATH=${SYNINSTALL}/bin:$PATH
fi

if echo ${LD_LIBRARY_PATH} | grep -qv syn2-dev
then
    if [ -z ${LD_LIBRARY_PATH} ]
    then
        export LD_LIBRARY_PATH=${SYNINSTALL}/lib
    else
        export LD_LIBRARY_PATH=${SYNINSTALL}/lib:$LD_LIBRARY_PATH
    fi
fi

# the python executable
PY_EXE=`which python`

# the name of the directory under which site-packages will be installed
export PY_VER=$( ${PY_EXE} -c 'import sys; print("python{}.{}".format(sys.version_info.major, sys.version_info.minor))' )
echo "python version string is " $PY_VER
