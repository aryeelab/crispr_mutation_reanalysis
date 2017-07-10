#==> rmdup96.sh <==
#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar picard.jar MarkDuplicates INPUT=fastq/SRR5450996.sorted.bam OUTPUT=fastq/SRR5450996.bwa.dedup.sorted.bam METRICS_FILE=SRR5450996.metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT


#==> rmdup97.sh <==
#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar picard.jar MarkDuplicates INPUT=fastq/SRR5450997.sorted.bam OUTPUT=fastq/SRR5450997.bwa.dedup.sorted.bam METRICS_FILE=SRR5450997.metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT


#==> rmdup98.sh <==
#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp -jar picard.jar MarkDuplicates INPUT=fastq/SRR5450998.sorted.bam OUTPUT=fastq/SRR5450998.bwa.dedup.sorted.bam METRICS_FILE=SRR5450998.metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT
