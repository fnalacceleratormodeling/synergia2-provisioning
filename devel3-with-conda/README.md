## Build the devel3 branch with conda dependencies

### This should work on most systems.

First, make sure that you have `conda` installed and can create
conda environments.
If you need to get conda, see https://github.com/conda-forge/miniforge.

Create a new conda environment to contain the build tools and built Synergia
libraries. Here, I am calling the new environment `synergia`.

```
conda create --name synergia git numpy matplotlib scipy future gsl mpi4py mpi cxx-compiler fortran-compiler pyparsing pytest  "h5py>=2.9=mpi*" "fftw>=3.3.10=mpi*" "petsc>3.19" openpmd-api c-compiler make cmake ninja
```

Activate the new environment

```
conda activate synergia
```

Clone the Synergia code.

```
git clone -b devel3 --recurse-submodules https://github.com/fnalacceleratormodeling/synergia2.git
```

Change directory into the newly created source tree and make a `build` directory
to hold the build products.

```
cd synergia2
mkdir build
```

Change directory into the `build` directory to execute the `cmake` command.

```
cd build
```

The following cmake command builds for an x86_64 or ARM64 CPU. If you are
on an ARM cpu, set -DGSV=DOUBLE and -SALLOW_PADDING=OFF, otherwise use GSV=AVX.

```
cmake -DCMAKE_C_COMPILER=cc -DCMAKE_CXX_COMPILER=c++ -DCMAKE_PREFIX_PATH=$CONDA_PREFIX -DCMAKE_INSTALL_PATH=$CONDA_PREFIX -DCMAKE_BUILD_TYPE=Release -DENABLE_KOKKOS_BACKEND=OpenMP -DGSV=AVX -DALLOW_PADDING=ON -DSIMPLE_TIMER=OFF -DUSE_OPENPMD_IO=OFF -DBUILD_FD_SPACE_CHARGE_SOLVER=OFF -G"Ninja" ..
```

