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
    curl ${BOOSTURL} | tar xjf -
    mv boost* boost


    if [ ! -d ${BOOSTSRC} ]
    then
        echo "boost has not been properly downloaded"
        exit 10
    fi

    cd ${BOOSTSRC}

    ./bootstrap.sh --prefix=${SYNINSTALL} --with-python=${ANACONDA_ROOT}/bin/python3.7m --with-libraries=python,regex,filesystem,system,test,serialization,iostreams |& tee bootstrap.out

    export BOOSTBLD=${BLD}/boost
    mkdir -p ${BOOSTBLD}
 
    ./b2 toolset=gcc cxxflags="-I${ANACONDA_ROOT}/include/python3.7m -std=c++14" --build-dir=${BOOSTBLD} install |& tee b2.out

fi # if make_boost
