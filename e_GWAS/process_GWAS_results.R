#Import the Home varible from bash
HOME=Sys.getenv("HOME")

#Put filepaths in variables
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")
OUTPUT=paste(HOME, "/scratch/MultiverseMR/output/", sep="")
args <- commandArgs(trailingOnly = TRUE)

#Load packages
library(data.table)
library(dplyr)

#############
# LOAD DATA #
#############

setwd(DATA)
data <- fread(args[1], header=TRUE, data.table=F)

setwd(OUTPUT)
GWAS <- fread(args[2], header=TRUE, data.table=F)

###########
# PROCESS #
###########

#Convert from linear beta to log(OR) using prevelance
mu <- nrow(subset(data, get(args[3])==1)) / nrow(data)
print(mu)
GWAS <- mutate(GWAS, BETA = BETA / mu*(1-mu))
GWAS <-mutate(GWAS, SE = SE/(mu*(1-mu)))

#Save
write.table(GWAS, args[4], row.names=FALSE, sep = "\t", quote=FALSE)
