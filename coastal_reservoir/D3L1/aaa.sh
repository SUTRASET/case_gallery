#!/bin/bash
# set the number of nodes
#SBATCH --nodes=1

#SBATCH -p macondo

# number of CPUc cores per task
#SBATCH --cpus-per-task=4

# set max wallclock time
#SBATCH --time=200:00:00

# set name of job
#SBATCH --job-name=CR

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=ALL

# send mail to this address
#SBATCH --mail-user=mymhhu@163.com

# run this application
/storage/macondo/uqymo2/Coastal_reservoir_ND/SUTRA/sutra 1>output 2>erro
