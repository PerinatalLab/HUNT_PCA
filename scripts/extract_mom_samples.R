# Script to extract a list of unique maternal, paternal and fetal sample IDs

library(dplyr)

file_path= '/mnt/archive/hunt/genotypes/plink/'
all_samples= 'genotyped_PID106764.fam'
mfr= '/mnt/archive/hunt/phenotypes/mfr/MFR.txt'
outpath= '/mnt/work/pol/HUNT_PCA/'

d= read.table(paste0(file_path,all_samples), h=F, sep= ' ')
names(d)[1]= 'PID'

mfr= read.table(mfr, h=T, sep= '\t')

IDselect= function(x){
df= d %>% filter(PID %in% mfr[,x]) %>% select(PID)
if (x == 'MOR_PID'){
outfile= 'mother_samples'
} else if (x== 'FAR_PID'){
outfile= 'father_samples'
} else if (x== 'BARN_PID'){
outfile= 'fetal_samples'
} else {
break }
write.table(df, paste0(outpath, outfile), row.names=F, col.names=F, sep= '\t', quote=F)
}

lapply(c('MOR_PID', 'FAR_PID', 'BARN_PID'), IDselect) 

