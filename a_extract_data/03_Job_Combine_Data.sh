#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=combine
#SBATCH --output=combine_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=10:00:00
#SBATCH --mem=5000M
#SBATCH --partition=mrcieu

#Put data filepath in variable
DATA="$HOME/scratch/MultiverseMR/data"

#######################
# EXTRACT CONFOUNDERS #
#######################

#Get column numbers for Sex
head -n1 $DATA/data.50982.tab | sed 's/\t/\n/g' | nl | grep -wn "f.31.0.0"
#23

#Get column numbers for Age
head -n1 $DATA/data.50982.tab | sed 's/\t/\n/g' | nl | grep -wn "f.21022.0.0"
#9738

#Extract confounder
cut -f23,9738 $DATA/data.50982.tab > $DATA/confounders.txt
head -n1 $DATA/confounders.txt

#Change headers
sed -i 1d $DATA/confounders.txt
sed -i '1i Sex\tAge' $DATA/confounders.txt

###########
# COMBINE #     
###########

#Get IDs
cut -f1 $DATA/data.50982.tab > $DATA/IDs.txt

#Paste
paste $DATA/ids.txt $DATA/schz.txt $DATA/smoke.txt $DATA/confounders.txt > $DATA/data.txt
