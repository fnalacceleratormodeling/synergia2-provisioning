We have a shared installation, through spack, the infrastructure needed to
build Synergia devel-3, building on a worker node.

## Access the worker node

Access to the worker nodes is done from we.fnal.gov. The following command
obtains a shell session on an interactive worker node:

```
HOME=/work1/accelsim/$(id -un) srun -A accelsim  --cpus-per-task=20  --unbuffered --pty  --partition=gpu_gce --nodelist=wcgpu04 --gres=gpu:1  /bin/bash -l
```

You may need to change wcgpu04 to another node number (wcgpu03 -- wcgpu06).

Next we load the required modules, and make available spack and the most recent cmake:

```
module load cuda11/11.1.1
module load gnu9/9.3.0
module load openmpi3
source /work1/accelsim/spack-shared-v2/spack/share/spack/setup-env.sh
export PATH=/work1/accelsim/spack-shared-v2/cmake-3.19.5-Linux-x86_64/bin:$PATH
```

We have used a *spack environment* to obtain a consistent set of modules.
`spack env list` will list the available spack environments. Choose the
most recent to set up.

```
spack env activate synergia-dev-005
```

This establishes the environment in which you can build Synergia.

