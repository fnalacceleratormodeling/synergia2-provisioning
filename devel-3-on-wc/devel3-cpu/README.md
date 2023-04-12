## Installation instructions

1. Set up the file names in 10_create_directories.sh

2. For first time install, run:

    `bash 55_install-synergia2.sh`

If you are running `cmake` from the login node, be sure to add `-DMPIEXEC_EXECUTABLE=$(which srun)`.


To reinstall after changing the source, run:

    `bash 55_install-synergia2.sh reinstall`

To download and remake the entire product, run:

    `bash 55_install-synergia.sh overwrite`
