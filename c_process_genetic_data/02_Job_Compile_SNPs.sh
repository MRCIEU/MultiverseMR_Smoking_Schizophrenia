#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=compile_snps
#SBATCH --output=compile_snps_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22 
#SBATCH --time=60:00:00
#SBATCH --mem=100M

#Put filpath in variable
DATA="${HOME}/scratch/MultiverseMR/data"

#Reset output file
> $DATA/snps-compiled.gen

#Add the gen data for each chromosome to the final output.
cat $DATA/snps_by_chrom/*snps.gen >> $DATA/snps-compiled.gen

#Count rows
wc -l $DATA/snps-compiled.gen

#Count column seperators
head -n1 $DATA/snps-compiled.gen | grep -o " " | wc -l


