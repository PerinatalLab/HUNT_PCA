!/bin/bash

# Calculation of PCA in HUNT unrelated samples. PCs will be obtained independently for mothers, fathers and fetus.  

cd ~/HUNT_PCA/

# This script depends on PLINK v2.00a1LM.

echo 'Step 1. Obtain a list of unrelated IDs (for mothers, fathers and fetus).\n'
mkdir /mnt/work/hunt/relatedness

for sample in /mnt/work/pol/HUNT_PCA/*samples
do
~/soft/plink2 --bfile /mnt/archive/hunt/genotypes/plink/genotyped_PID106764 --keep "$sample" --make-king-table --king-table-filter 0.03125 --out /mnt/work/hunt/relatedness/$(basename "$sample" _sample)_related
done

echo 'Obtaining list of related samples...'

for sample in /mnt/work/hunt/relatedness/*.kin0
do
Rscript --vanilla scripts/sub_unrelated.R "$sample" /mnt/work/hunt/relatedness/$(basename "$sample" .kin0)_list
done

echo 'Step 2. Obtain PC weights in HUNT, removing related samples, and only using MAF >0.01'

for sample in /mnt/work/hunt/relatedness/*_list
do
~/soft/plink2 --bfile /mnt/archive/hunt/genotypes/plink/genotyped_PID106764 --maf 0.01 --remove "$sample" --pca var-wts --out /mnt/work/hunt/pca/$(basename "$sample" _samples_related_list)
done

echo 'Step 3. Project all subjects into these PCs'


../soft/plink2 --bfile /mnt/archive/hunt/genotypes/plink/genotyped_PID106764 --keep /mnt/work/pol/HUNT_PCA/mother_samples --score /mnt/work/hunt/pca/mother.eigenvec.var 2 3 header-read no-mean-imputation variance-standardize --score-col-nums 5-14 --out /mnt/work/hunt/pca/mother_pca

../soft/plink2 --bfile /mnt/archive/hunt/genotypes/plink/genotyped_PID106764 --keep /mnt/work/pol/HUNT_PCA/fetal_samples --score /mnt/work/hunt/pca/fetal.eigenvec.var 2 3 header-read no-mean-imputation variance-standardize --score-col-nums 5-14 --out /mnt/work/hunt/pca/fetal_pca

../soft/plink2 --bfile /mnt/archive/hunt/genotypes/plink/genotyped_PID106764 --keep /mnt/work/pol/HUNT_PCA/father_samples --score /mnt/work/hunt/pca/father.eigenvec.var 2 3 header-read no-mean-imputation variance-standardize --score-col-nums 5-14 --out /mnt/work/hunt/pca/father_pca

echo 'Finished!'
