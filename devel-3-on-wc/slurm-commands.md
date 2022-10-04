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
```
HOME=${WORKDIR} srun -A accelsim -N 1 --cpus-per-task=16 -p cpu_gce --unbuffered --pty /bin/bash
```
This is good if you are going to want to do a building or even interactive computing on a worker node.

### Allocate and start an interactive shell allocating a single v100 gpu
```
HOME=${WORKDIR} srun -A accelsim -N 1 --cpus-per-task=20 -p gpu_gce --constraint=v100 --unbuffered --pty --gres=gpu:1 /bin/bash
```
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

### To run MPI jobs you should supply the `--mpi=pmix_v3` parameter
```
HOME=${WORKDIR} srun -A accelsim -N 1 -n 1 --cpus-per-task=16 -p cpu_gce --mpi=pmix_v3 ${WORKDIR}/what_is_omp_num_threads
```

### Here is how you would run the `fodo_cxx` executable from the head node.
```
HOME=${WORKDIR} srun -A accelsim -N 1 -n 1 --cpus-per-task=16 -p cpu_gce --mpi=pmix_v3 ${WORKDIR}/devel3-cpu/build/synergia2/examples/fodo_cxx/fodo_cxx
```
This runs on one 16 core CPU box with 1 MPI task using 16 threads. The run environment has to be set up prior to running this command.

### Run the two MPI tasks of same executable, each getting 8 threads.
 ```
 HOME=${WORKDIR} srun -A accelsim -N 1 -n 2 --cpus-per-task=8 -p cpu_gce --mpi=pmix_v3 ${WORKDIR}/devel3-cpu/build/synergia2/examples/fodo_cxx/fodo_cxx
```

### Accessing the node with Pascal GPU and NVLINK
```
HOME=${WORKDIR} srun -A accelsim -N 1 --cpus-per-task=28 -p gpu_gce  --constraint=p100nvlink --unbuffered --pty --gres=gpu:1 /bin/bash
```

### Running `ctest` on the GPU node
```
HOME=${WORKDIR} srun -A accelsim -N 1  --cpus-per-task=4 -p gpu_gce --constraint=v100 --gres=gpu:1 --mpi=pmix_v3 ctest
```
You need to set up the environment beforehand, and `cd` to `build/synergia2`.


### Running a GPU simulation
Note that unlike ctest, the simulation program won't work unless you have a reservation because the GPU libraries only become available after a reservation is requested.
```
salloc -A accelsim -N 1 -n 1 -p gpu_gce --constraint=v100 --gres=gpu:1
srun -A accelsim -N 1 -n 1 --mpi=pmix_v3 -p gpu_gce --constraint=v100 --gres=gpu:1 fodo_cxx
```
Sample output:
```
[egstern@wc fodo_cxx]$ salloc -A accelsim -N 1 -n 1 -p gpu_gce --constraint=v100 --gres=gpu:1
salloc: Granted job allocation 317633
'abrt-cli status' timed out

[egstern@wc fodo_cxx]$ srun -A accelsim -N 1 -n 1 --mpi=pmix_v3 -p gpu_gce --constraint=v100 --gres=gpu:1 fodo_cxx
Kokkos::OpenMP::initialize WARNING: OMP_PROC_BIND environment variable not set
  In general, for best performance with OpenMP 4.0 or better set OMP_PROC_BIND=spread and OMP_PLACES=threads
  For best performance with OpenMP 3.1 set OMP_PROC_BIND=true
  For unit testing set OMP_PROC_BIND=false
gridx: 32
gridy: 32
gridz: 128
macroparticles: 1048576
real_particles: 2.94e+12
Read lattice, length: 20, 4 elements
[begin,1]  quadrupole fodo_1: at=0, k1=0.0714285714285714, l=2, yoshida_order=2, propagator_type=yoshida
[1,end]  quadrupole fodo_1: at=0, k1=0.0714285714285714, l=2, yoshida_order=2, propagator_type=yoshida
[begin,4]  drift fodo_2: at=2, l=8
[4,end]  drift fodo_2: at=2, l=8
[begin,1]  quadrupole fodo_3: at=10, k1=-0.0714285714285714, l=2, yoshida_order=2, propagator_type=yoshida
[1,end]  quadrupole fodo_3: at=10, k1=-0.0714285714285714, l=2, yoshida_order=2,
.
.
.
Propagator: turn 8/inf., time = 0.010s, macroparticles = (1048576) / ()
Propagator: turn 9/inf., time = 0.010s, macroparticles = (1048576) / ()
Propagator: turn 10/inf., time = 0.010s, macroparticles = (1048576) / ()
Propagator: maximum number of turns reached
Propagator: total time = 0.611s
.
.
.
```

### You can also run ctest with the GPU version
```
srun -A accelsim -N 1 -n 1 --mpi=pmix_v3 -p gpu_gce --constraint=v100 --gres=gpu:1 ctest
```
Sample output:
```
[egstern@wc synergia2]$ srun -A accelsim -N 1 -n 1 --mpi=pmix_v3 -p gpu_gce --constraint=v100 --gres=gpu:1 ctest
Test project /work1/accelsim/egstern/devel3-v100/build/synergia2
      Start  1: test_hdf5_file_mpi_1
 1/56 Test  #1: test_hdf5_file_mpi_1 ......................   Passed    1.91 sec
      Start  2: test_hdf5_file_mpi_2
 2/56 Test  #2: test_hdf5_file_mpi_2 ......................   Passed    3.32 sec
      Start  3: test_hdf5_file_mpi_3
 
 .
 .
 .
 
 56/56 Test #56: test_space_charge_3d_open_hockney_mpi_1 ...***Failed    1.24 sec

96% tests passed, 2 tests failed out of 56

Total Test time (real) = 171.96 sec

The following tests FAILED:
         17 - test_kokkos_1 (Failed)
         56 - test_space_charge_3d_open_hockney_mpi_1 (Failed)
Errors while running CTest
srun: error: wcgpu04: task 0: Exited with exit code 8
```
