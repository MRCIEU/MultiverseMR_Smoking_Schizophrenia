#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=Presso
#SBATCH --output=Presso_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=20:00:00
#SBATCH --mem=100000M
#SBATCH --array=01-09

#Put path in variable
CODE="${HOME}/scratch/MultiverseMR/code/f_MR"
DATA="${HOME}/scratch/MultiverseMR/data"
CHROM="$SLURM_ARRAY_TASK_ID"

#Load R
module add languages/r/4.0.3

#Run
cd $CODE
if [ "$SLURM_ARRAY_TASK_ID" == 1 ]
then
        Rscript presso.R smokeinit1snps.txt schz-1.txt PRESSO_SI1_SCHZ1.txt > logs/presso_init1_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 2 ]
then
        Rscript presso.R smokeinit1snps.txt schz-2.txt PRESSO_SI1_SCHZ2.txt > logs/presso_init1_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 3 ]
then
        Rscript presso.R smokeinit1snps.txt schz-3.txt PRESSO_SI1_SCHZ3.txt > logs/presso_init1_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 4 ]
then
	Rscript presso.R smokeinit2snps.txt schz-1.txt PRESSO_SI2_SCHZ1.txt > logs/presso_init2_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 5 ]
then
        Rscript presso.R smokeinit2snps.txt schz-2.txt PRESSO_SI2_SCHZ2.txt > logs/presso_init2_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 6 ]
then
        Rscript presso.R smokeinit2snps.txt schz-3.txt PRESSO_SI2_SCHZ3.txt > logs/presso_init2_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 7 ]
then
	Rscript presso.R cpd1snps.txt schz-1-current.txt PRESSO_CPD1_SCHZ1.txt > logs/presso_cpd1_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 8 ]
then
        Rscript presso.R cpd1snps.txt schz-2-current.txt PRESSO_CPD1_SCHZ2.txt > logs/presso_cpd1_schz2_r_log.txt
else
        Rscript presso.R cpd1snps.txt schz-3-current.txt PRESSO_CPD1_SCHZ3.txt > logs/presso_cpd1_schz3_r_log.txt
fi
