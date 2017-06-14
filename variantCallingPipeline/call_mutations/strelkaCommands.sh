module load strelka/default

/apps/source/strelka/1.0.11/strelka_workflow-1.0.11/bin/configureStrelkaWorkflow.pl --normal=SRR5450998.final.bam --tumor=SRR5450996.final.bam --ref=/data/aryee/pub/genomes/mm10/mm10.fa --config=config.ini --output-dir=./strelka_n98_t96
/apps/source/strelka/1.0.11/strelka_workflow-1.0.11/bin/configureStrelkaWorkflow.pl --normal=SRR5450998.final.bam --tumor=SRR5450997.final.bam --ref=/data/aryee/pub/genomes/mm10/mm10.fa --config=config.ini --output-dir=./strelka_n98_t97

/apps/source/strelka/1.0.11/strelka_workflow-1.0.11/bin/configureStrelkaWorkflow.pl --normal=SRR5450997.final.bam --tumor=SRR5450996.final.bam --ref=/data/aryee/pub/genomes/mm10/mm10.fa --config=config.ini --output-dir=./strelka_n97_t96
/apps/source/strelka/1.0.11/strelka_workflow-1.0.11/bin/configureStrelkaWorkflow.pl --normal=SRR5450997.final.bam --tumor=SRR5450998.final.bam --ref=/data/aryee/pub/genomes/mm10/mm10.fa --config=config.ini --output-dir=./strelka_n97_t98

/apps/source/strelka/1.0.11/strelka_workflow-1.0.11/bin/configureStrelkaWorkflow.pl --normal=SRR5450996.final.bam --tumor=SRR5450997.final.bam --ref=/data/aryee/pub/genomes/mm10/mm10.fa --config=config.ini --output-dir=./strelka_n96_t97
/apps/source/strelka/1.0.11/strelka_workflow-1.0.11/bin/configureStrelkaWorkflow.pl --normal=SRR5450996.final.bam --tumor=SRR5450998.final.bam --ref=/data/aryee/pub/genomes/mm10/mm10.fa --config=config.ini --output-dir=./strelka_n96_t98

