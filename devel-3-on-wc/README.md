We have a shared installation, through spack, the infrastructure needed to
build Synergia devel-3, building on a worker node.

Note that these are *not* the instructions for creating a new spack environment;
see [Creating a new environment](creating-a-new-environment.md).

## Access the worker node

Access to the worker nodes is done from `wc.fnal.gov`. The following command
obtains a shell session on an interactive worker node, with `HOME` set to the right value.
You also should specify `--constraint` to get the type of GPU you are looking for; for example, to get a machine with a `v100` GPU, use:
```
HOME=/work1/accelsim/$(id -un) srun -A accelsim  --cpus-per-task=20  --unbuffered --pty  --partition=gpu_gce --constraint=v100 --gres=gpu:1  /bin/bash -l
```
## Useful SLURM commands

Allocating worker nodes and scheduling jobs on them is controlled by the SLURM resource management system.
An overview with specific Wilson Cluster information is [here](https://computing.fnal.gov/wilsoncluster/slurm-job-scheduler/).
Some example commands for running jobs are [here](slurm-commands.md).



## Set up the working environment

Next we load the required modules, and make available spack and the most recent cmake:

```
module load cuda11/11.1.1
module load gnu9/9.3.0
module load openmpi3
module load texlive/2019  # To support matplotlib use
source /work1/accelsim/spack-shared-v2/spack/share/spack/setup-env.sh
export PATH=/work1/accelsim/spack-shared-v2/cmake-3.19.5-Linux-x86_64/bin:$PATH
```

We have used a *spack environment* to obtain a consistent set of modules.
`spack env list` will list the available spack environments. Choose the
most recent to set up.

```
spack env activate synergia-dev-010
```

This establishes the environment in which you can build Synergia.

The commands are collected in the file `setup-env.sh` which should be sourced
before building or running Synergia applications.

Directories in this project are:

* `devel3-cpu` CPU only
* `devel3-gpu` GPU and CPU

