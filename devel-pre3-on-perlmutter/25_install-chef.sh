#!/bin/sh

# make sure directories are created and paths set
. ./10_create_directories.sh

export CHEFSRC=${SRC}/chef

export CHEF_INSTALL_DIR=${SYNINSTALL}

make_chef=true

if $make_chef
then

    if [ -d ${CHEFSRC} ]
    then
        #echo "chef already exists.  Won't proceed"
        #exit
        echo "chef src already exists, removing it first"
        #rm -rf ${CHEFSRC}
    fi

    cd ${SRC}

    #git clone -b master https://bitbucket.org/fnalacceleratormodeling/chef.git |& tee chef.git-clone.out

    if [ ! -d ${CHEFSRC} ]
    then
        echo "CHEF has not been properly cloned"
        exit 10
    fi

    CHEFBLD=${BLD}/chef
    mkdir -p ${CHEFBLD}
    cd ${CHEFBLD}


    #cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${CHEF_INSTALL_DIR}"  -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=CC  -DBOOST_ROOT=${SYNINSTALL} -DBUILD_PARSER_MODULES=0 -DPython_FIND_VIRTUALENV=ONLY -DPython3_FIND_VIRTUALENV=ONLY -DBUILD_PYTHON_BINDINGS=1 -DBUILD_SHARED_LIBS=1 -DPYTHON_EXECUTABLE=${PY_EXE} -DUSE_PYTHON_3=1  ${CHEFSRC} |& tee chef.cmake.out

    #FIND_STRATEGY=VERSION finds the system python

    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${CHEF_INSTALL_DIR}"  -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=CC  -DBOOST_ROOT=${SYNINSTALL} -DBUILD_PARSER_MODULES=0 -DPython3_FIND_STRATEGY=LOCATION -DPython3_ROOT_DIR=${CONDA_PREFIX} -DBUILD_PYTHON_BINDINGS=1 -DBUILD_SHARED_LIBS=1 -DPYTHON_EXECUTABLE=${PY_EXE} -DUSE_PYTHON_3=1  ${CHEFSRC} |& tee chef.cmake.out

    if [ $? -eq 0 ]
    then
        echo "CHEF cmake worked"
    else
        echo "Drat!!  CHEF cmake failed"
        exit 10
    fi

    make create_includedir
    make -j 8 VERBOSE=true |& tee chef.make.out
    if [ $? -ne 0 ]
    then
        echo "Oh NOOO! Something went wrong building CHEF!!"
    fi
    
    if make install |& tee chef.test-n-install.out
    then
        echo "Contratulations, CHEF is installed"
    else
        echo "Oh NOOO! Something went wrong with CHEF!!"
    fi
fi  # if $make_chef
