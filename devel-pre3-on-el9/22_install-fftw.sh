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

    FFTWURL="https://www.fftw.org/fftw-3.3.10.tar.gz"
    curl --insecure "${FFTWURL}" | tar xzvf -
    mv fftw-3* fftw


    if [ ! -d ${FFTWSRC} ]
    then
        echo "fftw has not been properly downloaded"
        exit 10
    fi

    cd ${FFTWSRC}
    ./configure --prefix=${SYNINSTALL} --disable-fortran --enable-mpi --enable-openmp --enable-shared --disable-dependency-tracking  |& tee fftw3_configure.out
    make |& tee fftw3_make.out
    make install |& tee fftw3_makeinstall.out

fi # if make_fftw

