#!/bin/sh

. 10_create_directories.sh

make_fftw=true

if $make_fftw
then
    cd ${SRC}

    FFTWSRC=${SRC}/fftw
    if [ -d ${FFTWSRC} ]
    then
        echo "fftw already exists.  Won't proceed"
        exit
    fi

    FFTWURL="http://www.fftw.org/fftw-3.3.8.tar.gz"
    wget ${FFTWURL} -O- | tar xzvf -
    mv fftw-3* fftw


    if [ ! -d ${FFTWSRC} ]
    then
        echo "fftw has not been properly downloaded"
        exit 10
    fi

    cd ${FFTWSRC}
    ./configure --prefix=${SYNINSTALL} --disable-fortran --enable-mpi --enable-openmp --enable-shared --disable-dependency-tracking |& tee fftw3_configure.out
    make |& tee fftw3_make.out
    make install |& tee fftw3_makeinstall.out

fi # if make_fftw

