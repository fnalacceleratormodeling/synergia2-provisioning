#!/usr/bin/env bash

make_synergia2=true

JMLHOME=/home/egstern/syn2-devel3

mkdir -p ${JMLHOME}/src
SRC=${JMLHOME}/src
mkdir -p ${SRC}
BLD=${JMLHOME}/build
mkdir -p ${BLD}
SYNINSTALL=${JMLHOME}/install
mkdir -p ${SYNINSTALL}
mkdir -p ${SYNINSTALL}/bin
mkdir -p ${SYNINSTALL}/share

export SRC
export BLD
export SYNINSTALL
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

export PY3_EXE=`which python3`

export SYNSRC=${SRC}/synergia2

if $make_synergia2
then

    if [ ! -d ${SYNSRC} ]
    then
        echo "synergia2 has not been properly cloned"
        exit 10
    fi

    SYNBLD=${BLD}/synergia2
    mkdir -p ${SYNBLD}
    cd ${SYNBLD}

    if cmake -DBUILD_PYTHON_BINDINGS=1 -DUSE_SIMPLE_TIMER=0 \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=${SYNINSTALL} \
        -DPYTHON_EXECUTABLE=${PY3_EXE} \
        -DKokkos_ENABLE_OPENMP=1 \
        -DKokkos_ENABLE_CUDA=0 \
        -DALLOW_PADDING=1 \
        ${SYNSRC} |& tee synergia2.cmake.out
    then
        echo "synergia2 cmake worked"
    else
        echo "Drat!! synergia2 cmake failed"
        exit 10
    fi

    if make -j 2 && make install |& tee synergia2.make.out
    then
        echo "Congratulations!! synergia2 is installed!!!"
    else
        echo "Drat!! something went wrong building or install synergia2"
        exit 10
    fi

fi # if make_synergia2

echo "Define these environment variables:"
echo "LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
echo "PYTHONPATH=${PYTHONPATH}"


cat >${SYNINSTALL}/bin/setup.sh <<EOF
#!/bin/bash
PATH=${SYNINSTALL}/bin:\${PATH}
if [ -n "\${LD_LIBRARY_PATH}" ]
then
    export LD_LIBRARY_PATH=${SYNINSTALL}/lib:\${LD_LIBRARY_PATH}
else
    export LD_LIBRARY_PATH=${SYNINSTALL}/lib
fi
if [ -n "\${PYTHONPATH}" ]
then
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/python3.6/site-packages:\${PYTHONPATH}
else
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/python3.6/site-packages
fi
EOF

echo "or source file ${SYNINSTALL}/bin/setup.sh"
