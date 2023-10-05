#Import HOME variable from bash
HOME=Sys.getenv("HOME")

#Put path in variable
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")

#Load data.table package
library(data.table)

#Set working directory
setwd(DATA)

#Read the participant IDs
sample<-fread("sample.txt", select=2, skip=2, header=FALSE, data.table=F)

#Get number of rows
print(nrow(sample))

#Make column name same as linker file
names(sample)=c("IID")

#Set working directory
setwd(DATA)

#Read data
data<-fread("data-transposed.txt", header=TRUE, data.table=F)

#Combine IDs with data
data <- cbind(sample, data)

#Rows
print(nrow(data))

#Save data
write.table(data, "data-IDs.txt", row.names=FALSE, sep = " ", quote=FALSE)
