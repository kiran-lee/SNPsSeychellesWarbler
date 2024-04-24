Scripts and commands to obtain SNPs from short read 150bp Illumina whole-genome sequencing of ~1900 Seychelles warblers. This includes 1) SNP calling pipeline, 2) Imputation by STITCH and 3) Assessing imputation accuracy.

Scripts were run on the Sheffield University HPC. These HPCs use the SLURM queueing system, therefore core/RAM/runtimes in .sh scripts are specified in SLURM format. 

1_SNP_calling_pipeline

1. https://docs.google.com/spreadsheets/d/1I1jxm78n4VoYw86xWX-zbb-yERupBtOrV2SymfiHV04/edit#gid=0 : download links to all sequenced plates 

2. main_submission_multi.sh : an array job that requires sequenced plate number ID as input to quality check (fastqc.sh), trim reads (trimmomatic.sh), align read to the reference genome (bwa.sh), filter mapped reads (clean_bam.sh) and call SNPs (snps.sh)

mergevcf.sh

2_Imputation_STITCH

(To be added)

3_Imputation_accuracy

1. Get coverage per sample (To be added)

2. CoverageDownsample.R : choose best coverage samples and get scaling factor to downsample best coverage samples

3. downsamplecorrectcoverage.sh downsample best coverage samples by scaling factor

4. *perform imputation* (To be added)

5. imputation_accuracy.sh : List of commands to oompare high coverage non-imputed genotypes to their respective downsampled imputed genotypes

