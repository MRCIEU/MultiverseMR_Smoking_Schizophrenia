#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=extract_schizophrenia
#SBATCH --output=extract_schizophrenia_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=20:00:00
#SBATCH --mem=10000M
#SBATCH --partition=mrcieu

#########################
# EXTRACT SCHIZOPHRENIA #
#########################

#Put data filepath in variable
DATA="$HOME/scratch/MultiverseMR/data"

#Get column numbers for ICD10 diagnosis
head -n1 $DATA/data.50982.tab | sed 's/\t/\n/g' | nl | grep -n "f.41270.0."

#Put columns in file
cut -f15741-15983 $DATA/data.50982.tab > $DATA/icd10.txt
head -n1 $DATA/icd10.txt

#Delete headers
sed -i 1d $DATA/icd10.txt

#Get indexes of cases
grep -n 'F20' $DATA/icd10.txt | cut -d : -f 1 > $DATA/schz_1_rows.txt
grep -n 'F20\|F21\|F22\|F23\|F24\|F28\|F29' $DATA/icd10.txt | cut -d : -f 1 > $DATA/schz_2_rows.txt
grep -n 'F20\|F21\|F22\|F23\|F24\|F25\|F28\|F29' $DATA/icd10.txt | cut -d : -f 1 > $DATA/schz_3_rows.txt

#Take first column of icd10
cut -f1 $DATA/icd10.txt > $DATA/schz.txt

#Split characters into different columns
sed -e 's/\(.\)/\1 /g' $DATA/schz.txt > $DATA/schz_temp.txt

#Take first column so file of single characters
awk '{ print$1 }' $DATA/schz_temp.txt > $DATA/schz.txt

#Change everything to 0s
sed 's/./0/g' $DATA/schz.txt > $DATA/schz_temp.txt

#Change schz to 1
sed 's/$/c\\\n1/' $DATA/schz_1_rows.txt | sed -f - $DATA/schz_temp.txt > $DATA/schz_1.txt
sed 's/$/c\\\n1/' $DATA/schz_2_rows.txt | sed -f - $DATA/schz_temp.txt > $DATA/schz_2.txt
sed 's/$/c\\\n1/' $DATA/schz_3_rows.txt | sed -f - $DATA/schz_temp.txt > $DATA/schz_3.txt

#Replace header
sed  -i '1i SCHZ_1' $DATA/schz_1.txt
sed  -i '1i SCHZ_2' $DATA/schz_2.txt
sed  -i '1i SCHZ_3' $DATA/schz_3.txt

#Paste
paste $DATA/schz_1.txt $DATA/schz_2.txt $DATA/schz_3.txt > $DATA/schz.txt

#Count cases
echo "count cases for 1, 2 and 3"
grep -c 1 $DATA/schz_1.txt
grep -c 1 $DATA/schz_2.txt
grep -c 1 $DATA/schz_3.txt

#Remove extra files
rm $DATA/schz_1_rows.txt
rm $DATA/schz_2_rows.txt
rm $DATA/schz_3_rows.txt
rm $DATA/schz_1.txt
rm $DATA/schz_2.txt
rm $DATA/schz_3.txt
rm $DATA/schz_temp.txt
rm $DATA/icd10.txt
