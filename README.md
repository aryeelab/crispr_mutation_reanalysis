# Reanalysis Unexpected mutations after CRISPR–Cas9 editing _in vivo_
Commands and scripts for reanalysis of [this manuscript](https://www.nature.com/nmeth/journal/v14/n6/full/nmeth.4293.html).

# File naming conventions

Most samples in the reanalysis are ID'd by the last two digits of the `SRR` number. This table is the most useful key--

```
FVB - Control - 98
F03 - Treated - 97
F05 - Treated - 96
```

When doing variant calling, I specify the normal tissue with `n` and the tumor tissue with `t`. 
For example, the output file of 

# Mutation Calling Software Links

When browsing the internet, I found [this guide](https://github.com/tinyheero/variant_calling_in_cancer_genomes_seminar), which seems useful. 

- [Lofreq](http://csb5.github.io/lofreq/commands/)
- [Mutect](http://archive.broadinstitute.org/cancer/cga/mutect_run)
- [Strelka](https://github.com/Illumina/strelka/blob/master/docs/userGuide/README.md)

## GATK Random Links
- [Commands for recallibrating .bam files](http://gatkforums.broadinstitute.org/gatk/discussion/2801/howto-recalibrate-base-quality-scores-run-bqsr)
- [Picard add readgroups](https://broadinstitute.github.io/picard/command-line-overview.html#AddOrReplaceReadGroups)

## SNP files
These were actually specified in the supplement of the main manuscript.

Here's where I got one file from:

```
wget ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/mouse_10090/VCF/genotype/SC_MOUSE_GENOMES.genotype.vcf.gz
```

Another one:

```
wget ftp://ftp-mouse.sanger.ac.uk/REL-1303-SNPs_Indels-GRCm38/mgp.v3.snps.rsIDdbSNPv137.vcf.gz
```

Then we had to reprocess by appending `chr` to the chromosome names, compress, and then reindex--

```
zcat mgp.v3.snps.rsIDdbSNPv137.vcf.gz | awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' | bgzip > chrdbSNP.vcf.gz
zcat SC_MOUSE_GENOMES.genotype.vcf.gz | awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' | bgzip > chrMouseSNPs.vcf.gz
```

Rather than doing `vcftools` filtering, I created a simple positional index of where common variants occurred and then
did filtering in `R` using this input file:

```
zcat chrMouseSNPs.vcf.gz chrdbSNP.vcf.gz | cut -f 1,2 | sort -gk 1,2  | uniq > allMouseSNPloci.bed
```

# Downsampling CRISPR treated samples

To account for coverage variation, we downsample the two treated samples to 60\% of the 
total depth (30X / 50X coverage as reported in the paper. Also, proportion of mapped reads
for control / treated were both between 59.5 and 60.0 \%) using `samtools`--

```
samtools view -s 3.6 -b SRR5450997.final.bam -o SRR5450997.subsample.bam
samtools view -s 3.6 -b SRR5450998.final.bam -o SRR5450998.subsample.bam
```
**Note:** here the `3` is the seed for subsampling. Then, we have to index these guys. 


# Important

- Install [git large file storage](https://git-lfs.github.com/) before cloning repository
to get some of the larger `.bed` files.


