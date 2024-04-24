#!/bin/bash

#SBATCH --job-name=imputationaccuracy
#SBATCH --output=imputationaccuracy.log
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
#SBATCH --time=6:00:00
#SBATCH --mail-user=kgllee1@sheffield.ac.uk
#SBATCH --mail-type=all


source ~/.bash_profile


#Rename downsampled imputed vcf file so as not to confuse it with the non-downsampled imputed vcf file
mv "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574.vcf.gz” "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574downsampled.vcf.gz” 

#Prepare test dataset
#Get list of SNPs from only chromosome 1
bcftools query -f '%CHROM\t%POS\n' "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574downsampled.vcf.gz" > chromosome1quarter

#Subset only best 23 coverage (>8x) individuals from imputed called SNPs
bcftools view "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574downsampled.vcf.gz" -S downsampled2.6 -o "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574downsampledsubsetted.vcf.gz" -O z





#Prepare truth dataset
#Subset only best 23 coverage (>8x) individuals from non-imputed called SNPs
bcftools view allplatesmergedextrasamplescorrectformatted.vcf.gz -S bestcoverage -o allplatesmergedextrasamplescorrectformattedbestcoverage.vcf.gz -O z

#Subset only chromosome 1
bcftools view allplatesmergedextrasamplescorrectformattedbestcoveragesnps.vcf.gz -r \
"ENA|OU383773|OU383773.1_RagTag" \
-o allplatesmergedextrasamplescorrectformattedbestcoveragesnpschr1.vcf.gz -O z

#Subset non-missing SNPs, present in all individuals
bcftools view allplatesmergedextrasamplescorrectformattedbestcoveragesnpschr1.vcf.gz -g ^miss > allplatesmergedextrasamplescorrectformattedbestcoveragesnpschr1filteredmissing.vcf.gz -O z

#Subset for the quarter of chromosome 1 that got imputed
bcftools view -T chromosome1quarter allplatesmergedextrasamplescorrectformattedbestcoveragechr1filteredmissing.vcf.gz > allplatesmergedextrasamplescorrectformattedbestcoveragechr1filteredmissingrefiltered.vcf.gz -O z

#Make a sample comparison file for bcftools gtcheck
bcftools query -l allplatesmergedextrasamplescorrectformattedbestcoveragechr1filteredmissingrefiltered.vcf.gz
bcftools query -l "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574downsampled.vcf.gz" 
Put these outputs into a tab separated list called gtchecksamples (see bcftools documentation)

#Check discordance using bcftools gtcheck
bcftools gtcheck -P gtchecksamples -g allplatesmergedextrasamplescorrectformattedbestcoveragechr1filteredmissingrefiltered.vcf.gz "stitch.ENA|OU383773|OU383773.1_RagTag.75.29683574downsampledsubsetted.vcf.gz" -e 0 > discordance.txt

cut -f4,6 discordancechr1quarter.txt > ndiscordantchr1quarterrowsdeleted.txt
cut -f4,6 discordancechr10.txt > ndiscordantchr10rowsdeleted.txt

sed -e '1,13d' ndiscordantchr1quarterrowsdeleted.txt > ndiscordantchr1quarter.txt
sed -e '1,13d' ndiscordantchr10rowsdeleted.txt > ndiscordantchr10.txt
