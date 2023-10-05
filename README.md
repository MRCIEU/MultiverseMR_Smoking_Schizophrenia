# Multiverse-MR: Smoking and Schizophrenia
This pipeline conducts a Multiverse Mendelian randomisation approach to investigate the causal relationship between smoking initiation and schizophrenia, using UK Biobank data.

## Directory Structure
### The project folder has the following structure:
```
MultiverseMR/code
MultiverseMR/code/a_extract_data
MultiverseMR/code/b_process
MultiverseMR/code/c_process_genetic_data
MultiverseMR/code/d_generate_GRS
MultiverseMR/code/e_GWAS
MultiverseMR/code/f_MR
MultiverseMR/code/g_multiverse
MultiverseMR/code/inputs
MultiverseMR/data
MultiverseMR/output
``` 

## Scripts
### a_extract_data
This section of the pipeline extracts all the necessary variables from the UK Biobank data and codes these variables as required. 
### b_process
This section of the pipeline excludes individuals to create the correct datasets for the different analyses (i.e., stratifying by smoking status and creating a sibling sample and unrelated sample).
### c_process_genetic_data
This section of the pipeline extracts the SNPs listed in the files in the inputs folder from the UK Biobank genetic data, codes the dosage of these SNPs, and formats the data.
### d_generate_GRS
This section of the pipeline harmonises the GWAS summary data used to create the genetic risk scores with the UK Biobank data, and then generates the different genetic risk scores from the UK Biobank data. 
### e_GWAS
This section of the pipeline creates the phenotype and meta files to be submitted to the MRC IEU UK Biobank GWAS pipeline, and then processes the files outputted by the pipeline.
### f_MR
This section of the pipeline conducts all Mendelian randomisations using the different data sets, genetic risk scores and GWAS summary statistics. 
These are split into 4 batches (one-sample, two-sample, GRS-outcome regression and MR-PRESSO).
### g_multiverse
This section of the pipeline compiles all results files from the previous section, reformats these, and produces final results tables and heatmaps.
 
