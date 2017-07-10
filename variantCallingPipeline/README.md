<br><br>

# Scripts used for GEO -> Variant Calls

**Contact:** [Caleb Lareau](mailto:caleblareau@g.harvard.edu)3

# GATK Best Practices for Alignment

For processing the data from GEO -> `.fastq` -> high-quality `.bam`, 
we used [GATK Best Practices as outlined here](http://onlinelibrary.wiley.com/doi/10.1002/0471250953.bi1110s43/abstract).
Briefly, attached are our shell scripts for producing the finalized `.bam` files from the uploaded data on GEO. 

**Execution order:**

0. acquire fastq files: [00_getFastq.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/00_getFastq.sh)
1. align/sort: [01_alignBWA.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/01_align_BWAmem.sh)
2. remove duplicates: [02_removeDuplicates.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/02_removeDuplicates.sh)
3. add read groups for base recalibration: [03_addReadGroup.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/03_addReadGroup.sh)
4. identify sites (indels) for realignment: [04_indelRealignIdentificaiton.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/04_indelRealignIdentificaiton.sh)
5. realign identified loci from 4: [05_indelRealign.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/05_indelRealign.sh)
6. print reads (makes final .bam file): [06_printReads.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/06_printReads.sh)

With the finalized `.bam` file

# Cancer Pipeline Variant Calling Scripts

These specific scripts were not necessarily executed "as is" but were often
divided into individual scripts used to parallelize the execution over multiple
nodes on our computing cluster. In addition to 

- Variant calling with [Lofreq](http://csb5.github.io/lofreq/commands/)-- The [lofreqCommads.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/lofreqCommands.sh) file 
contains all commands used to call variants with Lofreq `cat` together. In actuality, each command was run individually for performance. 
- Variant calling with [muTect](http://archive.broadinstitute.org/cancer/cga/mutect_run)-- Built [this execution shell script](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/mutectExec.sh)
from [this R script](https://github.com/aryeelab/crispr_reanalysis/blob/master/variantCallingPipeline/call_mutations/makeMutectExec.R) in order to run [this muTect shell command](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/mutectRunner.sh)
in parallel over each sample pair per chromsome
- Variant calling with [Strelka](https://github.com/Illumina/strelka/blob/master/docs/userGuide/README.md)-- [strelkaCommands.sh](https://github.com/aryeelab/crispr_mutation_reanalysis/blob/master/variantCallingPipeline/call_mutations/strelkaCommands.sh)

# GATK Genotyping Workflow

Some details on how particular portions of our variant call pipeline were performed. 

## Output

Data from our final merged `.vcf` file is quite large. These can be accessed from an AWS instance as the
files exceed a combined **7 gigabytes**. Download with caution-- 

```
wget https://s3.amazonaws.com/crispr-mutation-reanalysis/allSamples.merged.fullData.vcf.gz
wget https://s3.amazonaws.com/crispr-mutation-reanalysis/allSamples.merged.fullData.vcf.gz.tbi
```


### SNP file

Due to some inconsistencies in the way the dbSNP annotations were reported in the supplement
of the original manuscript, we wound up making a custom SNP list that was a union of dbSNP 137 and 138.
This file that was used to classify variants as in dbSNP or not can be accessed here:

```
wget https://s3.amazonaws.com/crispr-mutation-reanalysis/allSNPannotations.bed.gz
```

**Note:** this isn't a `.bed` file _per se_ as it only has two columns, which was
constructed as such to save space. A third column can be added using a simple `awk` command
and adding 1 to the second field (_i.e._: `$2 +1`) and potentially a dummy fourth column
depending on the down-stream analysis tool. 

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

From these `*.subsample.bam` files, we performed the cancer pipeline and the GATK genotyping
pipeline over again. These results were used sparingly to convince ourselves that the 
variation in sequencing depth did not have a profound effect on the inference and analyses
of this study and our results. 

<br><br>