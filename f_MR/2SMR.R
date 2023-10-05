#Import HOME variable from Bash
HOME=Sys.getenv("HOME")
LIB=Sys.getenv("LIB")

#Put path in variable
INPUT=paste(HOME, "/scratch/MultiverseMR/code/inputs/", sep="")
OUTPUT=paste(HOME, "/scratch/MultiverseMR/output/", sep="")
args <- commandArgs(trailingOnly = TRUE)

#Load data.table package
library(data.table)
library(TwoSampleMR, lib=LIB)

#############
# READ DATA #
#############

#Read
setwd(INPUT)
exposure<-fread(args[1], header=TRUE, data.table=F)
setwd(OUTPUT)
outcome<-fread(args[2], header=TRUE, data.table=F)

########
# 2SMR #
########

#Format and harmonise
out<-format_data(outcome, type = "outcome", snp_col="SNP", beta_col="BETA", se_col="SE", eaf_col="A1FREQ", effect_allele_col="ALLELE1", other_allele_col="ALLELE0", pval_col="P_BOLT_LMM_INF", info_col="INFO", chr_col="CHR", pos_col="pos")
exp<-format_data(exposure, type = "exposure", snp_col="rsID", beta_col="Beta", se_col="SE", eaf_col="EAF", effect_allele_col="Alternate_Allele", other_allele_col="Reference_Allele")
dat <- harmonise_data(exp, out, action = 2)

#MR
mr <- mr(dat, method_list=c("mr_ivw", "mr_egger_regression", "mr_weighted_median"))
try(print(warnings()))
mr<-mr[,c(5,6,7,8,9)]

#Pleitropy
pleiotropy<-mr_pleiotropy_test(dat)[,c(5,6,7)]
names(pleiotropy)<-c("mr_egger_intercept", "intercept_se", "intercept_pval")
pleiotropy$method<-"MR Egger"

#Heterogeneity
heterogeneity<-mr_heterogeneity(dat)[,c(5,6,7,8)]

#Combine
mr<-merge(mr, pleiotropy, by=c("method"), all.x = TRUE)
mr<-merge(mr, heterogeneity, by=c("method"), all.x = TRUE)

###########
# EXTRACT #
###########

#Make results table
results<-data.frame(matrix(nrow=3, ncol=14))
names(results) <- c("IV", "Outcome", "NSNP", "Method", "OR", "Lower", "Upper", "B", "SE", "P", "Egger_Intercept", "Intercept_P", "Q", "Q_P")
results$IV <- args[1]
results$Outcome <- args[2]
results$NSNP <- mr$nsnp 
results$Method <- gsub(" ", "-", mr$method)
results$B <- mr$b
results$SE <- mr$se
results$OR <- exp(results$B)
results$Lower <- exp(results$B-(1.96*results$SE))
results$Upper <- exp(results$B+(1.96*results$SE))
results$P <- mr$pval
results$EGGER_INTERCEPT <- mr$mr_egger_intercept
results$INTERCEPT_P <- mr$intercept_pval
results$Q <- mr$Q
results$Q_P <- mr$Q_pval

#Save
setwd(OUTPUT)
write.table(results, args[3], row.names=FALSE, quote=FALSE)
