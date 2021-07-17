# Building Synergia2 devel-pre3 branch on the WC cluster

The WC cluster is a Scientific Linux 7 system. Base gcc-9 and cuda-11 is
Software is accessed with the `module load` command.
Additional Synergia dependencies are built with spack in `/work1/accelsim/spack-shared-v2`.

## Instructions
git clone the `synergia2-provisioning` repository:
```
git clone https://github.com/fnalacceleratormodeling/synergia2-provisioning.git
cd synergia2-repository/devel-pre3-on-wc-spack
```
Synergia will be built in a tree structure under a root directory which is the value of the
`SYNHOME` variable.
By default, this is `syn2-devel-pre` in the user's home directory as specified in the file `10_create_directories.sh`:
```
SYNHOME=${HOME}/syn2-devel-pre3
```
but that area will not generally be reliably accessible to running jobs so
it is recommended to build in a subdirectory of your project space on the `/work1/<your-project>`` or lustre
disk `/wclustre/<your-project>`.

The file `load_synergia_modules.sh` loads all the modules that Synergia uses during build and
execution.
It needs to be sourced.
```
. ./load_synergia_modules.sh
```
Then the remaining files can be executed in numerical order starting from 20.
```
bash -x 20_install-boost.sh
bash -x 25_install-chef.sh
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
[user@wc ~]$ . /work1/accelsim/user/syn2-devel-pre3/install/bin/setup.sh
[user@wc ~]$ synergia -i
Python 3.8.7 (default, May 17 2021, 16:33:06) 
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import synergia
    (suppressed warning messages from Anaconda about to-Python converter)
>>> 

```
