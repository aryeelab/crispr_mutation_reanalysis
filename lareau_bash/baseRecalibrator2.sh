#==> BaseRecalibrator2.96.sh <==
#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp  -jar GenomeAnalysisTK.jar -nct 16 -T BaseRecalibrator -R /data/aryee/pub/genomes/mm10/mm10.fa -I fastq/SRR5450996.bwa.dedup.sorted.rg.bam  -knownSites SC_MOUSE_GENOMES.genotype.vcf.gz -BQSR recal_data.96.table -o post_recal_data.96.table

#==> BaseRecalibrator2.97.sh <==
#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp  -jar GenomeAnalysisTK.jar -nct 16 -T BaseRecalibrator -R /data/aryee/pub/genomes/mm10/mm10.fa -I fastq/SRR5450997.bwa.dedup.sorted.rg.bam  -knownSites SC_MOUSE_GENOMES.genotype.vcf.gz -BQSR recal_data.97.table -o post_recal_data.97.table

#==> BaseRecalibrator2.98.sh <==
#!/bin/bash
java -Djava.io.tmpdir=`pwd`/fastq/tmp  -jar GenomeAnalysisTK.jar -nct 16 -T BaseRecalibrator -R /data/aryee/pub/genomes/mm10/mm10.fa -I fastq/SRR5450998.bwa.dedup.sorted.rg.bam  -knownSites SC_MOUSE_GENOMES.genotype.vcf.gz -BQSR recal_data.98.table -o post_recal_data.98.table