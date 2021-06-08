#!/bin/sh

# ensure directories and paths are set
. ./10_create_directories.sh

export MPI4PYSRC=${SRC}/mpi4py

make_mpi4py=true

if $make_mpi4py
then

    if [ -d ${MPI4PYSRC} ]
    then
        echo "mpi4py src already exists, removing it first"
        rm -rf ${MPI4PYSRC}
    fi

    cd ${SRC}

    git clone https://github.com/mpi4py/mpi4py |& tee mpi4py.git-clone.out

    if [ ! -d ${MPI4PYSRC} ]
    then
        echo "mpi4py has not been properly cloned"
        exit 10
    fi

    cd ${SRC}/mpi4py
    MPICC=mpicc MPICXX=mpicxx /usr/bin/python3 setup.py install --prefix=${SYNINSTALL}

    if [ $? ]
    then
        echo "Contratulations, mpi4py is installed"
    else
        echo "Oh NOOO! Something went wrong with mpi4py!!"
	exit 11
    fi
fi
