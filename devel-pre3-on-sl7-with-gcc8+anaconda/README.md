# Building Synergia2 devel-pre3 branch on the an EL7 (SL7, CentOS7) machine with Anaconda Python

These scripts will build the devel-pre3 branch of Synergia on
an EL7 based system which gcc8 compilers and Anaconda3 python.
The system has SCL devtoolset-8 installed.
MPI is provided by the installed openmpi-devel rpm.
HDF5 is provided by hdf5-devel rpm.
GSL is provided by the installed gsl-devel rpm.
The eigen3 library is provided by the installed eigen3-devel rpm.
Anaconda3 is installed in /usr/local/Anaconda3.  Adjust the file `10_create_directories.sh` to change its location.

## Instructions
git clone the `synergia2-provisioning` repository:
```
git clone https://github.com/fnalacceleratormodeling/synergia2-provisioning.git
cd synergia2-repository/devel-pre3-on-sl7-with-gcc8+anaconda
```
Synergia will be built in a tree structure under a root directory which is the value of the
`SYNHOME` variable.
By default, this is `syn2-devel-pre-anaconda` in the user's home directory as specified in the file `10_create_directories.sh`:
```
SYNHOME=${HOME}/syn2-devel-pre3-anaconda
```

Then the remaining files can be executed in numerical order starting from 20.
```
bash -x 20_install-boost.sh
bash -x 22_install-fftw.sh
bash -x 25_install-chef.sh
bash -x 35_install-mpi4py.sh
bash -x 55_install-synergia2.sh
```
The `55_install-synergia2.sh` script accepts an argument:
<dl>
    <dt> <em>overwrite</em> </dt>
    <dd> Erases and redownloads Synergia </dd>
    <dt> <em>reinstall</em> </dt>
    <dd> Reconfigures without downloading (cmake), builds and installs </dd>
</dl>

The libraries and executables will be installed in the `install` subdirectory with binaries installed in `install/bin`, libraries in `install/lib` and Python modules in `install/lib/python3.7/site-packages`.

The installation also creates a setup script in `install/bin/setup.sh` which should be sourced to load all the correct modules and set up path environment variables.
An example is shown below:
```
[user@zlorfik ~]$ . ~/syn2-devel-pre3-anaconda/install/bin/setup.sh
[user@zlorfik ~]$ synergia -i
Python 3.7.6 (default, Jan  8 2020, 19:59:22) 
[GCC 7.3.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import synergia
--------------------------------------------------------------------------
[[585,1],0]: A high-performance Open MPI point-to-point messaging module
was unable to find any relevant network interfaces:

Module: OpenFabrics (openib)
  Host: zlorfik

Another transport will be used instead, although this may result in
lower performance.
--------------------------------------------------------------------------
     ...
     (suppressed warnings)
     ...
>>> 

```
