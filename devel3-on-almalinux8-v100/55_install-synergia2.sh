#!/bin/bash

# ensure directories and environment variables are set
. ./10_create_directories.sh

if [ -z "${PYTHONPATH}" ]
then
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:${SYNINSTALL}/lib64:${SYNINSTALL}/lib64/${PY_VER}/site-packages
else
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:${SYNINSTALL}/lib64:${SYNINSTALL}/lib64/${PY_VER}/site-packages:${PYTHONPATH}
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

    # on zlorfik, the FFTW libraries aren't found correctly without help
    export FFTW_INC=${SYNINSTALL}/include
    export FFTW_DIR=${SYNINSTALL}

#  -DEIGEN3_INCLUDE_DIR=$LOCAL_ROOT/include/eigen3 \
#  -DHDF5_ROOT=$LOCAL_ROOT \


CC=gcc CXX=g++ \
scl enable gcc-toolset-9 "cmake -DCMAKE_INSTALL_PREFIX=${SYNINSTALL} \
  -DFFTW3_INCLUDE_DIR=${FFTW_INC} -DFFTW3_LIBRARIES=${FFTW_DIR}/lib/libfftw3.so -DFFTW3_MPI_LIBRARIES=${FFTW_DIR}/lib/libfftw3_mpi.so -DFFTW3_OMP_LIBRARIES=${FFTW_DIR}/lib/libfftw3_omp.so \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_CUDA=on \
  -DKokkos_ENABLE_OPENMP=on \
  -DALLOW_PADDING=off \
  -DGSV=DOUBLE \
  -DKokkos_ARCH_VOLTA70=on \
  -DCMAKE_CXX_FLAGS="-arch=sm_70" \
  -DCMAKE_CXX_COMPILER=${SYNSRC}/src/synergia/utils/kokkos/bin/nvcc_wrapper \
  -DBUILD_PYTHON_BINDINGS=on \
  -DPYTHON_EXECUTABLE=${PY_EXE} \
  -DSIMPLE_TIMER=off \
  ${SYNSRC}" |& tee synergia2.cmake.out

    if [ $? -eq 0 ]
    then
        echo "synergia2 cmake worked"
    else
        echo "Drat!! synergia2 cmake failed"
        exit 10
    fi

    scl enable gcc-toolset-9 "make VERBOSE=t"  |& tee synergia2.make.out
    if [ $? -eq 0 ]
    then
        echo "Congratulations!! synergia2 is make worked !!!"
    else
        echo "Drat!! something went wrong building synergia2"
        exit 10
    fi

    if  scl enable gcc-toolset-9 "make install" |& tee synergia2.install.out
    then
        echo "Congratulations!! synergia2 is installed!!!"
    else
        echo "Drat!! something went wrong installing synergia2"
        exit 10
    fi

fi # if make_synergia2

# Python modules installation for Synergia is currently broken.  Disable
# the site-packages directory and just use the structure from the build
# directories.
mv ${SYNINSTALL}/lib/${PY_VER}/site-packages/synergia2 ${SYNINSTALL}/lib/${PY_VER}/site-packages/synergia2-ng
PYTHONPATH=${SYNBLD}/src:${PYTHONPATH}

echo "Define these environment variables:"
echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
echo "PYTHONPATH=${PYTHONPATH}"

cat >${SYNINSTALL}/bin/setup.sh <<EOF
#!/bin/bash

# load the mpi module

module load mpi

PATH=${SYNINSTALL}/bin:\${PATH}
if [ -n "\${LD_LIBRARY_PATH}" ]
then
    export LD_LIBRARY_PATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib64:\${LD_LIBRARY_PATH}
else
    export LD_LIBRARY_PATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib64
fi
if [ -n "\${PYTHONPATH}" ]
then
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:${SYNINSTALL}/lib64/${PY_VER}/site-packages:\${PYTHONPATH}
else
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:${SYNINSTALL}/lib64/${PY_VER}/site-packages
fi
EOF

echo "or source file ${SYNINSTALL}/bin/setup.sh"
