#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=make_jobs_file
#SBATCH --output=make_jobs_file_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=10:00:00
#SBATCH --mem=5000M

#Put filepath in variable
CODE="${HOME}/scratch/MultiverseMR/code/e_GWAS/"

#Load R
module add languages/r/4.0.3

#Run R code
cd $CODE
R CMD BATCH --no-save --no-restore make_GWAS_files.R make_GWAS_files_r_log.txt
