#!/bin/bash

#SBATCH --job-name=mergevcf
#SBATCH --output=mergevcf.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=2G
#SBATCH --time=30:00:00
#SBATCH --mail-user=kgllee1@sheffield.ac.uk
#SBATCH --mail-type=all

#SBATCH -A molecolb
#SBATCH -p molecolb

source ~/.bash_profile

bcftools merge -l vcffilestomerge -o allplatesmergedextrasamples.vcf.gz