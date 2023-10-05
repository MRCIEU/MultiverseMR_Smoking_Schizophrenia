#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=GRSregression
#SBATCH --output=GRSregression_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=20:00:00
#SBATCH --mem=100000M
#SBATCH --partition=mrcieu
#SBATCH --array=01-18

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
	Rscript GRS_regression.R scores-weighted-cpd1.txt data-current.txt SCHZ_1 GRSREG_CPD1W_CURRENT_SCHZ1.txt > logs/GRSREG_cpd1_weighted_current_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 2 ]
then
	Rscript GRS_regression.R scores-weighted-cpd1.txt data-current.txt SCHZ_2 GRSREG_CPD1W_CURRENT_SCHZ2.txt > logs/GRSREG_cpd1_weighted_current_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 3 ]
then
	Rscript GRS_regression.R scores-weighted-cpd1.txt data-current.txt SCHZ_3 GRSREG_CPD1W_CURRENT_SCHZ3.txt > logs/GRSREG_cpd1_weighted_current_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 4 ]
then
        Rscript GRS_regression.R scores-weighted-cpd1.txt data-never.txt SCHZ_1 GRSREG_CPD1W_NEVER_SCHZ1.txt > logs/GRSREG_cpd1_weighted_never_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 5 ]
then
        Rscript GRS_regression.R scores-weighted-cpd1.txt data-never.txt SCHZ_2 GRSREG_CPD1W_NEVER_SCHZ2.txt > logs/GRSREG_cpd1_weighted_never_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 6 ]
then
	Rscript GRS_regression.R scores-weighted-cpd1.txt data-never.txt SCHZ_3 GRSREG_CPD1W_NEVER_SCHZ3.txt > logs/GRSREG_cpd1_weighted_never_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 7 ]
then
        Rscript GRS_regression.R scores-unweighted-cpd1.txt data-current.txt SCHZ_1 GRSREG_CPD1UW_CURRENT_SCHZ1.txt > logs/GRSREG_cpd1_unweighted_current_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 8 ]
then
        Rscript GRS_regression.R scores-unweighted-cpd1.txt data-current.txt SCHZ_2 GRSREG_CPD1UW_CURRENT_SCHZ2.txt > logs/GRSREG_cpd1_unweighted_current_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 9 ]
then
        Rscript GRS_regression.R scores-unweighted-cpd1.txt data-current.txt SCHZ_3 GRSREG_CPD1UW_CURRENT_SCHZ3.txt > logs/GRSREG_cpd1_unweighted_current_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 10 ]
then
        Rscript GRS_regression.R scores-unweighted-cpd1.txt data-never.txt SCHZ_1 GRSREG_CPD1UW_NEVER_SCHZ1.txt > logs/GRSREG_cpd1_unweighted_never_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 11 ]
then
        Rscript GRS_regression.R scores-unweighted-cpd1.txt data-never.txt SCHZ_2 GRSREG_CPD1UW_NEVER_SCHZ2.txt > logs/GRSREG_cpd1_unweighted_never_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 12 ]
then
        Rscript GRS_regression.R scores-unweighted-cpd1.txt data-never.txt SCHZ_3 GRSREG_CPD1UW_NEVER_SCHZ3.txt > logs/GRSREG_cpd1_unweighted_never_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 13 ]
then
        Rscript GRS_regression.R scores-cpd2.txt data-current.txt SCHZ_1 GRSREG_CPD2_CURRENT_SCHZ1.txt > logs/GRSREG_cpd2_current_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 14 ]
then
        Rscript GRS_regression.R scores-cpd2.txt data-current.txt SCHZ_2 GRSREG_CPD2_CURRENT_SCHZ2.txt > logs/GRSREG_cpd2_current_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 15 ]
then
        Rscript GRS_regression.R scores-cpd2.txt data-current.txt SCHZ_3 GRSREG_CPD2_CURRENT_SCHZ3.txt > logs/GRSREG_cpd2_current_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 16 ]
then
        Rscript GRS_regression.R scores-cpd2.txt data-never.txt SCHZ_1 GRSREG_CPD2_NEVER_SCHZ1.txt > logs/GRSREG_cpd2_never_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 17 ]
then
        Rscript GRS_regression.R scores-cpd2.txt data-never.txt SCHZ_2 GRSREG_CPD2_NEVER_SCHZ2.txt > logs/GRSREG_cpd2_never_schz2_r_log.txt
else
        Rscript GRS_regression.R scores-cpd2.txt data-never.txt SCHZ_3 GRSREG_CPD2_NEVER_SCHZ3.txt > logs/GRSREG_cpd2_never_schz3_r_log.txt
fi
