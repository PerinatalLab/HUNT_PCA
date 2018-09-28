#!/bin/bash

# Calculation of PCA in HapMap III unrelated samples. HapMapIII previously downloaded from ftp://ftp.ncbi.nlm.nih.gov/hapmap/genotypes/2010-05_phaseIII/plink_format/ and further converted to plink .bed, .bim, .fam files. 

cd ~/HUNT_PCA/

# This script depends on PLINK v2.00a1LM.

# 1) Modify HapMap III .bim file

echo 'Step 1. Modify HapMap III .bim file so that variant ID is 'chr:pos:A1:A2', where A1 is alphabetically higher than A2.'

Rscript --vanilla scripts/sub_hapmap_bim.R /mnt/hdd/data/geno/references/hapmap3_full_r1_b37_fwd.bim /mnt/hdd/common/HUNT_PCA/hapmap_mod/hapmap3_full_r1_b37_fwd_mod.bim

cp /mnt/hdd/data/geno/references/hapmap3_full_r1_b37_fwd.bed /mnt/hdd/common/HUNT_PCA/hapmap_mod/hapmap3_full_r1_b37_fwd_mod.bed

cp /mnt/hdd/data/geno/references/hapmap3_full_r1_b37_fwd.fam /mnt/hdd/common/HUNT_PCA/hapmap_mod/hapmap3_full_r1_b37_fwd_mod.fam

# 2) Obtain list of unrelated samples

echo 'Step 2. Calculate kinship coefficient for relatedness...'

~/software/plink2 --bfile /mnt/hdd/common/HUNT_PCA/hapmap_mod/hapmap3_full_r1_b37_fwd_mod --make-king-table --king-table-filter 0.03125 --out raw_data/tmp_hapmap_relatedness

echo 'Obtaining list of related samples...'

Rscript --vanilla scripts/sub_unrelated.R raw_data/tmp_hapmap_relatedness.kin0 hapmap_related.txt

# 3) Filter HapMap III variants

echo 'Step 3. Obtain list of independent variants in HapMap III overlapping with HUNT, with MAF > 0.01'

~/software/plink2 --bfile /mnt/hdd/common/HUNT_PCA/hapmap_mod/hapmap3_full_r1_b37_fwd_mod --extract range /mnt/hdd/common/HUNT_PCA/hunt_chr_pos --maf 0.01 --indep-pairwise 50 5 0.2 --out raw_data/tmp_hapmap_filtered_variants

# 4) Calculate PC in HapMap III

echo 'Step 4. Calculate PC in HapMap III, removing related samples and only using genotyped genetic variants from HUNT.'

~/software/plink2 --bfile /mnt/hdd/common/HUNT_PCA/hapmap_mod/hapmap3_full_r1_b37_fwd_mod --extract raw_data/tmp_hapmap_filtered_variants.prune.in --remove raw_data/hapmap_related.txt --pca var-wts --out raw_data/pca_hapmap


rm raw_data/tmp*
rm raw_data/pca_hapmap.eigenvec raw_data/pca_hapmap.eigenval
