#!/bin/bash

echo 'Project HUNT samples onto HapMap III PCs.'

cd ~/HUNT_PCA/

# This script depends on PLINK v2.00a1LM.

mkdir /mnt/work/hunt/pca
mkdir /mnt/work/hunt/pca/hapmap_projected

for samples in /mnt/work/pol/HUNT_PCA/*_samples
do
../soft/plink2 --bed /mnt/archive/hunt/genotypes/plink/genotyped_PID106764.bed --fam /mnt/archive/hunt/genotypes/plink/genotyped_PID106764.fam --bim /mnt/work/pol/HUNT_PCA/modif_genotyped_PID106764.bim --keep "$samples"--score raw_data/pca_hapmap.eigenvec.var 2 3 header-read no-mean-imputation variance-standardize --score-col-nums 5-14 --out /mnt/work/hunt/pca/hapmap_projected/$(basename "$samples" _samples)_hapmap_pca
done


