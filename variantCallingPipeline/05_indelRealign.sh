#!/bin/bash

sample=$1

java -Djava.io.tmpdir=`pwd`/fastq/tmp  -jar GenomeAnalysisTK.jar -T IndelRealigner -R /data/aryee/pub/genomes/mm10/mm10.fa -I "fastq/${sample}.bwa.dedup.sorted.rg.bam" -targetIntervals "${sample}_intervals.list" -o "fastq/${sample}.bwa.dedup.sorted.rg.realigned.bam"


