## Creating a new spack environment

To create a new spack environment, you first need to log into a worker node
with `HOME` set to the shared directory for our spack installation:

```
HOME=/work1/accelsim/spack-shared-v2 srun -A accelsim  --cpus-per-task=20  --unbuffered --pty  --partition=gpu_gce --nodelist=wcgpu04 --gres=gpu:1  /bin/bash -l
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

You now have the `spack` command available on your path. The steps to make and populate a new spack environment are:

1. `spack env create <name>`
2. `spack add <product1> .. <product n>`
3. `spack concretize`
4. `spack install`
5. `spack install`

Yes, `spack install` appears in this list twice. At least as of the time of this
writing (25 Feb 2021), the first `spack install` will cause the new products
that need to be built and installed to get built and installed, and then the
command will fail. The second install detects that nothing new needs to be
built, and then updates the "view", and succeeds.

The `spack add` command that includes he list of products, and their variants,
in the most recent environment (`synergia-dev-005`) is:

```
spack add  openmpi hdf5+mpi+hl fftw+openmp+mpi eigen gsl py-numpy py-mpi4py python py-pytest py-h5py py-pyparsing py-pip
```

Please update this list, and the current version numbers in these instructions,
whenever you make a new environment.


