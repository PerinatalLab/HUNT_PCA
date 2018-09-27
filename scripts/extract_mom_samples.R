# Script to extract a list of unique maternal sample IDs

library(dplyr)

file_path= '/mnt/archive/hunt/genotypes/plink/'
all_samples= 'genotyped_PID106764.fam'
mfr= '/mnt/archive/hunt/phenotypes/mfr/MFR.txt'
outfile= '/mnt/work/pol/HUNT_PCA/mother_samples'


d= read.table(paste0(file_path,all_samples), h=F, sep= ' ')
names(d)[1]= 'PID'

mfr= read.table(mfr, h=T, sep= '\t')

x= d %>% filter(PID %in% mfr$MOR_PID) %>% select(PID)

write.table(x, outfile, row.names=F, col.names=T, sep= '\t', quote=F)

