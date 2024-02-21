#!/bin/bash

# ensure directories and environment variables are set
. ./10_create_directories.sh

if [ -z "${PYTHONPATH}" ]
then
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages
else
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:${PYTHONPATH}
fi

export SYNSRC=${SRC}/synergia2

make_synergia2=true

overwrite=0
reinstall=0
download=1

if $make_synergia2
then
    while [ $# -gt 0 ]
    do
        if [ $# -gt 0 -a  "$1" = "reinstall" ]
        then
            reinstall=1
	    echo "reinstall: $reinstall should be 1"
            shift
        elif [ $# -gt 0 -a  "$1" = "overwrite" ]
        then
            overwrite=1
	    echo "overwrite: $overwrite should be 1"
            shift
	else
	    echo "arguments can be overwrite or reinstall"
	    exit 20
        fi
    done

    if [ $reinstall -ne 0 ]
    then
	echo "Reconfiguring and installing"
        download=0
    fi
    if [ $overwrite -ne 0 ]
    then
	echo "overwriting and installing"
        rm -rf ${SYNSRC}
        download=1
    fi

    if [ -d ${SYNSRC} ]
    then
	if [ $reinstall -ne 0 ]
        then
            download=0
            echo "reconfiguring existing Synergia source"
        else
            echo "synergia2 already exists.  Do:"
            echo "    $0 reinstall"
            exit
        fi
    else
        download=1
    fi

    #exit 20
    cd ${SRC}

    if [ $download -ne 0 ]
    then
        if git clone -b devel3 --recurse-submodules https://github.com/fnalacceleratormodeling/synergia2.git |& tee synergia2.git-clone.out
        then
            echo "You got synergia2!"
        else
            echo "Drat!  Something went wrong downloading synergia2"
            exit 10
        fi
    fi

    if [ ! -d ${SYNSRC} ]
    then
        echo "synergia2 has not been properly cloned"
        exit 10
    fi

    SYNBLD=${BLD}/synergia2
    mkdir -p ${SYNBLD}
    cd ${SYNBLD}


# If you are not building on a host with the GPU you
# must give the architecture in the cmake line, such as
# for V100:
#  -DKokkos_ARCH_VOLTA70=on
#  -DCMAKE_CXX_FLAGS="-arch=sm_70"
#
# otherwise it should be automatically detected.

CC=gcc CXX=g++ \
cmake -DCMAKE_INSTALL_PREFIX=${SYNINSTALL} \
  -DCMAKE_BUILD_TYPE=Release \
  -DPYTHON_EXECUTABLE=${PY_EXE} \
  -DBUILD_FD_SPACE_CHARGE_SOLVER=ON \
  -DUSE_OPENPMD_IO=ON \
  -DUSE_EXTERNAL_OPENPMD=ON \
  -DENABLE_KOKKOS_BACKEND=CUDA \
  -DUSE_EXTERNAL_KOKKOS=ON \
  -DUSE_EXTERNAL_CEREAL=ON \
  -DUSE_EXTERNAL_PYBIND11=ON \
  -DALLOW_PADDING=OFF \
  -DGSV=DOUBLE \
   ${SYNSRC} |& tee synergia2.cmake.out

    if [ $? -eq 0 ]
    then
        echo "synergia2 cmake worked"
    else
        echo "Drat!! synergia2 cmake failed"
        exit 10
    fi

    make -j 8 VERBOSE=t |& tee synergia2.make.out
    if [ $? -eq 0 ]
    then
        echo "Congratulations!! synergia2 make worked !!!"
    else
        echo "Drat!! something went wrong building synergia2"
        exit 10
    fi

    if  make install |& tee synergia2.install.out
    then
        echo "Congratulations!! synergia2 is installed!!!"
    else
        echo "Drat!! something went wrong installing synergia2"
        exit 10
    fi

fi # if make_synergia2


echo "Creating file ${SYNINSTALL}/bin/setup.sh with script 65_write_setupsh.sh"
echo "source this file for the proper environment"

bash 65_write_setupsh.sh
