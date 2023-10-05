#Import the Home varible from bash
HOME=Sys.getenv("HOME")

#Put filepaths in variables
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")

#Load packages
library(data.table)
library(dplyr)

#################
# LOAD AND NAME #
#################

#Load data
setwd(DATA)
data<-read.table("data.txt", header=TRUE)
withdrawals<-fread("withdrawals.csv", sep=",", header=FALSE, data.table=F)
linker<-fread("linker.csv", header=TRUE, data.table=F)
WE<-fread("WE.txt", header=FALSE, data.table=F)
related<-fread("related.txt", header=FALSE, data.table=F)

#Name header
names(linker)=c("f.eid", "app")
names(withdrawals)=c("f.eid")
names(WE)=c("app")
names(related)=c("app")

###############
# WITHDRAWALS #
###############

#Remove withdrawals
data <- anti_join(data,withdrawals,by="f.eid")
print("Un-withdrawn data")
print(nrow(data))

##################
# WHITE-EUROPEAN #
##################

#Merge with linker
data <- merge(linker, data, by="f.eid")

print("linker data")
print(nrow(data))

#Merge with white-European ID (exclude those not in list) list and print new number of rows
data <- merge(WE, data, by="app")
print("White-European data")
print(nrow(data))

###########
# RELATED #
###########

#Exclude related individuals and print new number of rows
data_unrelated <- anti_join(data, related, by="app")
print("Unrelated data")
print(nrow(data_unrelated))

############
# STRATIFY #
############

data_current <- subset(data_unrelated, !is.na(data_unrelated$CPD))
print(nrow(data_current))
data_related_current <- subset(data, !is.na(data$CPD))
print(nrow(data_related_current))
data_never <- subset(data_unrelated, Ever_Never==0)
print(nrow(data_never))

#########
# CASES #
#########

cases <- function(outcome){
	print(length(outcome[outcome==1]))
	print(length(outcome[outcome==0]))
}
cases(data$SCHZ_1)
cases(data$SCHZ_2)
cases(data$SCHZ_3)
cases(data_related_current$SCHZ_1)
cases(data_related_current$SCHZ_2)
cases(data_related_current$SCHZ_3)

########
# SAVE #
########

#Save data
write.table(data_related_current, "data-related-current.txt", row.names=FALSE, sep = "\t", quote=FALSE)
write.table(data, "data-related.txt", row.names=FALSE, sep = "\t", quote=FALSE)
write.table(data_unrelated, "data-unrelated.txt", row.names=FALSE, sep = "\t", quote=FALSE)
write.table(data_current, "data-current.txt", row.names=FALSE, sep = "\t", quote=FALSE)
write.table(data_never, "data-never.txt", row.names=FALSE, sep = "\t", quote=FALSE)
