#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=extract_smoking
#SBATCH --output=extract_smoking_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=10:00:00
#SBATCH --mem=5000M
#SBATCH --partition=mrcieu

#Put data filepath in variable
DATA="$HOME/scratch/MultiverseMR/data"

###################
# EXTRACT SMOKING #
###################

#Get column numbers for smoking status and cigarettes per day
head -n1 $DATA/data.50982.tab | sed 's/\t/\n/g' | nl | grep -n "f.20116.0."
head -n1 $DATA/data.50982.tab | sed 's/\t/\n/g' | nl | grep -n "f.3456.0."

#Extract
cut -f8876 $DATA/data.50982.tab > $DATA/ever_never.txt
cut -f1377 $DATA/data.50982.tab > $DATA/cpd.txt
head -n1 $DATA/ever_never.txt
head -n1 $DATA/cpd.txt

#Delete headers
sed -i 1d $DATA/ever_never.txt
sed -i 1d $DATA/cpd.txt

#Recode
sed -i 's/-3/NA/g' $DATA/ever_never.txt
sed -i 's/2/1/g' $DATA/ever_never.txt
sed -i 's/-10/0.5/g' $DATA/cpd.txt
sed -i 's/-3\|-1/NA/g' $DATA/cpd.txt

#Replace header
sed  -i '1i Ever_Never' $DATA/ever_never.txt
sed  -i '1i CPD' $DATA/cpd.txt

#Paste
paste $DATA/ever_never.txt $DATA/cpd.txt > $DATA/smoke.txt

#Count cases
echo "count cases"
grep -c 1 $DATA/ever_never.txt

#Remove extra files
rm $DATA/cpd.txt
rm $DATA/ever_never.txt
