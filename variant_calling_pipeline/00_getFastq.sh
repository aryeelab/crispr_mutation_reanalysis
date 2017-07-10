#!/bin/bash

ASPERA=/apps/lab/aryee/aspera-connect-3.5.6/

mkdir fastq
cd fastq

SRR_IDS="SRR5450996 SRR5450997 SRR5450998"

for SRR_ID in $SRR_IDS
do
$ASPERA/bin/ascp -i $ASPERA/etc/asperaweb_id_dsa.openssh -T -k 2 -l 400M anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/${SRR_ID:0:6}/${SRR_ID}/${SRR_ID}.sra .
bsub -q medium fastq-dump --split-files --gzip ${SRR_ID}.sra
done
