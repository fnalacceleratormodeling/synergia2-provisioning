## Installation instructions for building on v100

1. Set up the file names in 10_create_directories.sh

2. For first time install, run:

    `bash 55_install-synergia2.sh`

To reinstall after changing the source, run:

    `bash 55_install-synergia2.sh reinstall`

To download and remake the entire product, run:

    `bash 55_install-synergia.sh overwrite`

Create the environment setup file.

    `bash 65_write_setupsh.sh`

Either use the following submit script (by adding the executable name) submit jobs to run on wilson cluster:
    `submit_wrapper_ompi.sh`

or set the environment as set by the submit script before subitting a job via srun directly. 

For using the installation scripts, you need to obtain an allocation for the V100 nodes by:
   `srun -A ACCOUNT_NAME -t 01:00:00 --unbuffered --pty --gres=gpu:v100:1 --nodes=1 -p gpu_gce /bin/bash`

If building on the login nodes, please add additional architecture flags as necessary.
