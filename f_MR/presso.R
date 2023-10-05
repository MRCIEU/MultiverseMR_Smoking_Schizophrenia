#Import HOME variable from Bash
HOME=Sys.getenv("HOME")
LIB=Sys.getenv("LIB")

#Put path in variable
INPUT=paste(HOME, "/scratch/MultiverseMR/code/inputs/", sep="")
OUTPUT=paste(HOME, "/scratch/MultiverseMR/output/", sep="")
args <- commandArgs(trailingOnly = TRUE)

#Load data.table package
library(data.table)
library(MRPRESSO)
library(TwoSampleMR)

#############
# READ DATA #
#############

#Read
setwd(INPUT)
exposure<-fread(args[1], header=TRUE, data.table=F)
setwd(OUTPUT)
outcome<-fread(args[2], header=TRUE, data.table=F)

##########
# PRESSO #
##########

#Format and harmonise
out<-format_data(outcome, type = "outcome", snp_col="SNP", beta_col="BETA", se_col="SE", eaf_col="A1FREQ", effect_allele_col="ALLELE1", other_allele_col="ALLELE0", pval_col="P_BOLT_LMM_INF", info_col="INFO", chr_col="CHR", pos_col="pos")
exp<-format_data(exposure, type = "exposure", snp_col="rsID", beta_col="Beta", se_col="SE", eaf_col="EAF", effect_allele_col="Alternate_Allele", other_allele_col="Reference_Allele")
dat <- harmonise_data(exp, out, action = 2)

#MR-Presso        
presso <- mr_presso(BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure", SdOutcome = "se.outcome", SdExposure = "se.exposure", OUTLIERtest = TRUE, DISTORTIONtest = TRUE, data = dat, NbDistribution = 10000,  SignifThreshold = 0.05)
try(print(warnings()))
print(presso)
presso <- presso$`Main MR results`[2,c(3,4,6)]
names(presso)<-c("b", "se", "p")

###########
# EXTRACT #
###########

#Make results table
results <- data.frame(matrix(nrow=1, ncol=10))
names(results) <- c("IV", "Outcome", "NSNP", "Method", "OR", "Lower", "Upper", "B", "SE", "P")
results$IV <- args[1]
results$Outcome <- args[2]
results$NSNP <- nrow(subset(dat, mr_keep==TRUE))
results$Method <- "MR-PRESSO"
results$B <- presso$b
results$SE <- presso$se
results$OR <- exp(results$B)
results$Lower <- exp(results$B-(1.96*results$SE))
results$Upper <- exp(results$B+(1.96*results$SE))
results$P <- presso$p

#Save
setwd(OUTPUT)
write.table(results, args[3], row.names=FALSE, quote=FALSE)
