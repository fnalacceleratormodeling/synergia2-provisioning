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
        if git clone -b devel-pre3 https://github.com/fnalacceleratormodeling/synergia2.git |& tee synergia2.git-clone.out
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

    if cmake -DBUILD_PYTHON_BINDINGS=1 -DCHEF_DIR=${SYNINSTALL}/lib/chef/cmake -DBOOST_ROOT=${SYNINSTALL} -DUSE_SIMPLE_TIMER=0 -DUSE_PYTHON_3=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=${SYNINSTALL} -DPYTHON_EXECUTABLE=${PY_EXE} ${SYNSRC} |& tee synergia2.cmake.out
    then
        echo "synergia2 cmake worked"
    else
        echo "Drat!! synergia2 cmake failed"
        exit 10
    fi

    if make -j 1 |& tee synergia2.make.out
    then
        echo "Congratulations!! synergia2 is make worked !!!"
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
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:\${PYTHONPATH}
else
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages

export SYNERGIA2DIR=${SYNINSTALL}/lib

fi
EOF

echo "or source file ${SYNINSTALL}/bin/setup.sh"
