# Building Synergia2 devel3 branch on the an EL8 (CentOS8, AlmaLinux8) machine using gcc11 from gcc-toolset-11 and installed packages

These scripts will build the devel3 branch of Synergia on
an EL8 based system using most packages installed from rpms except for
 MPI/OpenMP enabled FFTW3.
Packages come from the `powertools`,  `plus` and `EPEL` repositories.

With the use of `std::filesystem`, the serialization code will no longer
build with gcc version below 9 so we use compile with gcc-toolset-11 packages.

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
