# This script is part of XXX and should not be run alone. 
# Requires two arguments: first, the path for the .bim file, and second, the path for the output .bim file.
# This script modifies variant ID from the .bim file to match 'chr:pos:A1:A2', where A1 is alphabetically higher than A2. Note that we do NOT modify A1 or A2, but rather the variant ID. 

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one arguments must be supplied (input file)", call.=FALSE)
} else if (length(args)==2) {
	
  bim_in= args[1]
  bim_out= args[2]
        print(paste('Output file name:', args[2], sep= " "))
}


suppressPackageStartupMessages(library(dplyr))
library(tidyr)

options(stringsAsFactors = FALSE)

bim= read.table(bim_in, h=F, sep= '\t')
names(bim)= c('chr','rsid','cM','pos','A1','A2')
tmp_bim= bim
tmp_bim[tmp_bim$A1 < tmp_bim$A2, c("A1", "A2")] = tmp_bim[tmp_bim$A1 <  tmp_bim$A2, c("A2", "A1")]

tmp_bim= tmp_bim %>% mutate(variant= paste(chr, pos, A1, A2, sep=':')) %>% select(chr, rsid, variant, pos)

bim= inner_join(bim, tmp_bim, by= c('chr','rsid','pos')) %>% select(chr, variant, cM,  pos, A1, A2)

write.table(bim, bim_out, sep= '\t', row.names=F, col.names=F, quote=F)

