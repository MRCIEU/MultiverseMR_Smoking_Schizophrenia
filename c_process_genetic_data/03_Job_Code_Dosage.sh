#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=code_dosage
#SBATCH --output=code_dosage_snps_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=60:00:00
#SBATCH --mem=10000M

##########################
# PUT PATHS In VARIABLES #
##########################

DATA="${HOME}/scratch/MultiverseMR/data"
CODE="${HOME}/scratch/MultiverseMR/code/c_process_genetic_data"

###############
# CODE DOSAGE # 
###############

#Take the compiled gen data and pipe it into the python script which converts to dosage. 
cat $DATA/snps-compiled.gen | python $CODE/gen_to_expected.py > $DATA/snps-dosage.txt

#Remove the first 6 columns of the output which are not-needed snp information so the data can be transposed.
cut -d' ' -f 7- $DATA/snps-dosage.txt > $DATA/snps-dosage2.txt

#Count rows
wc -l $DATA/snps-dosage2.txt

#Count column seperators
head -n1 $DATA/snps-dosage2.txt | grep -o " " | wc -l
