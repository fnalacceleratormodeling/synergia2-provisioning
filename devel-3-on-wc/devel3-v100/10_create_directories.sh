#!/bin/sh
# Create the directories and set environment variables

module purge > /dev/null 2>&1
source /wclustre/accelsim/spack_051624/envs/synergia-devel3-gpu-v100-ompi.sh
module load gcc/12.3.0

# The following directory will be the top level of the Synergia build tree
#SYNHOME=${HOME}/syn2-devel3-v100
# alternative location:
SYNHOME=${WORKDIR}/devel3-v100-test

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
PY_EXE=$(type -p python3)

# the name of the directory under which site-packages will be installed
export PY_VER=$( ${PY_EXE} -c 'import sys; print("python{}.{}".format(sys.version_info.major, sys.version_info.minor))' )
echo "python version string is " $PY_VER
