#!/bin/bash

sample=$1

java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar GenomeAnalysisTK.jar -nct 16 -T PrintReads -R /data/aryee/pub/genomes/mm10/mm10.fa -I "fastq/${sample}.bwa.dedup.sorted.rg.realigned.bam" -BQSR "recal_data.${sample}.table" -o "${sample}.final.bam"


