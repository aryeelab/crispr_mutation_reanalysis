
#n98_t96
echo "./lofreq somatic -n fastq/SRR5450998.bwa.dedup.sorted.bam -t fastq/SRR5450996.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n98_t96 -d chrMouseSNPs.vcf.gz -d chrdbSNP.vcf.gz" > lofreq.n98_t96.sh

#n97_t96
echo "./lofreq somatic -n fastq/SRR5450997.bwa.dedup.sorted.bam -t fastq/SRR5450996.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n97_t96 -d chrMouseSNPs.vcf.gz -d chrdbSNP.vcf.gz" > lofreq.n97_t96.sh

#n98_t97
echo "./lofreq somatic -n fastq/SRR5450998.bwa.dedup.sorted.bam -t fastq/SRR5450997.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n98_t97 -d chrMouseSNPs.vcf.gz -d chrdbSNP.vcf.gz" > lofreq.n98_t97.sh

#n96_t97
echo "./lofreq somatic -n fastq/SRR5450996.bwa.dedup.sorted.bam -t fastq/SRR5450997.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n96_t97 -d chrMouseSNPs.vcf.gz -d chrdbSNP.vcf.gz" > lofreq.n96_t97.sh

#n97_t98
echo "./lofreq somatic -n fastq/SRR5450997.bwa.dedup.sorted.bam -t fastq/SRR5450998.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n97_t98 -d chrMouseSNPs.vcf.gz -d chrdbSNP.vcf.gz" > lofreq.n97_t98.sh

#n96_t98
echo "./lofreq somatic -n fastq/SRR5450996.bwa.dedup.sorted.bam -t fastq/SRR5450998.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n96_t98 -d chrMouseSNPs.vcf.gz -d chrdbSNP.vcf.gz" > lofreq.n96_t98.sh

