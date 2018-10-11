

# Calculation of PCA in HapMap III unrelated samples. HapMapIII previously downloaded from ftp://ftp.ncbi.nlm.nih.gov/hapmap/genotypes/2010-05_phaseIII/plink_format/ and further converted to plink .bed, .bim, .fam files. 

cd ~/HUNT_PCA/

# This script depends on PLINK v2.00a1LM and v1.90b6.5

# 1) Modify HapMap III .bim file

echo 'Step 1. Modify HapMap III .bim file so that variant ID is 'chr:pos:A1:A2', where A1 is alphabetically higher than A2.'

Rscript --vanilla scripts/sub_hapmap_bim.R /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.bim /mnt/work/pol/hapmap/modified_hapmap3_full_r1_b37_fwd.bim

Rscript --vanilla scripts/sub_hapmap_bim.R /mnt/archive/hunt/genotypes/plink/genotyped_PID106764.bim /mnt/work/pol/HUNT_PCA/modif_genotyped_PID106764.bim

# 2) Obtain list of unrelated samples

echo 'Step 2. Calculate kinship coefficient for relatedness...'

../soft/plink2 --bed /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.bed --bim /mnt/work/pol/hapmap/modified_hapmap3_full_r1_b37_fwd.bim --fam /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.fam --make-king-table --king-table-filter 0.03125 --out raw_data/tmp_hapmap_relatedness

echo 'Obtaining list of related samples...'

Rscript --vanilla scripts/sub_unrelated.R raw_data/tmp_hapmap_relatedness.kin0 hapmap_related.txt

# 3) Filter HapMap III variants

echo 'Step 3. Obtain list of independent variants in HapMap III overlapping with HUNT, with MAF > 0.01'

../soft/plink2 --bed /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.bed --bim /mnt/work/pol/hapmap/modified_hapmap3_full_r1_b37_fwd.bim --fam /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.fam --extract range /mnt/work/pol/HUNT_PCA/hunt_chr_pos --maf 0.01 --indep-pairwise 50 5 0.2 --out raw_data/tmp_hapmap_filtered_variants

echo 'Merge HUNT and HAPMAP III'

# 4) Merge the two data plink files

../soft/plink --bed /mnt/archive/hunt/genotypes/plink/genotyped_PID106764.bed --bim /mnt/work/pol/HUNT_PCA/modif_genotyped_PID106764.bim --fam /mnt/archive/hunt/genotypes/plink/genotyped_PID106764.fam --bmerge /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.bed /mnt/work/pol/hapmap/modified_hapmap3_full_r1_b37_fwd.bim /mnt/work/pol/hapmap/hapmap3_full_r1_b37_fwd.fam --merge-equal-pos --out /mnt/work/pol/hapmap/merged_hunt_hapmap


# 5) Calculate PC in HapMap III

echo 'Step 4. Calculate PC in HapMap III, removing related samples and only using genotyped genetic variants from HUNT.'

../soft/plink2 --bfile /mnt/work/pol/hapmap/merged_hunt_hapmap --extract raw_data/tmp_hapmap_filtered_variants.prune.in --remove <(cat raw_data/hapmap_related.txt /mnt/work/hunt/relatedness/mother_samples_related /mnt/work/pol/HUNT_PCA/fetal_samples /mnt/work/pol/HUNT_PCA/father_samples) --memory 12000 --pca 2 approx --out /mnt/work/hunt/pca/mother_hapmap_pca

rm raw_data/tmp*










