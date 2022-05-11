# basic setup
source /wclustre/accelsim/powerpc/spack/share/spack/setup-env.sh
# no .spack configs!
export SPACK_DISABLE_LOCAL_CONFIG=true
export SPACK_USER_CACHE_PATH=/tmp/spack
# Load python and set it as spack-python!
export SPACK_PYTHON=/wclustre/accelsim/powerpc/spack/opt/spack/linux-rhel7-power8le/gcc-4.8.5/python-3.9.12-rc7oli4gpfgq5ftlc5exh4nnbarbp6fy/bin/python

# load the compiler
spack load llvm@14.0.3

# load the packages
spack load mpich%clang@14.0.3
spack load hdf5%clang@14.0.3
spack load gsl%clang@14.0.3
spack load eigen%clang@14.0.3
spack load python%clang@14.0.3
spack load py-pybind11%clang@14.0.3
spack load cereal%clang@14.0.3
spack load cmake%clang@14.0.3
