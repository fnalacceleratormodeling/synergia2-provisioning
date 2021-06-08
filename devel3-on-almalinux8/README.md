# Building Synergia2 devel3 branch on the an EL8 (CentOS8, AlmaLinux8) machine with using gcc8 and installed packages

These scripts will build the devel3 branch of Synergia on
an EL8 based system using most packages installed from rpms.
We use gcc8.4 installed by dnf.
The cmake binary version > 3.15 has previous been downloaded and installed on the PATH.
These additional packages are also installed from rpm:

* `eigen3-devel`
* `openmpi-devel`
* `gsl-devel`
* `hdf5-devel`
* `python36-numpy`
* 

## PYTHON scripts do not currently work!!!!

## Instructions
git clone the `synergia2-provisioning` repository:
```
git clone https://github.com/fnalacceleratormodeling/synergia2-provisioning.git
cd synergia2-repository/devel3-on-almalinux8
```
Synergia will be built in a tree structure under a root directory which is the value of the
`SYNHOME` variable.
By default, this is `syn2-devel3` in the user's home directory as specified in the file `10_create_directories.sh`:
```
SYNHOME=${HOME}/syn2-devel3
```

Then the remaining files can be executed in numerical order starting from 20.
```
bash -x 22_install-fftw.sh
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

The libraries and executables will be installed in the `install` subdirectory with binaries installed in `install/bin`, libraries in `install/lib` and Python modules in `install/lib/python3.6/site-packages`.

The installation also creates a setup script in `install/bin/setup.sh` which should be sourced to load all the correct modules and set up path environment variables.
An example is shown below:
```
