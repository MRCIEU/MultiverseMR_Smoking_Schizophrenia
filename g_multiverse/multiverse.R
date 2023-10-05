#Import HOME variable from Bash
HOME=Sys.getenv("HOME")
LIB=Sys.getenv("LIB")

#Put path in variable
OUTPUT=paste(HOME, "/scratch/MultiverseMR/output/", sep="")

#Load packages
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggtext, lib=LIB)
library(forcats)
library(metafor)
library(scales)
library(stringr)

#############
# READ DATA #
#############

#Get file names
setwd(OUTPUT)
fl_1smr<-list.files(path = ".", pattern = "1SMR_")
fl_2smr<-list.files(path = ".", pattern = "2SMR_")
fl_presso<-list.files(path = ".", pattern = "PRESSO_")
fl_grsreg<-list.files(path = ".", pattern = "GRSREG_")

#Create function to read, combine and save results files for each method
read<-function(list, saveas){
	data<-fread(list[1], header=TRUE, data.table=F)
	for(i in 2:length(list)){
		temp<-fread(list[i], header=TRUE, data.table=F)
		data<-rbind(data, temp)
	}
	write.table(data, saveas, quote=FALSE, row.names=FALSE)
	return(data)
}

#Read and combine for each method
res_1smr <- read(fl_1smr, "1SMR-results.txt")
res_2smr <- read(fl_2smr, "2SMR-results.txt")
res_presso <- read(fl_presso, "Presso-results.txt")
res_grsreg <- read(fl_grsreg, "GRSreg-results.txt")

#Combine results for each method into MR (1 and 2 sample) and NLMR
cols<-c("IV", "Outcome", "NSNP", "Method", "OR", "Lower", "Upper", "B", "SE", "P")
results<-rbind(res_1smr[!(res_1smr$Method %in% c("FP_NLMR","PL_NLMR")),cols], res_2smr[,cols])
nlmr<-res_1smr[res_1smr$Method == "PL_NLMR",]

##########
# FORMAT #
##########

#Reformat for MR
results$Exposure[grepl("init", results$IV, fixed=TRUE)]<-"Initiation"
results$Exposure[grepl("cpd", results$IV, fixed=TRUE)]<-"Heaviness"
results$Score[grepl("1", results$IV, fixed=TRUE)]<-"Liu(2019)"
results$Score[grepl("2", results$IV, fixed=TRUE) & grepl("init", results$IV, fixed=TRUE)]<-"Xu(2020)"
results$Score[grepl("2", results$IV, fixed=TRUE) & grepl("cpd", results$IV, fixed=TRUE)]<-"rs16969968"
results$Design[grepl("2SLS|FP_NLMR|PL_NLMR", results$Method)]<-paste("1SMR", "_(",results$NSNP[grepl("2SLS|FP_NLMR|PL_NLMR", results$Method)],"SNPs)", sep="")
results$Design[!grepl("2SLS|FP_NLMR|PL_NLMR", results$Method)]<-paste("2SMR", "_(",results$NSNP[!grepl("2SLS|FP_NLMR|PL_NLMR", results$Method)],"SNPs)", sep="")
results$Weighted[grepl("weighted", results$IV)]<-"Weighted"
results$Weighted[grepl("unweighted", results$IV)]<-"Unweighted"
results$Weighted[!(grepl("weighted", results$IV))]<-"NA"
results$Method[grepl("sib", results$IV)]<-"Within-siblings"
results$Method[grepl("2SLS", results$Method)]<-"Standard"
results$Method[grepl("Inverse-variance-weighted", results$Method)]<-"IVW"
results$Outcome[grepl("2", results$Outcome)]<-"F20-24,F26-29"
results$Outcome[grepl("1", results$Outcome)]<-"F20"
results$Outcome[grepl("3", results$Outcome)]<-"F20-29"
results$Z<-results$B/results$SE 
results$Sig[results$P<0.05]<-"*"
results$Sig[results$P>0.05]<-" "

#Format for GRS
res_grsreg$Sample[grepl("current", res_grsreg$Sample)]<-"Current"
res_grsreg$Sample[grepl("never", res_grsreg$Sample)]<-"Never"
res_grsreg$Score[grepl("1", res_grsreg$IV, fixed=TRUE)]<-"Liu(2019)"
res_grsreg$Score[grepl("2", res_grsreg$IV, fixed=TRUE)]<-"rs16969968"
res_grsreg$Weighted[grepl("weighted", res_grsreg$IV)]<-"Weighted"
res_grsreg$Weighted[grepl("unweighted", res_grsreg$IV)]<-"Unweighted"
res_grsreg$Weighted[grepl("2", res_grsreg$IV, fixed=TRUE)]<-"NA"
res_grsreg$Outcome[grepl("2", res_grsreg$Outcome)]<-"F20-24,F26-29"
res_grsreg$Outcome[grepl("1", res_grsreg$Outcome)]<-"F20"
res_grsreg$Outcome[grepl("3", res_grsreg$Outcome)]<-"F20-29"
res_grsreg$Z<-res_grsreg$B/res_grsreg$SE
res_grsreg$Sig[res_grsreg$P<0.05]<-"*"
res_grsreg$Sig[res_grsreg$P>0.05]<-" "

#Format for NLMR
nlmr$Score[grepl("1", nlmr$IV, fixed=TRUE)]<-"Liu(2019)"
nlmr$Score[grepl("2", nlmr$IV, fixed=TRUE)]<-"rs16969968"
nlmr$Weighted[grepl("weighted", nlmr$IV)]<-"Weighted"
nlmr$Weighted[grepl("unweighted", nlmr$IV)]<-"Unweighted"
nlmr$Weighted[grepl("2", nlmr$IV, fixed=TRUE)]<-"NA"
nlmr$Outcome[grepl("2", nlmr$Outcome)]<-"F20-24,F26-29"
nlmr$Outcome[grepl("1", nlmr$Outcome)]<-"F20"
nlmr$Outcome[grepl("3", nlmr$Outcome)]<-"F20-29"
nlmr$Z<-nlmr$B/nlmr$SE
nlmr$Sig[nlmr$P<0.05]<-"*"
nlmr$Sig[nlmr$P>0.05]<-" "

#Save
write.table(results, "MRheatmap.txt", sep="\t", quote=FALSE, row.names=FALSE)
write.table(res_grsreg, "GRSheatmap.txt", sep="\t",  quote=FALSE, row.names=FALSE)
write.table(nlmr, "NLMRheatmap.txt", sep="\t",  quote=FALSE, row.names=FALSE)

###########
# HEATMAP #
###########

#MR
PlotMR <- ggplot(results, aes(Outcome, interaction(Exposure, Score, Design, Weighted, Method, lex.order=TRUE))) +
  geom_tile(aes(fill = Z))+
  ggtitle("Odds Ratio (95%CI)") +
  ylab("Analysis (Exposure, IV, Design, Weighting, Method)") +
  scale_fill_gradient2(low = "#de2d26", mid = "#f0f0f0", high = "#3182bd", midpoint = 0) +
  geom_text(aes(label = paste(round(OR, 2), " (", round(Lower, 2), ", ", round(Upper, 2), ")", Sig, sep="")))+
  facet_grid(rows = vars(Exposure, Score, Design, Weighted, Method), 
             scales = "free_y",
             space = "free_y",
             switch="y")+
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), 
        axis.title.y=element_text(size=10, face="bold"),
        axis.text.x=element_text(size=10),
        axis.title.x=element_text(size=10, face="bold"),
        legend.text = element_text(size=10), 
        legend.title = element_text(size=10),
        plot.title = element_text(hjust = 0.5, size=10),
        strip.text = element_textbox_simple(padding = margin(0, -1, 0, -1), margin = margin(0, -1, 0, -1), size = 10), 
        strip.text.y.left = element_text(angle = 0), 
        strip.background = element_blank(), 
        panel.spacing = unit(-0.25, "cm"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.background = element_blank())
ggsave("MRheatmap.jpg")

#GRS-regression
PlotGRS <- ggplot(res_grsreg, aes(Outcome, interaction(Sample, Score, Weighted, lex.order=TRUE))) +
  geom_tile(aes(fill = Z))+
  ggtitle("Odds Ratio (95%CI)") +
  ylab("Analysis (Sample, IV, Weighting)") +
  scale_fill_gradient2(low = "#de2d26", mid = "#f0f0f0", high = "#3182bd", midpoint = 0.05) +
  geom_text(aes(label = paste(round(OR, 2), " (", round(Lower, 2), ", ", round(Upper, 2), ")", Sig, sep="")))+
  facet_grid(rows = vars(Sample, Score, Weighted), 
             scales = "free_y",
             space = "free_y",
             switch="y")+
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.title.y=element_text(size=15, face="bold"),
        axis.text.x=element_text(size=15),
        axis.title.x=element_text(size=15, face="bold"),
        legend.text = element_text(size=15), 
        legend.title = element_text(size=15),
        plot.title = element_text(hjust = 0.5, size=15),
        strip.text = element_textbox_simple(size = 15),
        strip.text.y.left = element_text(angle = 0), 
        strip.background = element_blank(), 
        panel.spacing = unit(-0.75, "cm"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.background = element_blank())
ggsave("GRSheatmap.jpg")

#Non-Linear
PlotNLMR <- ggplot(nlmr, aes(Outcome, interaction(Score, Weighted, Quintile, lex.order=TRUE))) +
  geom_tile(aes(fill = Z))+
  ggtitle("Odds Ratio (95%CI)") +
  ylab("Analysis (IV, Weighting, Quintile)") +
  scale_fill_gradient2(low = "#de2d26", mid = "#f0f0f0", high = "#3182bd", midpoint = 0) +
  geom_text(aes(label = paste(round(OR, 2), " (", round(Lower, 2), ", ", round(Upper, 2), ")", Sig, sep="")))+
  facet_grid(rows = vars(Score, Weighted, Quintile), 
             scales = "free_y",
             space = "free_y",
             switch="y")+
  theme(axis.text.y=element_blank(),
        axis.ticks.y=element_blank(), 
        axis.title.y=element_text(size=10, face="bold"),
        axis.text.x=element_text(size=10),
        axis.title.x=element_text(size=10, face="bold"),
        legend.text = element_text(size=10), 
        legend.title = element_text(size=10),
        plot.title = element_text(hjust = 0.5, size=10),
        strip.text = element_textbox_simple(padding = margin(0, -1, 0, -1), margin = margin(0, -1, 0, -1), size = 10), 
        strip.text.y.left = element_text(angle = 0), 
        strip.background = element_blank(), 
        panel.spacing = unit(-0.25, "cm"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        panel.background = element_blank())
ggsave("NLMRheatmap.jpg")


