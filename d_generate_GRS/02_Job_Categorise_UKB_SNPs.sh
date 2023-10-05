#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=categorise_SNPs
#SBATCH --output=categorise_UKB_SNPs_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=20:00:00
#SBATCH --mem=1000M

#Put path in variable
CODE="${HOME}/scratch/MultiverseMR/code/d_generate_GRS"

#Load R
module add languages/r/4.0.3
#Loads R

#Run R script
cd $CODE
R CMD BATCH --no-save --no-restore categorise_UKB_SNPs.R categorise_UKB_SNPs_r_log.txt
