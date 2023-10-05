#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=add_IDs
#SBATCH --output=add_IDs_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=60:00:00
#SBATCH --mem=10000M

#Put path in variable
CODE="${HOME}/scratch/MultiverseMR/code/c_process_genetic_data"
DATA="${HOME}/scratch/MultiverseMR/data/"
GEN_DATA="$UK_B_LATEST/data/dosage_bgen"

#Get sample
cp $GEN_DATA/data.chr1-22.sample $DATA/sample.txt

#Load R
module add languages/r/4.0.3

#Run R script
cd $CODE
R CMD BATCH --no-save --no-restore add_IDs.R add_IDs_r_log.txt

