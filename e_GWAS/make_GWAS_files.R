#Import the Home varible from bash
HOME=Sys.getenv("HOME")

#Put filepaths in variables
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")

#Load packages
library(data.table)
library(dplyr)

###########################
# MAKE JOBS FILE FOR GWAS #
###########################

jobs <- data.frame(name=c("GWASofSchizophrenia_1_all", "GWASofSchizophrenia_2_all", "GWASofSchizophrenia_3_all", "GWASofSchizophrenia_1_current", "GWASofSchizophrenia_2_current", "GWASofSchizophrenia_3_current"), 
		application_id = c("80112", "80112", "80112", "80112", "80112", "80112"), 
		pheno_file = c("GWAS-all-data.txt", "GWAS-all-data.txt", "GWAS-all-data.txt", "GWAS-current-data.txt", "GWAS-current-data.txt", "GWAS-current-data.txt"), 
		pheno_col = c("SCHZ_1",  "SCHZ_2", "SCHZ_3", "SCHZ_1",  "SCHZ_2", "SCHZ_3"), 
		covar_file = c("data.covariates.bolt.txt", "data.covariates.bolt.txt", "data.covariates.bolt.txt", "data.covariates.bolt.txt", "data.covariates.bolt.txt", "data.covariates.bolt.txt"), 
		covar_col = c("sex;chip", "sex;chip", "sex;chip", "sex;chip", "sex;chip", "sex;chip"), 
		qcovar_col = c("age", "age", "age", "age", "age", "age"), 
		method = c("bolt", "bolt", "bolt", "bolt", "bolt", "bolt"))

##########################
# FORMAT PHENOTYPE FILES #
##########################

#Read data
setwd(DATA)
data <- fread("data-related.txt", header=TRUE, data.table=F)
data_current <- fread("data-related-current.txt", header=TRUE, data.table=F)

#Create family and individual ID columns (copies of each other but both needed for UK Biobank GWAS pipeline)
data$f.eid <- data$app
data_current$f.eid <- data_current$app
names(data)[c(1,2)] <- c("FID", "IID")
names(data_current)[c(1,2)] <- c("FID", "IID")

#Reasign binary variables to be 2 vs 1 instead of 1 vs 0
data <- mutate(data, SCHZ_1=SCHZ_1+1, SCHZ_2=SCHZ_2+1, SCHZ_3=SCHZ_3+1)
data_current <- mutate(data_current, SCHZ_1=SCHZ_1+1, SCHZ_2=SCHZ_2+1, SCHZ_3=SCHZ_3+1)

########
# SAVE #
########

#Save data
setwd(DATA)
write.table(jobs, "jobs.csv", row.names=FALSE, sep = ",", quote=FALSE)
write.table(data, "GWAS-all-data.txt", row.names=FALSE, sep = " ", quote=FALSE)
write.table(data_current, "GWAS-current-data.txt", row.names=FALSE, sep = " ", quote=FALSE)
