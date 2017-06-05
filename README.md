# Reanalysis Unexpected mutations after CRISPR–Cas9 editing _in vivo_
Commands and scripts for reanalysis of [this manuscript](https://www.nature.com/nmeth/journal/v14/n6/full/nmeth.4293.html).


# Mutation Calling Software Links

When browsing the internet, I found [this guide](https://github.com/tinyheero/variant_calling_in_cancer_genomes_seminar), which seemed pretty solid. 

- [Lofreq](http://csb5.github.io/lofreq/commands/)
- [Mutect](http://archive.broadinstitute.org/cancer/cga/mutect_run)
- [Strelka](https://github.com/Illumina/strelka/blob/master/docs/userGuide/README.md)

## GATK Random Links
- [Commands for recallibrating .bam files](http://gatkforums.broadinstitute.org/gatk/discussion/2801/howto-recalibrate-base-quality-scores-run-bqsr)
- [Picard add readgroups](https://broadinstitute.github.io/picard/command-line-overview.html#AddOrReplaceReadGroups)

## SNP file
This was specified in the supplement of the main manuscript though the exact link was not specified. Here's where I got the file from:
```
wget ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/mouse_10090/VCF/genotype/SC_MOUSE_GENOMES.genotype.vcf.gz
```
