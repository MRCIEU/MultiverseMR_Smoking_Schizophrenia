###################
# SET ENVIRONMENT #
###################

#Import HOME variable from Bash
HOME=Sys.getenv("HOME")

#Put path in variable
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")
INPUT=paste(HOME, "/scratch/MultiverseMR/code/inputs/", sep="")
args <- commandArgs(trailingOnly = TRUE)

#Load data.table package
library(data.table)

#############
# READ DATA #
#############

#Read Sumstats
setwd(INPUT)
snps<-fread(paste("snp-summary-stats-", args[1], sep=""), header=TRUE, data.table=F)

#Read and name snp data
setwd(DATA)
data<-fread("data-IDs.txt", header=TRUE, data.table=F)
names(data)[1]<-"app"

#If sibling data
if (args[2] == "sibs"){
	sibs<-fread("data-siblings.txt", select=c("app", "sibID"), header=TRUE, data.table=F)

	#Remove siblings not in main data or who's sibling isn't in main data
	sibs <- subset(sibs, sibs$app %in% data$app)
	sibs<-subset(sibs, sibs$sibID %in% sibs$sibID[duplicated(sibs$sibID)])

	#Remove those from main data who aren't siblings
	data <- subset(data, data$app %in% sibs$app)

	#Order and combine
	data <- merge(sibs, data)
	
	#Number of siblings
	print(nrow(data))
	#Number of sibling groups
	print(length(unique(data$sibID)))

}

#Number of individuals
print(nrow(data))

###################
# GENERATE SCORES #
###################

#Make score and snp number objects
scores <- vector(length=nrow(data))
nsnp<-0

#Calculate grs
for (i in 1:length(snps$rsid)){

	#Which columns of dosage data is matches the current row of the snp info
	index<-which(names(data)==snps$rsid[i]) 
	#Code dosage based on direction and count non-excluded SNPs
	if (snps$direction[i]==2){
		dosage <- data[,index]
		nsnp <- nsnp + 1
        } else if (snps$direction[i]==1){
		dosage <- 2 - data[,index]
		nsnp <- nsnp + 1
	} else if (snps$direction[i]==0){
			dosage <- 0
	}
	
	#Make dosage numeric
	dosage <- as.numeric(dosage)

	#Get weight
	if (args[3]=="weighted"){
		weight<-snps$LogOR_GWAS[i]
	} else {
		weight<-1
	}

	#Calculate scores (the dosages in each column multiplied by the effect of that snp on insomnia, summed across all columns)
	scores <- scores + (dosage * weight)
}	

#bind
scores<-cbind(data["app"], scores)
scores$nsnp<-rep(nsnp, nrow(scores))

#Mean Centre in sibling groups for sibling GRSs
if(args[2]=="sibs"){
	
	#Create temp dataframe
	datatemp<-data.frame(matrix(nrow=0, ncol=4))
	
	#Add sibling IDs to scores
	scores<-cbind(data["sibID"], scores)
	
	#Get unique list of sibling IDs
	sibids<-unique(scores$sibID)
	
	#For each sibling group get members, get mean and then subteract mean from score
	for (i in 1:length(sibids)){	
		sibs<-subset(scores, sibID==sibids[i])
		m<-mean(sibs$scores)
		sibs$scores<-sibs$scores-m
		datatemp<-rbind(datatemp, sibs)		
	}

	#Name and transfer
	names(datatemp)<-c("sibID", "app", "scores", "nsnp")
	scores<-datatemp
}

#Save
write.table(scores, args[4], row.names=FALSE, quote=FALSE)



