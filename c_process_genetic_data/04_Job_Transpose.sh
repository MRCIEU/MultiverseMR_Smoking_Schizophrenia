#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=transpose
#SBATCH --output=transpose_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=60:00:00
#SBATCH --mem=10000M

#Put path in variable
CODE="${HOME}/scratch/MultiverseMR/code/c_process_genetic_data"

#Load R
module add languages/r/4.0.3

#Run R script
cd $CODE
R CMD BATCH --no-save --no-restore transpose.R transpose_r_log.txt

