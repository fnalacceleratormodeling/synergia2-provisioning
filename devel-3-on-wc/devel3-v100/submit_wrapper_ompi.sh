#!/bin/bash

#SBATCH --account accelsim
#SBATCH --partition gpu_gce
#SBATCH --gres=gpu:v100:1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --exclusive
#SBATCH --job-name=synergia2

module purge > /dev/null 2>&1
module load git
module load gnu12
module load cuda12

source /wclustre/accelsim/spack-shared-v4/setup_env_synergia-devel3-v100-002.sh


srun --mpi=pmix_v3 ./wrapper_ompi.sh 
