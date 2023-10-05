#Import HOME variable bash
HOME=Sys.getenv("HOME")

#Put path in variable
DATA=file.path(HOME, "/scratch/MultiverseMR/data/")

#Load data.table package
library(data.table)

#Set working directory
setwd(DATA)

#Read dosage data
data<-fread("snps-dosage2.txt", header=FALSE, data.table=F)

#Get number of rows
print(nrow(data))

#Read list of rsids
snps<-fread("snps-dosage.txt", select=3, header=FALSE, data.table=F)

#Get number of rows
print(nrow(snps))

#Transpose data
data<-t(data)

#Get number of rows
print(nrow(data))

#Get column number (i.e. snps)
print(ncol(data))

#Make rsids the column names
colnames(data)<-snps[,1]

#Save data
write.table(data, "data-transposed.txt", row.names=FALSE, sep = " ", quote=FALSE)
