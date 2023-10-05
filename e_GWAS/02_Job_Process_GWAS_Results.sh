#!/bin/bash
#SBATCH --account=psyc010162
#SBATCH --job-name=process_GWAS_results
#SBATCH --output=process_GWAS_results_slurm.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=22
#SBATCH --time=10:00:00
#SBATCH --mem=10000M
#SBATCH --array=01-06

#Put filepath in variable
CODE="${HOME}/scratch/MultiverseMR/code/e_GWAS/"

#Load R
module add languages/r/4.0.3

#Run R code
cd $CODE
if [ "$SLURM_ARRAY_TASK_ID" == 1 ]
then
	Rscript process_GWAS_results.R data-related.txt GWASofSchizophrenia_1_all_imputed.txt SCHZ_1 schz-1.txt > logs/process_1_all_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 2 ]
then
	Rscript process_GWAS_results.R data-related.txt GWASofSchizophrenia_2_all_imputed.txt SCHZ_2 schz-2.txt > logs/process_2_all_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 3 ]
then
	Rscript process_GWAS_results.R data-related.txt GWASofSchizophrenia_3_all_imputed.txt SCHZ_3 schz-3.txt > logs/process_3_all_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 4 ]
then
	Rscript process_GWAS_results.R data-related-current.txt GWASofSchizophrenia_1_current_imputed.txt SCHZ_1 schz-1-current.txt > logs/process_1_current_r_log.txt
elif [ "$SLURM_ARRAY_TASK_ID" == 5 ]
then
	Rscript process_GWAS_results.R data-related-current.txt GWASofSchizophrenia_2_current_imputed.txt SCHZ_2 schz-2-current.txt > logs/process_2_current_r_log.txt
else	
	Rscript process_GWAS_results.R data-related-current.txt GWASofSchizophrenia_3_current_imputed.txt SCHZ_3 schz-3-current.txt > logs/process_3_current_r_log.txt
fi
