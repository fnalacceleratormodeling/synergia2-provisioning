## Useful SLURM commands for building and running Synergia on the Wilson Cluster

Many of these commands start with a `HOME=$WORKDIR`.
This is because when you lose access to your /nashome resident home directory when
you log into a worker node.
The best place to put files that will be accessed from worker nodes is in a subdirectory of
`/work1/accelsim`.
I typically set that directory into environment variable `WORKDIR`.
Changing HOME to another directory will prevent the login shell from warning you about an
inaccessible home.

### Allocate and start an interactive shell on a single cpu node utilizing all cores
    HOME=${WORKDIR} srun -A accelsim -N 1 --cpus-per-task=16 -p cpu_gce --unbuffered --pty /bin/bash
This is good if you are going to want to do a building or even interactive computing on a worker node.

### Allocate and start an interactive shell allocating a single v100 gpu
    HOME=${WORKDIR} srun -A accelsim -N 1 --cpus-per-task=20 -p gpu_gce --constraint=v100 --unbuffered --pty --gres=gpu:1 /bin/bash
Working on the node that contains the GPU lets you execute command line utilities that access the GPU and can be convenient.

### Figure out how many threads there are on a machine
    srun -A accelsim -N 1 -n 1 --cpus-per-task=16 -p cpu_gce ${WORKDIR}/what_is_omp_num_threads
I have the program what_is_omp_num_threads which can tell me how many threads are available. Here is an example run:
```
[egstern@wc egstern]$ srun -A accelsim -N 1 -n 1 --cpus-per-task=16 -p cpu_gce ${WORKDIR}/what_is_omp_num_threads
srun: job 86840 queued and waiting for resources
srun: job 86840 has been allocated resources
number of threads is 16
max number of threads is 16
The value of _OPENMP is 201511
```



