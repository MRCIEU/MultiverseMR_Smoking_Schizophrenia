#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=1SMR
#SBATCH --output=1SMR_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=20:00:00
#SBATCH --mem=100000M
#SBATCH --partition=mrcieu
#SBATCH --array=01-27

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
	Rscript 1SMR.R scores-weighted-init1.txt data-unrelated.txt Ever_Never SCHZ_1 1SMR_SI1W_SCHZ1.txt > logs/1SMR_init1_weighted_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 2 ]
then
	Rscript 1SMR.R scores-weighted-init1.txt data-unrelated.txt Ever_Never SCHZ_2 1SMR_SI1W_SCHZ2.txt > logs/1SMR_init1_weighted_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 3 ]
then
	Rscript 1SMR.R scores-weighted-init1.txt data-unrelated.txt Ever_Never SCHZ_3 1SMR_SI1W_SCHZ3.txt > logs/1SMR_init1_weighted_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 4 ]
then
        Rscript 1SMR.R scores-unweighted-init1.txt data-unrelated.txt Ever_Never SCHZ_1 1SMR_SI1UW_SCHZ1.txt > logs/1SMR_init1_unweighted_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 5 ]
then
        Rscript 1SMR.R scores-unweighted-init1.txt data-unrelated.txt Ever_Never SCHZ_2 1SMR_SI1UW_SCHZ2.txt > logs/1SMR_init1_unweighted_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 6 ]
then
	Rscript 1SMR.R scores-unweighted-init1.txt data-unrelated.txt Ever_Never SCHZ_3 1SMR_SI1UW_SCHZ3.txt > logs/1SMR_init1_unweighted_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 7 ]
then
        Rscript 1SMR.R scores-init2.txt data-unrelated.txt Ever_Never SCHZ_1 1SMR_SI2_SCHZ1.txt > logs/1SMR_init2_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 8 ]
then
        Rscript 1SMR.R scores-init2.txt data-unrelated.txt Ever_Never SCHZ_2 1SMR_SI2_SCHZ2.txt > logs/1SMR_init2_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 9 ]
then
	Rscript 1SMR.R scores-init2.txt data-unrelated.txt Ever_Never SCHZ_3 1SMR_SI2_SCHZ3.txt > logs/1SMR_init2_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 10 ]
then
        Rscript 1SMR.R scores-weighted-cpd1.txt data-current.txt CPD SCHZ_1 1SMR_CPD1W_SCHZ1.txt > logs/1SMR_cpd1_weighted_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 11 ]
then
        Rscript 1SMR.R scores-weighted-cpd1.txt data-current.txt CPD SCHZ_2 1SMR_CPD1W_SCHZ2.txt > logs/1SMR_cpd1_weighted_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 12 ]
then
        Rscript 1SMR.R scores-weighted-cpd1.txt data-current.txt CPD SCHZ_3 1SMR_CPD1W_SCHZ3.txt > logs/1SMR_cpd1_weighted_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 13 ]
then
        Rscript 1SMR.R scores-unweighted-cpd1.txt data-current.txt CPD SCHZ_1 1SMR_CPD1UW_SCHZ1.txt > logs/1SMR_cpd1_unweighted_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 14 ]
then
        Rscript 1SMR.R scores-unweighted-cpd1.txt data-current.txt CPD SCHZ_2 1SMR_CPD1UW_SCHZ2.txt > logs/1SMR_cpd1_unweighted_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 15 ]
then
        Rscript 1SMR.R scores-unweighted-cpd1.txt data-current.txt CPD SCHZ_3 1SMR_CPD1UW_SCHZ3.txt > logs/1SMR_cpd1_unweighted_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 16 ]
then
        Rscript 1SMR.R scores-cpd2.txt data-current.txt CPD SCHZ_1 1SMR_CPD2_SCHZ1.txt > logs/1SMR_cpd2_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 17 ]
then
        Rscript 1SMR.R scores-cpd2.txt data-current.txt CPD SCHZ_2 1SMR_CPD2_SCHZ2.txt > logs/1SMR_cpd2_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 18 ]
then
        Rscript 1SMR.R scores-cpd2.txt data-current.txt CPD SCHZ_3 1SMR_CPD2_SCHZ3.txt > logs/1SMR_cpd2_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 19 ]
then
        Rscript 1SMR.R scores-sibs-weighted-init1.txt data-siblings.txt Ever_Never SCHZ_1 1SMR_SI1W_SIBS_SCHZ1.txt > logs/1SMR_init1_sibs_weighted_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 20 ]
then
        Rscript 1SMR.R scores-sibs-weighted-init1.txt data-siblings.txt Ever_Never SCHZ_2 1SMR_SI1W_SIBS_SCHZ2.txt > logs/1SMR_init1_sibs_weighted_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 21 ]
then
        Rscript 1SMR.R scores-sibs-weighted-init1.txt data-siblings.txt Ever_Never SCHZ_3 1SMR_SI1W_SIBS_SCHZ3.txt > logs/1SMR_init1_sibs_weighted_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 22 ]
then
        Rscript 1SMR.R scores-sibs-unweighted-init1.txt data-siblings.txt Ever_Never SCHZ_1 1SMR_SI1UW_SIBS_SCHZ1.txt > logs/1SMR_init1_sibs_unweighted_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 23 ]
then
        Rscript 1SMR.R scores-sibs-unweighted-init1.txt data-siblings.txt Ever_Never SCHZ_2 1SMR_SI1UW_SIBS_SCHZ2.txt > logs/1SMR_init1_sibs_unweighted_schz2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 24 ]
then
        Rscript 1SMR.R scores-sibs-unweighted-init1.txt data-siblings.txt Ever_Never SCHZ_3 1SMR_SI1UW_SIBS_SCHZ3.txt > logs/1SMR_init1_sibs_unweighted_schz3_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 25 ]
then
        Rscript 1SMR.R scores-sibs-init2.txt data-siblings.txt Ever_Never SCHZ_1 1SMR_SI2_SIBS_SCHZ1.txt > logs/1SMR_init2_sibs_schz1_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 26 ]
then
        Rscript 1SMR.R scores-sibs-init2.txt data-siblings.txt Ever_Never SCHZ_2 1SMR_SI2_SIBS_SCHZ2.txt > logs/1SMR_init2_sibs_schz2_r_log.txt
else
	Rscript 1SMR.R scores-sibs-init2.txt data-siblings.txt Ever_Never SCHZ_3 1SMR_SI2_SIBS_SCHZ3.txt > logs/1SMR_init2_sibs_schz3_r_log.txt
fi
