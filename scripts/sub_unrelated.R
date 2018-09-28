#!/usr/bin/env Rscript

# This script reads in a kinship table from PLINK2 --make-KING-table function, and returns a list of unrelated sample IDs (FID and IID)
# Requires one argument: the path for the kinship table. Optionally the output file name can be entered. By default, it will be saved in the same folder as the kinship table, with the name 'ID_samples_to_remove.txt'

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one arguments must be supplied (input file)", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "ID_samples_to_remove.txt"
	print(paste('Default output file name:', args[2], sep= " "))
}


suppressPackageStartupMessages(library(dplyr))
library(tidyr)

options(stringsAsFactors = FALSE)

kin_path= args[1]
out_filename= args[2]
out_path= gsub(basename(kin_path), "", kin_path)

SelectRelated= function(filename){
  kin= read.table(kin_path, h=T, comment.char = "", sep= '\t')
  kin= kin %>% mutate(ID1= paste(X.FID1,ID1, sep= ":"),
                      ID2= paste(FID2, ID2, sep= ":")) %>% select(ID1, ID2, KINSHIP)
  kin= kin %>% filter(KINSHIP>0.044)
  kin_temp= kin
  colnames(kin_temp)= c("ID2","ID1","KINSHIP")
  kin_temp= rbind(kin_temp, kin)  
  kin_temp= kin_temp %>% add_count(ID1)
  kin_temp= kin_temp %>% add_count(ID2)
  kin_temp= arrange(kin_temp, n, nn)
  to_keep= list()
  
  for (i in 1:nrow(kin_temp)) {
    if (kin_temp[i,"ID1"] %in% unlist(kin_temp[0:i,"ID2"])) {
      kin_temp[i,"ID2"]= "X"
    }
    else
      to_keep[[i]] <- kin_temp[["ID1"]][i]
  }
  to_remove= kin_temp %>% filter(!(ID1 %in% unlist(to_keep))) %>% select(ID1) 
  to_remove= to_remove[!duplicated(to_remove$ID1),]
  to_remove= to_remove %>% separate(ID1, c('FID','ID'), sep=":")

  return(to_remove)
}

to_remove= SelectRelated(kin_path)

cat(length(to_remove$FID)," samples to remove.\n")

write.table(to_remove, paste0(out_path,out_filename), sep= '\t', row.names = F, col.names = F, quote = F)

