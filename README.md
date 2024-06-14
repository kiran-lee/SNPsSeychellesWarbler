# Seychelles warbler SNPs

Scripts and commands to obtain SNPs from short read 150bp Illumina whole-genome sequencing of ~1900 Seychelles warblers. This includes 1) SNP calling pipeline, 2) Imputation by STITCH and 3) Assessing imputation accuracy.

Scripts were run on Sheffield University HPCs. These HPCs uses the SLURM queueing system, therefore core/RAM/runtimes in .sh scripts are specified in SLURM format. 

## 1_SNP_calling_pipeline
`cd 1_SNPs_calling_pipeline`

1. https://docs.google.com/spreadsheets/d/1I1jxm78n4VoYw86xWX-zbb-yERupBtOrV2SymfiHV04/edit#gid=0 : Download links to all sequenced plates.

2. main_submission_multi.sh : An array job that requires sequenced plate number ID as input to quality check (fastqc.sh), trim reads (trimmomatic.sh), align read to the reference genome (bwa.sh), filter mapped reads (clean_bam.sh) , call SNPs (snps.sh) and add read group data to .bam files (picardreadgroup.sh).

3. mergefiltervcf.sh : Merge samples from all plates, subset for SNPs for biallelic only and MAF > 0.05.


## 2_Imputation_STITCH

###Prepare input files
1. plinktobedbiallelic.sh: Convert .vcf file to .bed file.
2. getpos.sh: Get snp position list and split by chromosome for STITCH to use.
3. picardreadgroup.sh: Add read group data to alligned .bam files and then index output. You must cd into the relevant directory containing aligned .bam files first.

###Perform imputation
4. multichromosomedownsampledstitchimputationscript.sh: Array job submission to perform imputation, using STITCH for all 31 chromosomes (each of the 31 stitch*.r scripts),  for all 1922 samples (bamlistrg.txt) and their respective names (bamlist.txt).

## 3_Imputation_accuracy
`cd 3_Imputation_accuracy`

###Get coverage of samples
1. obtainsamplecoverage.sh: Get coverage per sample. You must cd into the relevant directory containing aligned .bam files first.

2. decimalscoverage.sh: Concatenate coverage of all samples, convert coverage into decimals and sort samples on coverage (coverageallsorted.txt).

3. coveragedownsampling.R : Choose best coverage samples and output a file with  for each sample, the scaling factor to multiply to get to 2.6x coverage (downsamplescalingnew).

4. downsamplecorrectcoverage.sh: Downsample best coverage samples to 2.6x by scaling factor  (downsamplescalingnew).

5. makestitchrscriptfordownsamples.sh: Make .r script  to impute downsampled individuals for each of the 31 chromosomes, borrowing script using in 2_Imputation_STITCH.

6. getsampleslist.sh: Create file listing downsampled samples, including filepaths (bamlistrgdownsampled.txt) and their names (bamlistdownsampled) to impute, in order to assess accuracy. N.B. Before this, you must first use picard to add read group data to the .bam files of downsampled samples and then need to index these, see picardreadgroup.sh in 2_Imputation_STITCH for how to do this.

7. multichromosomedownsampledstitchimputationscript.sh: array job submission to perform imputation, using STITCH for all 31 chromosomes (each of the 31 stitch*downsampled.r scripts),  for all 1922 samples (bamlistrgdownsampled.txt) and their respective names (bamlistdownsampled.txt), with 23 of the highest coverage samples being downsampled to 2.6x coverage.

8. imputationaccuracy.sh : List of commands to compare in 23 high coverage samples (downsampled2.6) non-imputed genotypes to their respective downsampled, then imputed genotypes and outputting concordance per chromosome in one file (meanconcordance).

9.  choosereferencepanel.sh: Commands in case we want to obtain a reference panel of high coverage, unrelated sequenced samples. Not used for now.

