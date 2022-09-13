#!/bin/bash
#
# Choose a CUDA device based on ${OMPI_COMM_WORLD_LOCAL_RANK}
#
ngpu=`nvidia-smi -L | grep UUID | wc -l`
mygpu=$((${OMPI_COMM_WORLD_LOCAL_RANK} % ${ngpu} ))
export CUDA_VISIBLE_DEVICES=${mygpu}
exec $*
