#!/bin/bash

#SBATCH --job-name=downsample
#SBATCH --output=downsample.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --time=6:00:00
#SBATCH --mail-user=kgllee1@sheffield.ac.uk
#SBATCH --mail-type=all
#SBATCH --array=1-23

##Downsample high coverage files

source ~/.bash_profile

#old script disused cut -sd'/' -f2 cov_x_sw_renamed > cov_x_sw_renamed2

sample=`sed -n ${SLURM_ARRAY_TASK_ID}p downsamplescalingnew | awk '{print $1}'`
multiplemeanx=`sed -n ${SLURM_ARRAY_TASK_ID}p downsamplescalingnew | awk '{print $3}'`
# multiple1x=`sed -n ${SLURM_ARRAY_TASK_ID}p downsamplescalingnew | awk '{print $3}'`

cp $sample .

# mkdir subsamp

## Subsample to 2.6x
samtools view -@ 20 -bh -s ${multiplemeanx} ${sample} > "${sample}.2.6x.bam"
samtools index "${sample}.2.6x.bam"

## Subsample to 1x                                                             
# samtools view -@ 20 -bh -s ${multiple1x} ${sample} > "${sample}.1x.bam"
# samtools index "${sample}.1x.bam"