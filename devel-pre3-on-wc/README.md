# Building Synergia2 devel-pre3 branch on the WC cluster

The WC cluster is a Scientific Linux 7 system and has base scientific software from the
[OpenHPC project](http://openhpc.community).
Software is accessed with the `module load` command.
Python3.7 is provided with the anaconda3 module.
GNU toolchain version 8.3 is provided by the gnu8 module.

## Instructions
git clone the `synergia2-provisioning` repository:
```
git clone https://github.com/fnalacceleratormodeling/synergia2-provisioning.git
cd synergia2-repository/devel-pre3-on-wc
```
Synergia will be built in a tree structure under a root directory which is the value of the
`SYNHOME` variable specified in the file `10_create_directories.sh`:
```
SYNHOME=${HOME}/syn2-devel-pre3
```


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
bash -x 30_install-eigen3.sh
bash -x 35_install-mpi4py.sh
bash -x 55_install-synergia2.sh
```

The libraries and executables will be installed in the 
