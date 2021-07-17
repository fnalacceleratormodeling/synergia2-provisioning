#!/bin/sh
# Create the directories and set environment variables

# The following directory will be the top level of the Synergia build tree
SYNHOME=${WORKDIR}/syn2-devel-pre3

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

module load gnu9
module load openmpi3
module load cuda11
PATH=/work1/accelsim/spack-shared-v2/cmake-3.19.5-Linux-x86_64/bin:$PATH
HOME=${WORKDIR} . /work1/accelsim/spack-shared-v2/spack/share/spack/setup-env.sh
spack env activate synergia-pre3-004

# the python executable
PY_EXE=`which python3`

# the name of the directory under which site-packages will be installed
export PY_VER=$( ${PY_EXE} -c 'import sys; print("python{}.{}".format(sys.version_info.major, sys.version_info.minor))' )
echo "python version string is " $PY_VER
