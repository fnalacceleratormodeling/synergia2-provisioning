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
        rm -rf ${CHEFSRC}
    fi

    cd ${SRC}

    git clone -b master https://bitbucket.org/fnalacceleratormodeling/chef.git |& tee chef.git-clone.out

    if [ ! -d ${CHEFSRC} ]
    then
        echo "CHEF has not been properly cloned"
        exit 10
    fi

    CHEFBLD=${BLD}/chef
    mkdir -p ${CHEFBLD}
    cd ${CHEFBLD}

#    if cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${CHEF_INSTALL_DIR}"  -DBOOST_ROOT=${SYNINSTALL} -DGSL_ROOT_DIR=${GSL_DIR} -DFFTW3_INCLUDE_DIR=${FFTW_INC} -DFFTW3_LIBRARY_DIRS=${FFTW_DIR} -DFFTW3_LIBRARIES=${FFTW_DIR}/lib/libfftw3.so -DBUILD_PARSER_MODULES=0 -DBUILD_PYTHON_BINDINGS=1 -DBUILD_SHARED_LIBS=1 -DUSE_PYTHON_3=1  ${CHEFSRC} |& tee chef.cmake.out

    # Fortunately, FFTW3 is installed under the same prefix as BOOST
    if cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${CHEF_INSTALL_DIR}"  -DFFTW3_INCLUDE_DIR=${BOOST_ROOT}/include -DFFTW3_LIBRARIES=${BOOST_ROOT}/lib/libfftw3.so -DBUILD_PARSER_MODULES=0 -DBUILD_PYTHON_BINDINGS=1 -DBUILD_SHARED_LIBS=1 -DUSE_PYTHON_3=1  ${CHEFSRC} |& tee chef.cmake.out
    then
        echo "CHEF cmake worked"
    else
        echo "Drat!!  CHEF cmake failed"
        exit 10
    fi

    make create_includedir
    make -j 4 VERBOSE=true |& tee chef.make.out
    if [ $? -ne 0 ]
    then
        echo "Oh NOOO! Something went wrong building CHEF!!"
    fi
    
    if  ctest -j 2 && make install |& tee chef.test-n-install.out
    then
        echo "Contratulations, CHEF is installed"
    else
        echo "Oh NOOO! Something went wrong with CHEF!!"
    fi
fi  # if $make_chef
