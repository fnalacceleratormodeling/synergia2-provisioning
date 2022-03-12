## Build Synergia3 on SL7 using Conda Forge for dependencies.

* Download and install Conda Forge using the miniforge installer available https://github.com/conda-forge/miniforge
* Create an environment to hold all the package called @synergia-base@

<pre>
conda create --name synergia-base numpy matplotlib future gsl mpi4py mpi cxx-compiler fortran-compiler openblas pytest bison flex "h5py>=2.9=mpi*" "fftw>=3.3.10=mpi*" c-compiler cmake ninja
</pre>

* Adjust the target directory in the file @10_create_directories.sh@
* Download and build Synergia 3 by sourcing the file @55_install-synergia2.sh@

<pre>
. 55_install-synergia2.sh
</pre>
