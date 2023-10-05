#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=generate_insomnia_scores
#SBATCH --output=generate_insomnia_scores_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=20:00:00
#SBATCH --mem=100000M
#SBATCH --partition=mrcieu
#SBATCH --array=01-09

#Put path in variable
CODE="${HOME}/scratch/MultiverseMR/code/d_generate_GRS"

#Load R
module add languages/r/4.0.3
#Loads R

#Run R script
cd $CODE
if [ "$SLURM_ARRAY_TASK_ID" == 1 ]
then
	Rscript score_gen.R smokeinit1snps.txt all weighted scores-weighted-init1.txt > logs/score_gen_init1_weighted_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 2 ]
then
        Rscript score_gen.R smokeinit1snps.txt all unweighted scores-unweighted-init1.txt > logs/score_gen_init1_unweighted_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 3 ]
then
        Rscript score_gen.R smokeinit2snps.txt all weighted scores-init2.txt > logs/score_gen_init2_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 4 ]
then
        Rscript score_gen.R smokeinit1snps.txt sibs weighted scores-sibs-weighted-init1.txt > logs/score_gen_init1_weighted_sibs_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 5 ]
then
        Rscript score_gen.R smokeinit1snps.txt sibs unweighted scores-sibs-unweighted-init1.txt > logs/score_gen_init1_unweighted_sibs_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 6 ]
then
        Rscript score_gen.R smokeinit2snps.txt sibs weighted scores-sibs-init2.txt > logs/score_gen_init2_sibs_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 7 ]
then
        Rscript score_gen.R cpd1snps.txt all weighted scores-weighted-cpd1.txt > logs/score_gen_cpd1_weighted_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 8 ]
then
        Rscript score_gen.R cpd1snps.txt all unweighted scores-unweighted-cpd1.txt > logs/score_gen_cpd1_unweighted_r_log.txt
else
	Rscript score_gen.R cpd2snps.txt all unweighted scores-cpd2.txt > logs/score_gen_cpd2_r_log.txt
fi
