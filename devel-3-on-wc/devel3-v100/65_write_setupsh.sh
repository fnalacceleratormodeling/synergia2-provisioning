#!/bin/bash

. 10_create_directories.sh

cat >${SYNINSTALL}/bin/setup.sh <<EOF
#!/bin/bash

# set up environment

module purge > /dev/null 2>&1
module load gcc/12.3.0

source /wclustre/accelsim/spack_013024/envs/synergia-devel3-gpu-v100-ompi.sh

PATH=${SYNINSTALL}/bin:\${PATH}
if [ -n "\${LD_LIBRARY_PATH}" ]
then
    export LD_LIBRARY_PATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib64:\${LD_LIBRARY_PATH}
else
    export LD_LIBRARY_PATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib64
fi
if [ -n "\${PYTHONPATH}" ]
then
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages:\${PYTHONPATH}
else
    export PYTHONPATH=${SYNINSTALL}/lib:${SYNINSTALL}/lib/${PY_VER}/site-packages
fi
export SYNERGIA2DIR=${SYNINSTALL}/lib
EOF
