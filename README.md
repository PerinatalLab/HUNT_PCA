## HUNT Principal Components Analysis


The aims of the scripts in this repository are: 
	1. To project PC calculated from HapMap III onto HUNT,
	2. And calculate PC in HUNT (QC has been previously done)

## Raw Files
1. `hapmap_related.txt` contains a list of HapMap IDs to exclude due to relatedness
2. `pca_hapmap.eigenvec.var` contains the weitghts of 10 PC from HapMap. 


## Scripts
1. `extract_mom_samples.R` to extract samples list for mothers, father and child into different files
2. `hunt_geno_range.R` to extract typed genetic variants from HUNT
3. `hapmap.sh` to perform PCA in HapMap samples. Depends on:
	- `sub_unrelated.R` to obtain a list of unrelated HapMap participants
	- `sub_hapmap_bim.R` to modify HapMap bim variants ID


## Steps for HapMap PC projection

1. Extract list of HUNT genotyped variants (chr and pos)
2. Select unrelated samples from HapMap III and run PCA in genetic variants overlapping with HUNT (MAF >0.01)
3. Project HUNT onto HapMap III PCs

## Steps for HUNT PC

1. Split maternal, paternal and offsping samples
2. Select unrelated samples from HUNT and run PCA in genotyped variants
3. Project all HUNT samples onto PCs




