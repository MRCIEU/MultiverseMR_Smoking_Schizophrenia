#Import the Home varible from bash
HOME=Sys.getenv("HOME")

#Put filepaths in variables
DATA=paste(HOME, "/scratch/MultiverseMR/data/", sep="")

#Load packages
library(data.table)
library(dplyr)

#############
# LOAD DATA #
#############

setwd(DATA)
data<-read.table("data-related.txt", header=TRUE)
siblings<-read.table("siblings.txt",  header=TRUE)
print(nrow(siblings))

##########
# FILTER #
##########

#Keep only pairs with a first degree (non-parent-child) relative in the data
siblings<-subset(siblings, (Kinship > 0.177 & Kinship < 0.354 & IBS0 > 0.0012))
print(nrow(siblings))

############
# REFORMAT #
############

#Make new dataframe for sibling data, and set first sibling ID to 1
sib_long<-data.frame(matrix(nrow=0, ncol=2))
id<-1

#Loop through siblings
for (i in 1:nrow(siblings)){

	#If neither sibling is in the data yet add them both with the same sibling ID, then add 1 to the ID object so the next sibling group get a different group
	if(!(siblings$ID1[i] %in% sib_long[,1]) & !(siblings$ID2[i] %in% sib_long[,1])){
		sib_long<-rbind(sib_long, c(siblings$ID1[i], id))
		sib_long<-rbind(sib_long, c(siblings$ID2[i], id))
		id<-id+1

	#If one is in the data (it can't be both) and sibling1 isn't then add to data with the sibling ID of sibling2
	}else if(!(siblings$ID1[i] %in% sib_long[,1])){
		sib_long<-rbind(sib_long, c(siblings$ID1[i], sib_long[which(sib_long[,1] == siblings$ID2[i]),2]))

	#If sibling 2 isn't in the data then add sibling2 to the data with the sibling id of sibling 1
	}else if(!(siblings$ID2[i] %in% sib_long[,1])){
                sib_long<-rbind(sib_long, c(siblings$ID2[i], sib_long[which(sib_long[,1] == siblings$ID1[i]),2]))
        }	
}
names(sib_long)<-c("f.eid", "sibID")
print(nrow(sib_long))

#########
# MERGE #
#########

data <- merge(data, sib_long)
print(nrow(data))

#Remove those without sibling
data<-subset(data, data$sibID %in% data$sibID[duplicated(data$sibID)])
print(nrow(data))

#Number of sibling groups
print(length(unique(data$sibID)))

########
# SAVE #
########

write.table(data, "data-siblings.txt", quote=FALSE, row.names=FALSE)
