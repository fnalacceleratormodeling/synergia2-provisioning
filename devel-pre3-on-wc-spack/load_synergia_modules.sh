# Load all modules needed by build and run Synergia
module load gnu9
module load openmpi3
module load cuda11
PATH=/work1/accelsim/spack-shared-v2/cmake-3.19.5-Linux-x86_64/bin:$PATH
HOME=${WORKDIR} . /work1/accelsim/spack-shared-v2/spack/share/spack/setup-env.sh
spack env activate synergia-pre3-004
