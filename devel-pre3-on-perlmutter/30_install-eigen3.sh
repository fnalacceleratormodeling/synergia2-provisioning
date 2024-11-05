#!/usr/bin/env bash

# create directories and set paths
. ./10_create_directories.sh

export EIGENSRC=${SRC}/eigen

make_eigen=true

if $make_eigen
then

    if [ -d ${EIGENSRC} ]
    then
        echo "eigen3 src already exists, removing it first"
        rm -rf ${EIGENSRC}
    fi

    cd ${SRC}

    git clone https://gitlab.com/libeigen/eigen.git |& tee eigen.git-clone.out

    if [ ! -d ${EIGENSRC} ]
    then
        echo "EIGEN has not been properly cloned"
        exit 10
    fi

    EIGENBLD=${BLD}/build
    mkdir -p ${EIGENBLD}
    cd ${EIGENBLD}

    if cmake -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=CC -DCMAKE_INSTALL_PREFIX=${SYNINSTALL} ${EIGENSRC} |& tee eigen.cmake.out
    then
	echo "eigen cmake worked"
    else
	echo "Drat!! eigen cmake filed"
	exit 10
    fi
	
    make install |& tee eigen-make-install.out
    if [ $? -ne 0 ]
    then
        echo "Oh NOOO! Something went wrong installing eigen!!"
    else
        echo "Congratulations, eigen is installed"
    fi
fi
