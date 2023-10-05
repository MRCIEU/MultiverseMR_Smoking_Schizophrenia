#Import HOME variable from Bash
HOME=Sys.getenv("HOME")
LIB=Sys.getenv("LIB")

#Put path in variable
OUTPUT=paste(HOME, "/scratch/MultiverseMR/output/", sep="")
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")
args <- commandArgs(trailingOnly = TRUE)

#Load data.table package
library(data.table)

#############
# READ DATA #
#############

#Read
setwd(DATA)
grs<-fread(args[1], header=TRUE, data.table=F)
data<-fread(args[2], header=TRUE, data.table=F)
PC<-fread("PC.txt", header=TRUE, data.table=F)
chip<-fread("chip.txt", header=TRUE, select=c(1,3), data.table=F)

#Name
names(PC)[1]<-"IID"
for (i in 1:10){
	names(PC)[i+1]<-paste("PC", i, sep="")
}
names(chip)<-c("IID", "Chip")

#Merge
data<-merge(grs, data)
cov<-merge(PC, chip)
names(cov)[1]<-"app"
data<-merge(data, cov)

#########
# CASES #
#########

y <- data[,args[3]]
print(length(y[y==1]))
print(length(y[y==0]))

##############
# REGRESSION #
##############

#Regress	
fit <- glm(get(args[3]) ~ scores + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data, family="binomial")
try(print(warnings()))

#Results table
results <- data.frame(matrix(nrow=1, ncol=9))
names(results) <- c("IV", "Outcome", "NSNP", "Method", "Sample", "OR", "Lower", "Upper", "P")
results$IV <- args[1]
results$Outcome <- args[3]
results$NSNP <- grs[1,"nsnp"]
results$Method <- "GRS_Regression"
results$Sample <- args[2]
results$B <- coef(summary(fit))[2 ,"Estimate"]
results$SE <- coef(summary(fit))[2 ,"Std. Error"]
results$OR <- exp(results$B)
results$Lower <- exp(results$B-(1.96*results$SE))
results$Upper <- exp(results$B+(1.96*results$SE))
results$P <- coef(summary(fit))[2 ,"Pr(>|z|)"]

#Save
setwd(OUTPUT)
write.table(results, args[4], quote=FALSE, row.names=FALSE)

