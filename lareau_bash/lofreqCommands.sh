
#n98_t96
#!/bin/bash
./lofreq somatic -n fastq/SRR5450998.bwa.dedup.sorted.bam -t fastq/SRR5450996.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n98_t96 -d SC_MOUSE_GENOMES.genotype.vcf.gz

#n97_t96
#!/bin/bash
./lofreq somatic -n fastq/SRR5450997.bwa.dedup.sorted.bam -t fastq/SRR5450996.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n97_t96 -d SC_MOUSE_GENOMES.genotype.vcf.gz

#n98_t97
#!/bin/bash
./lofreq somatic -n fastq/SRR5450998.bwa.dedup.sorted.bam -t fastq/SRR5450997.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n98_t97 -d SC_MOUSE_GENOMES.genotype.vcf.gz

#n96_t97
#!/bin/bash
./lofreq somatic -n fastq/SRR5450996.bwa.dedup.sorted.bam -t fastq/SRR5450997.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n96_t97 -d SC_MOUSE_GENOMES.genotype.vcf.gz

#n97_t98
#!/bin/bash
./lofreq somatic -n fastq/SRR5450997.bwa.dedup.sorted.bam -t fastq/SRR5450998.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n97_t98 -d SC_MOUSE_GENOMES.genotype.vcf.gz

#n96_t98
#!/bin/bash
./lofreq somatic -n fastq/SRR5450996.bwa.dedup.sorted.bam -t fastq/SRR5450998.bwa.dedup.sorted.bam -f /data/aryee/pub/genomes/mm10/mm10.fa --threads 16 -o n96_t98 -d SC_MOUSE_GENOMES.genotype.vcf.gz

