#Import HOME variable from Bash
HOME=Sys.getenv("HOME")
LIB=Sys.getenv("LIB")

#Put path in variable
OUTPUT=paste(HOME, "/scratch/MultiverseMR/output/", sep="")
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")
args <- commandArgs(trailingOnly = TRUE)

#Load data.table package
library(data.table)
library(DescTools, lib=LIB)
library(nlmr, lib="/user/home/mg15613/R")

#############
# READ DATA #
#############

#Read
setwd(DATA)
scores<-fread(args[1], header=TRUE, data.table=F)
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
print("N")
data<-merge(scores, data)
print(nrow(data))
cov<-merge(PC, chip)
names(cov)[1]<-"app"
data<-merge(data, cov)
print(nrow(data))

############
# SIBLINGS #
############

#Get rid of single siblings
if (args[2]=="data-siblings.txt"){
	data<-subset(data, data$sibID %in% data$sibID[duplicated(data$sibID)])
	print("Siblings and groups")
	print(nrow(data))
	print(length(unique(data$sibID)))	
}

##################
# MAKE VARIABLES #
##################

iv <- data[,"scores"]
x <- data[,args[3]]
y <- data[,args[4]]
c <- data[,c("Age", "Sex", "Chip", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")]
iv.con<-iv[y==0]
x.con<-x[y==0]
data.con<-data[y==0,]

#########
# CASES #
#########

print("Cases and controls")
print(length(y[y==1]))
print(length(y[y==0]))

########
# 1SMR #
########

#Run MR
if (args[3]=="Ever_Never"){
	
	#IV stregth
	fit <- glm(x.con~iv.con + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data.con, family="binomial")
	R2<-PseudoR2(fit, which = "McFadden")
	try(print(warnings()))

	#2SLS Logistisc-Logistic (Ever_Never)
	m_iv <- glm(y~predict(glm(x.con~iv.con + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data.con, family="binomial"), newdata=list(iv.con=iv)) + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data, family="binomial")
	try(print(warnings()))
}else{
	#IV Strength
	fit <- lm(x.con~iv.con + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data.con)
	R2<-summary(fit)$adj.r.squared
	try(print(warnings()))

	#2SLS Linear-Logistic (CPD)
	m_iv <- glm(y~predict(lm(x.con~iv.con + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data.con), newdata=list(iv.con=iv)) + Age + Sex + Chip + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=data, family="binomial")
	try(print(warnings()))

	#Non-linear (CPD)
	fp <- fracpoly_mr(y, x+2, iv, c, family = "binomial", q = 5)
	try(print(warnings()))
	plm <- piecewise_mr(y, x, iv, c, family = "binomial", q=5, ci_quantiles=5)
	try(print(warnings()))
}

###########
# EXTRACT #
###########

#Make results table
results <- data.frame(matrix(nrow=1, ncol=14))
names(results) <- c("IV", "Outcome", "NSNP", "Method", "Quintile", "OR", "Lower", "Upper", "B", "SE", "P", "Power", "Cochran_P", "R2")
results$IV <- args[1]
results$Outcome <- args[4]
results$NSNP <- scores[1,"nsnp"]
results$Method <- "2SLS"
results$B <- coef(summary(m_iv))[2 ,"Estimate"]
results$SE <- coef(summary(m_iv))[2 ,"Std. Error"]
results$P <- coef(summary(m_iv))[2 ,"Pr(>|z|)"]
results$OR <- exp(results$B)
results$Lower <- exp(results$B-(1.96*results$SE))
results$Upper <- exp(results$B+(1.96*results$SE))
results$R2 <- R2

#Non-Linear
if (args[3]=="CPD"){
	a<-nrow(fp$coefficients)+nrow(plm$xcoef)
	nlmrres<-data.frame(matrix(nrow=a, ncol=14))
	names(nlmrres) <- c("IV", "Outcome", "NSNP", "Method","Quintile",  "OR", "Lower", "Upper", "B", "P", "SE", "Power", "Cochran_P", "R2")
	nlmrres$IV <- args[1]
	nlmrres$Outcome <- args[4]
	nlmrres$NSNP <- scores[1,"nsnp"]
	nlmrres$Method[1:nrow(fp$coefficients)] <- "FP_NLMR"
	nlmrres$Method[(nrow(fp$coefficients)+1):a] <- "PL_NLMR"
	nlmrres$Quintile[nlmrres$Method=="PL_NLMR"] <- 1:nrow(nlmrres[nlmrres$Method=="PL_NLMR",])
	nlmrres$B[nlmrres$Method=="FP_NLMR"] <- fp$coefficients[,"beta"]
	nlmrres$B[nlmrres$Method=="PL_NLMR"] <- plm$lace[,"beta"]
	nlmrres$SE[nlmrres$Method=="FP_NLMR"] <- fp$coefficients[,"se"]
        nlmrres$SE[nlmrres$Method=="PL_NLMR"] <- plm$lace[,"se"]
	nlmrres$OR[nlmrres$Method=="FP_NLMR"] <- exp(fp$coefficients[,"beta"])
	nlmrres$OR[nlmrres$Method=="PL_NLMR"] <- exp(plm$lace[,"beta"])
	nlmrres$Lower[nlmrres$Method=="FP_NLMR"] <- exp(fp$coefficients[,"lci"])
	nlmrres$Lower[nlmrres$Method=="PL_NLMR"] <- exp(plm$lace[,"lci"])
	nlmrres$Upper[nlmrres$Method=="FP_NLMR"] <- exp(fp$coefficients[,"uci"])
	nlmrres$Upper[nlmrres$Method=="PL_NLMR"] <- exp(plm$lace[,"uci"])
	nlmrres$P[nlmrres$Method=="FP_NLMR"] <- fp$coefficients[,"pval"]
	nlmrres$P[nlmrres$Method=="PL_NLMR"] <- plm$lace[,"pval"]
	nlmrres$Power[nlmrres$Method=="FP_NLMR"] <- fp$powers
	nlmrres$Cochran_P[nlmrres$Method=="FP_NLMR"] <- fp$p_tests[,"Q"]
	nlmrres$Cochran_P[nlmrres$Method=="PL_NLMR"] <- plm$p_tests[,"Q"]
	nlmrres$R2 <- R2	
	results<-rbind(results, nlmrres)
}

#Save
setwd(OUTPUT)
write.table(results, args[5], quote=FALSE, row.names=FALSE)

