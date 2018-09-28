#HUNT_PCA





## Scripts
1. `extract_mom_samples.R` to drop boring phenotypes (medications...)
2. `hunt_geno_range.R` to wget all the rest, and filter p<1e-5
3. `prune-ld.R` to clump SNPs based on distance and UKBB association results
4. `process-ukbb-cv.R` to summarize UKBB and ClinVar reference tables
5. `combine-imputed.sh` to extract dosages from your Sanger-imputed VCFs
6. `combine-imputed2.R` to find your GRSs and pathogenic markers
7. `app.R` - the actual UI and server for Shiny viewer

