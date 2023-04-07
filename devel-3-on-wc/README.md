We have a shared installation, through spack, the infrastructure needed to
build Synergia devel-3, building on a worker node.

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

## Supported architectures

The commands are collected in the file `setup-env.sh` which should be sourced
before building or running Synergia applications.

Directories in this project are:

* `devel3-cpu` CPU only
* `devel3-p100` P100-GPUs
* `devel3-v100` V100-GPUs

# Misc
Note that these are *not* the instructions for creating a new spack environment;
see [Creating a new environment](creating-a-new-environment.md).

