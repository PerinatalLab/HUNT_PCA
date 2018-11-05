## HUNT Principal Components Analysis


The aims of the scripts in this repository are: 
	1. To project PC calculated from HapMap III onto HUNT,
	2. And calculate PC in HUNT (QC has been previously done)

## Raw Files
1. `hapmap_related.txt` contains a list of HapMap IDs to exclude due to relatedness
2. `pca_hapmap.eigenvec.var` contains the weitghts of 10 PC from HapMap. 


## Scripts
1. `extract_mom_samples.R` to extract samples list for mothers, fathers and children into different files
2. `hunt_geno_range.R` to extract typed genetic variants from HUNT
3. `hapmap.sh` to perform PCA in HapMap samples. Depends on:
	- `sub_unrelated.R` to obtain a list of unrelated samples
	- `sub_hapmap_bim.R` to modify HapMap bim variant ID
4. `hapmap_pca_projection.sh` to project HUNT samples onto HapMap III PCs
5. `pca_hunt.sh` to calculate PC in unrelated HUNT samples (mothers, fathers and children independenlty), and project all samples into the PC weights. Depends on:
	- `sub_unrelated.R` to obtain a list of unrelated samples



## Steps for HapMap PCA

1. Extract list of HUNT genotyped variants (chr and pos)
2. Select unrelated samples from HapMap III and HUNT
3. Merge HapMAP III and HUNT datasets
4. Run PCA (MAF >0.01).

## Steps for HUNT PC

1. Split maternal, paternal and offsping samples
2. Select unrelated samples from HUNT and run PCA in genotyped variants
3. Project all HUNT samples onto PCs




