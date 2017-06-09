#!/bin/bash

normal=$1
tumor=$2
name=$3

java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar GenomeAnalysisTK.jar -T MuTect2 -R /data/aryee/pub/genomes/mm10/mm10.fa -I:tumor "fastq/${tumor}.bwa.dedup.sorted.rg.bam" -I:normal "fastq/${normal}.bwa.dedup.sorted.rg.bam" --dbsnp chrMouseSNPs.vcf.gz -o "mutect2_out/${name}/${name}"
