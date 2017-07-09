<br><br>

# Scripts used for cancer pipeline calling

**Contact:** [Caleb Lareau](mailto:caleblareau@g.harvard.edu)

# GATK Best Practices for Alignment

**Execution order:**

0. acquire fastq files: [00_getFastq.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/00_getFastq.sh)
1. align/sort: [01_alignBWA.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/01_align_BWAmem.sh)
2. remove duplicates: [02_removeDuplicates.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/02_removeDuplicates.sh)
3. add read groups for base recalibration: [03_addReadGroup.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/03_addReadGroup.sh)
4. identify sites (indels) for realignment: [04_indelRealignIdentificaiton.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/04_indelRealignIdentificaiton.sh)
5. realign identified loci from 4: [05_indelRealign.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/05_indelRealign.sh)
6. print reads (makes final .bam file): [06_printReads.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/06_printReads.sh)

# Cancer Pipeline Variant Calling Scripts

These specific scripts were not necessarily executed "as is" but were often
divided into individual scripts used to parallelize the execution over multiple
nodes on Erisone. 

- Variant calling with [Lofreq](http://csb5.github.io/lofreq/commands/)-- The [lofreqCommads.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/strelkaCommands.sh) file 
contains all commands used to call variants with Lofreq `cat` together. In actuality, each command was run individually for performance. 
- Variant calling with [muTect](http://archive.broadinstitute.org/cancer/cga/mutect_run)-- Built [this execution shell script](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/mutectExec.sh)
from [this R script](https://github.com/aryeelab/crispr_reanalysis/blob/master/variantCallingPipeline/call_mutations/makeMutectExec.R) in order to run [this muTect shell command](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/mutectRunner.sh)
in parallel over each sample pair per chromsome
- Variant calling with [Strelka](https://github.com/Illumina/strelka/blob/master/docs/userGuide/README.md)-- [strelkaCommands.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/strelkaCommands.sh)

# Other noteworthy bits

Some details on how particular portions of our variant call pipeline were performed. 

### Versions of software / binaries

The executables used in our analysis are coordinated here [binaries](binaries/).

### SNP files

The location of these files was specified in the supplement of the manuscript. The processing of these
files entailed the following. First, these were downloaded--

```
wget ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/mouse_10090/VCF/genotype/SC_MOUSE_GENOMES.genotype.vcf.gz
wget ftp://ftp-mouse.sanger.ac.uk/REL-1303-SNPs_Indels-GRCm38/mgp.v3.snps.rsIDdbSNPv137.vcf.gz
```

Then, some mild reprocessing was required by appending `chr` to the chromosome names. 
This was because the reference genome I aligned to was mm10 which includes `chr` in the chromosome
names but are otherwise identical. , compress, and then reindex--

```
zcat mgp.v3.snps.rsIDdbSNPv137.vcf.gz | awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' | bgzip > chrdbSNP.vcf.gz
zcat SC_MOUSE_GENOMES.genotype.vcf.gz | awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' | bgzip > chrMouseSNPs.vcf.gz
```

Rather than doing `vcftools` filtering, we opted to create a simple positional file of the SNPs for 
later filtering in say in `R` environment. 

```
zcat chrMouseSNPs.vcf.gz chrdbSNP.vcf.gz | cut -f 1,2 | sort -gk 1,2  | uniq  | gzip > allMouseSNPloci.bed.gz
```

To get a true bed file--

```
zcat allMouseSNPloci.bed.gz | awk '{print $0"\t"$2+1}' > snpLoci.bed
```

### Downsampling CRISPR treated samples

To account for coverage variation, we downsample the two treated samples to 60\% of the 
total depth (30X / 50X coverage as reported in the paper. Also, proportion of mapped reads
for control / treated were both between 59.5 and 60.0 \%) using `samtools`--

```
samtools view -s 3.6 -b SRR5450997.final.bam -o SRR5450997.subsample.bam
samtools view -s 3.6 -b SRR5450996.final.bam -o SRR5450996.subsample.bam
```
**Note:** here the `3` is the seed for subsampling.

For convenience of the scripts and file naming conventions, the control mouse `.bam`
file was copied--

```
cp SRR5450996.final.bam SRR5450996.subsample.bam
```

<br><br>