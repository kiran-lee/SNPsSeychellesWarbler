#!/bin/bash

#SBATCH --job-name=choosereferencepanel
#SBATCH --output=choosereferencepanel.log
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
plink2 --bfile mergedimputedchromosomes --king-cutoff 0.005 --make-bed --out unrelatedimputedchromosomes --allow-extra-chr
plink2 --bfile mergedimputedchromosomes --king-cutoff 0.01 --make-bed --out unrelatedimputedchromosomes --allow-extra-chr


#tidy king in.id file
awk 'NR>2 {print $2}'  unrelatedimputedchromosomes.king.cutoff.in.id > unrelatedindividuals
awk 'NR>2 {print $2}'  unrelatedimputedchromosomes2nddegree.king.cutoff.in.id > unrelatedindividuals2nddegree

#get coverage for unrelated individuals
file="/fastdata/bop21kgl/ReferencePanel/unrelatedindividuals"
while read line; do
samtools depth -a $line | awk '{sum+=$3} END { print FILENAME,sum/NR}';
done < "${file}" > cov.txt

tail -n +16 cov.txt > coverage.txt
sed 's/^..//' coverage.txt > coveragenew.txt

#get sample names
while read line; do
FBASE=$(basename $line);
BASE=${FBASE%all_mapped_rehead.bam};
echo $FBASE;
done < "${file}" > samples.txt

#merge sample names with their coverage
paste samples.txt coveragenew.txt > samplescoverage.txt
sed 's/\t/ /' samplescoverage.txt > samplescoveragenew.txt
sort -k 2 -n samplescoveragenew.txt > samplescoveragesorted.txt

