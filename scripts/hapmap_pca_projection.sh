#!/bin/bash

echo 'Project HUNT samples onto HapMap III PCs.'

cd ~/HUNT_PCA/

# This script depends on PLINK v2.00a1LM.

../soft/plink2 --bfile /mnt/archive/genotypes/plink/X --read-freq pca_hapmap.afreq --score pca_hapmap.eigenvec.var 2 3 header-read no-mean-imputation variance-normalize --score-col-nums 5-14 --out pca_proj_mydata



