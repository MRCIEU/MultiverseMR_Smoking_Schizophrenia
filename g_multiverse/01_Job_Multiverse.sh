#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=multiverse
#SBATCH --output=multiverse_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=10:00:00
#SBATCH --mem=5000M

#Put filepath in variable
CODE="${HOME}/scratch/MultiverseMR/code/g_multiverse/"

#Load R
module add languages/r/4.0.3

#Run R code
cd $CODE
R CMD BATCH --no-save --no-restore multiverse.R multiverse_r_log.txt
