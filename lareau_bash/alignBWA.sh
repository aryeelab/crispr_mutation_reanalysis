#==> a96.sh <==
bwa mem -t 16 /data/aryee/pub/genomes/mm10/mm10.fa SRR5450996_1.fastq.gz SRR5450996_2.fastq.gz 2> SRR5450996_b.log | samtools view -bS - > SRR5450996.raw.bam
samtools sort -@ 16 SRR5450996.raw.bam -o SRR5450996.sorted.bam
samtools index SRR5450996.sorted.bam

#==> a97.sh <==
bwa mem -t 16 /data/aryee/pub/genomes/mm10/mm10.fa SRR5450997_1.fastq.gz SRR5450997_2.fastq.gz 2> SRR5450997_b.log | samtools view -bS - > SRR5450997.raw.bam
samtools sort -@ 16 SRR5450997.raw.bam -o SRR5450997.sorted.bam
samtools index SRR5450997.sorted.bam

#==> a98.sh <==
bwa mem -t 16 /data/aryee/pub/genomes/mm10/mm10.fa SRR5450998_1.fastq.gz SRR5450998_2.fastq.gz 2> SRR5450998_b.log | samtools view -bS - > SRR5450998.raw.bam
samtools sort -@ 16 SRR5450998.raw.bam -o SRR5450998.sorted.bam
samtools index SRR5450998.sorted.bam

