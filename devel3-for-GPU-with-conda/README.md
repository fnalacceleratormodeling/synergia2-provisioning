## Build the devel3 branch using CUDA for nVidia GPUS with conda dependencies

### This should work on most systems, tested on Fermilab EAF

First, make sure that you have `conda` installed and can create
conda environments.
If you need to get conda, see https://github.com/conda-forge/miniforge.

Create a new conda environment to contain the build tools and built Synergia
libraries. Here, I am calling the new environment `synergia`.

```
conda create --name synergia git numpy matplotlib scipy future gsl mpi4py mpi cxx-compiler fortran-compiler "cuda-nvcc>12.4.0" "cuda-libraries-dev>12.4.0" "cuda-cudart-dev>12.4.0" "cuda-toolkit>12.4.0" pyparsing pytest  "h5py>=2.9=mpi*" "fftw>=3.3.10=mpi*" "petsc>3.19" openpmd-api c-compiler make cmake ninja
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

The following `cmake` command configures building with CUDA.

```
cmake -DCMAKE_PREFIX_PATH=$CONDA_PREFIX -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX -DCMAKE_BUILD_TYPE=Release -DENABLE_KOKKOS_BACKEND=CUDA -DGSV=DOUBLE -DALLOW_PADDING=OFF -DUSE_EXTERNAL_KOKKOS=OFF -DSIMPLE_TIMER=OFF -DUSE_OPENPMD_IO=OFF -DBUILD_FD_SPACE_CHARGE_SOLVER=OFF -G"Ninja" ..
```

Note the `..` at the end of the `cmake` command.

Build and install the libraries and python modules:

```
ninja install
```

or limit the number of cores to use

```
ninja -j 4 install
```

Test the install

```
ctest
```

### Running a synergia script

Example Synergia scripts are in the examples subdirectory.
After the installation, scripts may be run by activating the `synergia` conda
environment and running the script with python.

Run an example:

```
cd examples/fodo
python fodo.py
```

Plot some results using provided scripts

```
python ../../../src/analysis_tools/diag_plot.py diag_full.h5 x_std y_std
```

### Note for the EAF
If you add the ipykernel package to the conda environment then Synergia will be available as a notebook.
