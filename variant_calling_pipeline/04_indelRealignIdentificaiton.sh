#!/bin/bash

sample=$1

java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R /data/aryee/pub/genomes/mm10/mm10.fa -nt 16 -I "fastq/${sample}.bwa.dedup.sorted.rg.bam" -o "${sample}_intervals.list"
