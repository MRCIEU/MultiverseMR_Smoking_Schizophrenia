#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=sibling
#SBATCH --output=siblings_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=10:00:00
#SBATCH --mem=5000M
#SBATCH --partition=mrcieu

#Put filepath in variable
CODE="${HOME}/scratch/MultiverseMR/code/b_process/"
DATA="$HOME/scratch/MultiverseMR/data"

############
# SIBLINGS #
############

#Load R
module add languages/r/4.0.3

#Run R code
cd $CODE
R CMD BATCH --no-save --no-restore siblings.R siblings_r_log.txt
