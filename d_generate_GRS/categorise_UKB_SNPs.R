###################
# SET ENVIRONMENT #
###################

#Import HOME variable from bash
HOME=Sys.getenv("HOME")

#Put paths in variable
INPUT=paste(HOME, "/scratch/MultiverseMR/code/inputs/", sep="")
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")

#Load data.table package
library(data.table)

########################
# READ AND FORMAT DATA #
########################

setwd(DATA)
snp_summary_statsOG<-fread("snps-dosage.txt", select=c(3, 6), header=FALSE, data.table=F)
EAFData<-fread("snp_stats/EAF.txt", header=FALSE, data.table=F)

#Set column names
names(snp_summary_statsOG)=c("rsid", "effect_allele")
names(EAFData)=c("rsid", "EAF")

#Add rownumber column tp UKB snps so rows can be re-ordered
rownum  <- 1:nrow(snp_summary_statsOG)
snp_summary_statsOG<-cbind(snp_summary_statsOG, rownum)

#Merge with EAF data
snp_summary_statsOG<-merge(snp_summary_statsOG, EAFData, by = "rsid")

#Return rows to original order
rownum<-snp_summary_statsOG$rownum
snp_summary_statsOG <- snp_summary_statsOG[order(rownum),]

##############
# CATEGORISE #
##############

#Create new function
categorise <- function(GWAS, pal=TRUE){

	##############
	# READ FILES #
	##############

	setwd(INPUT)
	if (pal==FALSE){
		logORlist<-fread(GWAS, header=TRUE, data.table=F)
		logORlist$pal<-0
	} else {
		logORlist<-fread(paste("aligned-", GWAS, sep=""), header=TRUE, data.table=F)		
	}
	direction<-vector(length = length(logORlist$rsID))
	snp_summary_stats<-snp_summary_statsOG

	####################
	# ASSIGN DIRECTION #
	####################

	#Loop through SNPs in list
	for (i in 1:length(logORlist$rsID)){ 

		###############
		# FLIP STRAND #
		###############

		#Check Strands are same between GWAS and UK Biobank and if not flip UK Biobank
		index<-which(snp_summary_stats$rsid==logORlist$rsID[i])
		if ((snp_summary_stats$effect_allele[index]!=logORlist$Alternate_Allele[i]) & (snp_summary_stats$effect_allele[index]!=logORlist$Reference_Allele[i]) & (logORlist$pal[i]==0)){
			print(snp_summary_stats[index,])
			print(logORlist[i,])
                       if (snp_summary_stats$effect_allele[index]=="A") {
                              snp_summary_stats$effect_allele[index]<-"T"
                        } else if (snp_summary_stats$effect_allele[index]=="T") {
                                snp_summary_stats$effect_allele[index]<-"A"
                        } else if (snp_summary_stats$effect_allele[index]=="C") {
                                snp_summary_stats$effect_allele[index]<-"G"
                        } else if (snp_summary_stats$effect_allele[index]=="G") {
                                snp_summary_stats$effect_allele[index]<-"C"
                        } 
		} 

		#############
		# DIRECTION #
		#############
		
		#Record direction of UK Biobank, 2 for matched, 1 for not, 0 for palindromic with ambiguous EAF
		if((snp_summary_stats$effect_allele[index]==logORlist$Alternate_Allele[i]) & (logORlist$pal[i]==0)){
			direction[i]<-2
		} else if ((snp_summary_stats$effect_allele[index]==logORlist$Reference_Allele[i]) & (logORlist$pal[i]==0)){
			direction[i] <-1
		} else if (logORlist$pal[i]==1){
			if (is.na(logORlist$EAF[i])){
				direction[i]<-0
			} else if (((logORlist$EAF[i]<0.45) & (snp_summary_stats$EAF[index]<0.45)) | ((logORlist$EAF[i]>0.55) & (snp_summary_stats$EAF[index]>0.55))){
				direction[i]<-2
			} else if (((logORlist$EAF[i]<0.45) & (snp_summary_stats$EAF[index]>0.55)) | ((logORlist$EAF[i]>0.55) & (snp_summary_stats$EAF[index]<0.45))){
				direction[i]<-1
                        } else {
				direction[i]<-0
			}   
		}
	}

	##########
	# FORMAT #
	##########

	#Update names in LogORlist to avoid duplicate column names when merged with the UKB snps
	names(logORlist)=c("rsid", "other_allele_GWAS", "effect_allele_GWAS", "EAF_GWAS", "LogOR_GWAS", "SE_GWAS",  "pal")

	#Bind UKB snps with the direction vector
	logORlist<-cbind(logORlist, direction)

	#Merge LogORlist with UKB snp info
	complete_snp_summary_stats <- merge(snp_summary_stats, logORlist, by="rsid")

	#Use row number to reorder
	completerownum<-complete_snp_summary_stats$rownum
	complete_snp_summary_stats <- complete_snp_summary_stats[order(completerownum),]

	#Save table
	write.table(complete_snp_summary_stats, paste("snp-summary-stats-", GWAS, sep=""), row.names=FALSE, sep = " ", quote=FALSE)
}

categorise("smokeinit1snps.txt")
categorise("smokeinit2snps.txt")
categorise("cpd1snps.txt")
categorise("cpd2snps.txt", pal=FALSE)
