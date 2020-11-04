#!/bin/bash

. ./10_create_directories.sh

make_boost=true

if $make_boost
then
    cd ${SRC}

    BOOSTSRC=${SRC}/boost
    if [ -d ${BOOSTSRC} ]
    then
        echo "boost already exists.  Won't proceed"
        exit
    fi

    BOOSTURL="https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.bz2"
    wget ${BOOSTURL} -O- | tar xjf -
    mv boost* boost


    if [ ! -d ${BOOSTSRC} ]
    then
        echo "boost has not been properly downloaded"
        exit 10
    fi

    cd ${BOOSTSRC}

    echo "SYNINSTALL: " ${SYNINSTALL}
    echo "PY_EXE: " ${PY_EXE}

    # In order to build boost with python3, I had to create this
    # user-config.jam in the home directory
    echo "Creating ~/user-config.jam"
    echo "using python : 3.6 : /usr/bin/python3 : /usr/include/python3.6m : ${HOME}/.local/lib ;" >${HOME}/user-config.jam

    scl enable devtoolset-9 './bootstrap.sh --prefix=${SYNINSTALL} --with-python=${PY_EXE} --with-python-version=3.6 --with-libraries=python,regex,filesystem
,system,test,serialization,iostreams |& tee bootstrap.out'

    # if things didn't work for some reason, this will create just the
    # boost-python library
    #scl enable devtoolset-9 './bootstrap.sh --prefix=${SYNINSTALL} --with-python=${PY_EXE} --with-python-version=3.6 --with-libraries=python |& tee bootstrap.out'

    export BOOSTBLD=${BLD}/boost
    mkdir -p ${BOOSTBLD}

    scl enable devtoolset-9 './b2 toolset=gcc cxxflags="-std=c++14" --build-dir=${BOOSTBLD} install |& tee b2.out'

fi # if make_boost
