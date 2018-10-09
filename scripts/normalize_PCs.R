# This script normalizes the eigenve

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one arguments must be supplied (input file)", call.=FALSE)
} else if (length(args)==2) {

  bim_in= args[1]
  bim_out= args[2]
        print(paste('Output file name:', args[2], sep= " "))
}

options(stringsAsFactors = FALSE)

eigen_file= args[1]
pcs_file= args[2]

library(dplyr)

eigenvalues= read.table(eigen_file, h=F, sep= '\t')
pcs= read.table(pcs_file, h=F, sep= '\t')
names(pcs)= c('FID','IID','PC1','PC2','PC3','PC4','PC5','PC6','PC7','PC8','PC9','PC10')

for (i in length(eigenvalues$V1)){
pcs[,i]= pcs[,i] * sqrt(eigenvalues$V1[i]) 
}

write.table(pcs_file)

