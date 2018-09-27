# This script is used to:
# 1) Extract chr and position for each genotyped genetic variant in HUNT (save it as 'chr pos pos'). We will use this for PCA in HapMap with variants only included if also found in HUNT.
# 2) Do a minor modification to HUNT plink .bim file (without overwriting the original). Genetic variant ID is defined as 'chr:pos:A1:A2' (no idea what A1 or A2 mean). We change it to 'chr:pos:A1:A2', where A1 is the highest alphabetically (has nothing to do with real ref and eff alleles, which are defined in different columns, so there is no need to modify .bed file).

library(dplyr)
library(tidyr)

file_path= '/mnt/archive/hunt/genotypes/plink/'
bim_file= 'genotyped_PID106764.bim'
outfile_range= '/mnt/work/pol/HUNT_PCA/hunt_chr_pos'
bim_outfile= '/mnt/work/pol/HUNT_PCA/modif_genotyped_PID106764.bim'


d= read.table(paste0(file_path, bim_file), h=F, sep= '\t')

x= d %>% select(V1, V4)
x$V5= x$V4

write.table(x, outfile_range, row.names=F, col.names=F, sep= '\t', quote= F)

d= d %>% separate(V2, c('chr','pos','A1','A2'), ':')

d[d$A1 < d$A2, c("A1", "A2")] = d[d$A1 <  d$A2, c("A2", "A1")] 

d= d %>% mutate(ID= paste(chr, pos, A1, A2, sep=':')) %>% select(V1, ID, V3, V4, V5,V6)

write.table(d, bim_outfile, row.names=F, col.names=F, sep= '\t', quote=F)


