#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar picard.jar AddOrReplaceReadGroups  I=fastq/SRR5450996.bwa.dedup.sorted.bam O=fastq/SRR5450996.bwa.dedup.sorted.rg.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=1

#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar picard.jar AddOrReplaceReadGroups  I=fastq/SRR5450997.bwa.dedup.sorted.bam O=fastq/SRR5450997.bwa.dedup.sorted.rg.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=1

#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar picard.jar AddOrReplaceReadGroups  I=fastq/SRR5450998.bwa.dedup.sorted.bam O=fastq/SRR5450998.bwa.dedup.sorted.rg.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=1