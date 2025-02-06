## Build the devel3 branch with conda dependencies

### This should work on most systems.

First, make sure that you have `conda` installed and can create
conda environments.
If you need to get conda, see https://github.com/conda-forge/miniforge.

Create a new conda environment to contain the build tools and built Synergia
libraries. Here, I am calling the new environment `synergia`.

```
conda create --name synergia git numpy matplotlib scipy future gsl mpi4py mpi cxx-compiler fortran-compiler pyparsing pytest  "h5py>=2.9=mpi*" "fftw>=3.3.10=mpi*" c-compiler make cmake ninja
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

