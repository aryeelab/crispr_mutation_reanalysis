#!/bin/bash

normal=$1
tumor=$2
name=$3
chr=$4

java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar GenomeAnalysisTK.jar -T MuTect2 -nct 4 -R /data/aryee/pub/genomes/mm10/mm10.fa -I:tumor "fastq/${tumor}.bwa.dedup.sorted.rg.bam" -I:normal "fastq/${normal}.bwa.dedup.sorted.rg.bam" --dbsnp chrMouseSNPs.vcf.gz -L "mm10_chrBed/${chr}_mm10.bed" -o "mutect2_out/${name}/${name}_${chr}"
