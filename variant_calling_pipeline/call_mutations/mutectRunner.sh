#!/bin/bash

normal=$1
tumor=$2
name=$3
chr=$4

# Need java 7
/apps/source/java/jdk-7.45/jdk1.7.0_45/bin/java \
-Djava.io.tmpdir=`pwd`/fastq/tmp \
-jar mutect-1.1.7.jar \
--analysis_type MuTect \
-L "mm10_chrBed/${chr}_mm10.bed" \
--reference_sequence /data/aryee/pub/genomes/mm10/mm10.fa \
--dbsnp chrdbSNP.vcf.gz \
--input_file:normal "${normal}.final.bam" \
--input_file:tumor "${tumor}.final.bam" \
--baqGapOpenPenalty 30 \
--out "mutect1_out/${name}_${chr}"

