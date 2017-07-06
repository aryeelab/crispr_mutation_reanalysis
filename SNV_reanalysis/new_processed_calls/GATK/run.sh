#as input, take the merged GATK vcf
#as output, GATK.out
perl filterGATK.pl allSamples.merged.fullData.vcf.gz GATK.out

#annotate SNPs with dbSNP and the cancer pipeline calls
perl annotateGATK.pl


