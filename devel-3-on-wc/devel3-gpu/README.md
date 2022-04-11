## Installation instructions

1. Set up the file names in 10_create_directories.sh

2. For first time install, run:

    `bash 55_install-synergia2.sh`

To reinstall after changing the source, run:

    `bash 55_install-synergia2.sh reinstall`

followed by

    `bash 65_write-setupsh.sh`

This will write a setup file in the install/bin directory that will load
modules and set environment variables to run Synergia programs and execute
tests.

To download and remake the entire product, run:

    `bash 55_install-synergia.sh overwrite`
