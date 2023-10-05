###################
# SET ENVIRONMENT #
###################

#Import HOME variable from bash
HOME=Sys.getenv("HOME")

#Put path in variable
INPUT=paste(HOME, "/scratch/MultiverseMR/code/inputs/", sep="")
 
#Load data.table package
library(data.table)

#########
# ALIGN #
#########

#Create function
align_LogORlist <- function(GWAS, Proxies=FALSE){

	#Set working directory
	setwd(INPUT)

	#Read GWAS summary data (logORlist)
	list<-fread(paste(GWAS, ".txt", sep=""), header=TRUE, data.table=F)

	###########
	# PROXIES #
	###########

	#Put proxies in main columns if present
	if (Proxies==TRUE){
		for (i in 1:nrow(list)){
			if (!is.na(list$Available_Proxy[i])){
				list$rsID[i]<-list$Available_Proxy[i]
				list$Reference_Allele[i]<-list$Proxy_Reference_Allele[i]
				list$Alternate_Allele[i]<-list$Proxy_Alternate_Allele[i]
				list$Available[i]<-"Yes"				
			}
		}

		#Remove unavailable SNPs
		list<-subset(list, Available=="Yes")
		
		#Remove Proxy columns
		list<-list[,c("rsID", "Reference_Allele", "Alternate_Allele", "EAF", "Beta", "SE")]
	}


	##################
	# CODE DIRECTION #
	##################

	#Make vector called direction which is the length of the number of snps
	direction<-vector(length = length(list$rsID))

	#Mark snps increasing or decreasing insomnia in the direction vector 
	for (i in 1:length(list$rsID)){
		if (list$Beta[i]<0){
			direction[i] <- 0
		} else {
			direction[i] <- 1
		}
	}

	####################
	# CODE PALINDROMIC #
	####################

	#Make vector of same length called 'pal'
	pal<-vector(length = length(list$rsID))

	#Mark snps as palindromic or not in pal vector
	for (i in 1:length(list$rsID)){
	        if ((list$Alternate_Allele[i]=="A" & list$Reference_Allele[i]=="T") | (list$Alternate_Allele[i]=="T" & list$Reference_Allele[i]=="A") | (list$Alternate_Allele[i]=="C" & list$Reference_Allele[i]=="G") | (list$Alternate_Allele[i]=="G" & list$Reference_Allele[i]=="C")){
	                pal[i] <- 1
	        } else {
			pal[i] <- 0
	        }
	}

	########
	# FLIP #
	########

	#Combine LogORList to direction vector and pal vector seperately (i.e. make two seperate tables). Then print these.
	origlist<-cbind(list, direction)
	list<-cbind(list, pal)

	#Use the list with direction to flip snps (invert EAF, LogOR and swap alleles) which decrease exposure in the other list (the list with the pal vector)
	for (i in 1:length(list$rsID)){
		if (origlist$direction[i]==0){
			list$EAF[i]<- 1 - list$EAF[i]
        		list$Beta[i]<- list$Beta[i]*(-1)
        		temp<-list$Reference_Allele[i]
        		list$Reference_Allele[i]<-list$Alternate_Allele[i]
        		list$Alternate_Allele[i]<-temp
		}
	}

	########
	# SAVE #
	########

	#Save both lists
	write.table(origlist, paste("direction-", GWAS, ".txt", sep=""), row.names=FALSE, sep = " ", quote=FALSE)
	write.table(list, paste("aligned-", GWAS, ".txt", sep=""), row.names=FALSE, sep = " ", quote=FALSE)
}

align_LogORlist("smokeinit1snps", Proxies=TRUE)
align_LogORlist("smokeinit2snps")
align_LogORlist("cpd1snps")
