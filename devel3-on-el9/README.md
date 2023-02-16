# Building Synergia2 devel3 branch on an EL9 based OS.

These scripts will build the devel3 branch of Synergia on
an EL9 based system (RHEL-9, AlmaLinux-9, RockyLinux-9) using
packages installed from rpms except for  MPI/OpenMP enabled FFTW3.

Packages come from the `EPEL` and CRB repositories.

Adjust the install directory in the file 10_create_directories.sh.
This file is sourced by the other files.  The default installation directory
is `$HOME/syn2-devel3`.

Execute files in order:

```
bash 22_install-fftw.sh
bash 55_install-synergia.sh
```

The `55_install-synergia2.sh` script accepts an argument:
<dl>
    <dt> <em>overwrite</em> </dt>
    <dd> Erases and redownloads Synergia </dd>
    <dt> <em>reinstall</em> </dt>
    <dd> Reconfigures without downloading (cmake), builds and installs </dd>
</dl>

The libraries and executables will be installed in the `install` subdirectory with binaries installed in `install/bin`, libraries in `install/lib` and Python modules in `install/lib/python3.6/site-packages`.

The installation also creates a setup script in `install/bin/setup.sh` which should be sourced to load all the correct modules and set up path environment variables.

This is a script which will install the necessary packages on a minimal
EL9 system such as a vagrant box.

```

# install import synergia packages

# crb is the name of the code-ready-builder repository on AlmaLinux. It
# might have a different name in different distributions.
sudo dnf config-manager --set-enabled crb # epel depends on crb
sudo dnf upgrade -y
sudo dnf install -y epel-release
sudo dnf install -y \
    patch rsync tar \
    gcc-c++ \
    make \
    git \
    cmake \
    gsl-devel \
    python3-devel \
    python3-numpy \
    python3-scipy \
    python3-pytest \
    openmpi-devel \
    python3-mpi4py-openmpi \
    python3-h5py-openmpi \
    hdf5-openmpi-devel

sudo alternatives --install /usr/bin/python python /usr/bin/python3 10

```