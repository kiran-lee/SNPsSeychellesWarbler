#!/bin/bash

#SBATCH --job-name=choosereferencepanel
#SBATCH --output=choosereferencepanel
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --time=6:00:00
#SBATCH --mail-user=kgllee1@sheffield.ac.uk
#SBATCH --mail-type=all

#Commands to generate high coverage reference panel for assessing imputation accuracy

source ~/.bash_profile

#subset for unrelated individuals to a degree of at least 3rd-degree relationships
#plink2 --bfile mergedimputedchromosomes --king-cutoff 0.005 --make-bed --out unrelatedimputedchromosomes --allow-extra-chr

#tidy king in.id file
#awk 'NR>2 {print $2}'  unrelatedimputedchromosomes.king.cutoff.in.id > unrelatedindividuals

#get coverage for unrelated individuals
file="/fastdata/bop21kgl/RawData/allplates/unrelatedindividuals"
while read line; do
samtools depth -a $line | awk '{sum+=$3} END { print FILENAME,sum/NR}';
done < "${file}"

