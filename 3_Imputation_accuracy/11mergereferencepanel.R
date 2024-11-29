# This script takes the resequenced samples and merges them with the previously sequenced samples, that have been verified as duplicates using script as in 10checkaccuracy.sh

R.Version()
library(readr)
library(tidyverse)
library(dplyr)
library(readxl)
library(openxlsx)
library(ggplot2)
library("data.table") 
setwd("~/Documents/GitHub/InProgressGenomicsInbreedingSeychellesWarblers/Data")

##Merge reference panel
ReferencePanel<- read.delim("duplicatereferencepairs0.3na1.kin0",sep=" ",header=T,col.names=c("","Resequence","","SeqID","","","",""),row.names=NULL)
ReferencePanel<- subset(ReferencePanel, select = -c(X,X.1,X.2,X.3,X.4,X.5) )
ReferencePanel[] <- lapply(ReferencePanel, gsub, pattern='./Clean_aligned/', replacement='')

#Add in filepaths
ReferencePanel<-merge(ReferencePanel, SequencedIndividualsBirdIDsExtraDeduplicated , by="SeqID") %>%
                        select(Resequence,Filepath) #SequencedIndividualsBirdIDsExtraDeduplicated can be found here https://github.com/kiran-lee/InbreedingDepressionSeychellesWarbler/blob/main/DataandResults/Seychelles_warbler_traits.txt
ReferencePanel$Merged_output<-ReferencePanel$Filepath
ReferencePanel$Resequence <- sub("^", "/fastdata/bop21kgl/RawData/LIMS202103/Clean_aligned/", ReferencePanel$Resequence )
ReferencePanel$Merged_output<-gsub(".*/","",ReferencePanel$Merged_output)
ReferencePanel$Merged_output <- sub("^", "/fastdata/bop21kgl/RawData/LIMSMERGED/Clean_aligned/", ReferencePanel$Merged_output )
ReferencePanel$Command= "samtools merge"
ReferencePanel<-ReferencePanel[,c(4,3,1,2)]

#Write out commands for samtools to merge files
write.table(ReferencePanel, file = "ReferencePanel.txt", sep = " ",
            col.names = F, row.names = F, quote = FALSE)