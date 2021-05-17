## Creating a new spack environment

To create a new spack environment, you first need to log into a worker node
with `HOME` set to the shared directory for our spack installation.
The following command, run from `wc.fnal.gov`, obtains an interactive shell on
an appropriate worker node (with a V100 GPU).

```
HOME=/work1/accelsim/spack-shared-v2 srun -A accelsim  --cpus-per-task=20  --unbuffered --pty  --partition=gpu_gce --constraint=v100 --gres=gpu:1  /bin/bash -l
```

Next we load the required modules, and make available spack and the most recent cmake:

```
module load cuda11/11.1.1
module load gnu9/9.3.0
module load openmpi3
module load texlive/2019   # to support matplotlib use
source /work1/accelsim/spack-shared-v2/spack/share/spack/setup-env.sh
export PATH=/work1/accelsim/spack-shared-v2/cmake-3.19.5-Linux-x86_64/bin:$PATH
```

You now have the `spack` command available on your path.
You can use the command `spack env list` to list the spack environments currently available.

Sometimes you want to create an environment based on another environment, adding a few and
perhaps removing a few specs. To find out how another environment was created, you can 
activate that environment and then query it. Here's how to do so:

1. `spack env list`            # list the available environments
2. `spack env activate <environment name>` # activate the named environment
3. `spack find`                # list the contents of the active environment

The output of `spack find` has three parts:

1. The name of the environment.
2. A listing of the *root specs* (defined below).
3. A listing of all the spec installed in the environment, and their versions.

The *root specs* are the specs that were directly installed to create the environment.
All the other installed specs were installed as dependencies of one of the root specs.
This listing of the root specs includes those qualifiers that were supplied when
concretizing (or installing) the specs. They can be cut and pasted into a new `spack add`
command, more fully described below. If you have activated an environment, before you create
a new one, you have to remember to deactivate the current environment, using
`spack env deactivate`.

The steps to make and populate a new spack environment are:

1. `spack env create <name>`
2. **Edit the `spack.yaml` file in the newly-created environment**. # see note 1 below
2. `spack env activate <name>`
3. `spack add <product1> .. <product n>`
4. `spack concretize`    # see note 2 below 
5. `spack install`       # see note 3 below
6. `spack install`

**Note 1** Spack environments are not *by default* built in a coherent fashion; that is,
spack does not *by default* make sure all packages are compatible. To make spack create
coherent environments, edit the `spack.yaml` file in the top-level of the environment
to contain the parameter and value: `concretization: together`. This should appear at
the same level as does the `specs` entry:

    spack:
        concretization: together

**Note 2** The `spack concretize` command is very likely to produce one or more warnings.
Warnings of the form:

    Warning: [...] Skipping external package: [package spec]

can be ignored. They are just spack telling you that the packages we have
told spack are available as part of the host system are being used, rather
than built anew.

**Note 3** The first `spack install` command is most likely to result in a error.
If it does, the solution is to execute a second `spack install` command.

At least as of the time of this
writing (12 May 2021), the first `spack install` will cause the new products
that need to be built and installed to get built and installed, and then the
command will fail. The second install detects that nothing new needs to be
built, and then updates the "view", and succeeds. It is most likely to
generate more warnings, again due to the system-installed products we are
using (and not building).

**End of notes**

After creating a new environment, it appears to be necessary to set
the *group write* permission for all the files in the new directory.

```
chmod -R g+w $SPACK_ROOT/var/spack/environments/
```

