<br><br>

# Reanalysis Unexpected mutations after CRISPR–Cas9 editing _in vivo_

Analysis by members of the [Aryee](https://aryee.mgh.harvard.edu/), [Joung](http://www.jounglab.org/), and [Pinello](http://pinellolab.org/) Labs at MGH/Harvard.
This repository contains the scripts, commands, and most data required for the reanalysis of
[this manuscript](https://www.nature.com/nmeth/journal/v14/n6/full/nmeth.4293.html).

## Specific Analyses

Below is a synopsis of what we did and how one can navigate this web resource to access the files and data. 

### Variant Recalling

The pipeline for recalling variants from the `.fastq` files is found [here](variantCallingPipeline). 
Our reanalysis followed [this protocol](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4243306/) for
best practices in aligning and prepping whole-genome sequencing samples. 

## File naming conventions

Throughout the repository, most samples in the reanalysis are ID'd
by the last two digits of the `SRR` number. This table is the most useful key--

```
FVB - Control - 98
F03 - Treated - 97
F05 - Treated - 96
```

When doing variant calling, the normal tissue is specified with an `n` and the tumor tissue with a `t`. 
For example, the output file of 

## Mutation Calling Software Links

To perform SNV identification, the following software (as outlined in the original manuscript) were used:

- [Lofreq](http://csb5.github.io/lofreq/commands/)
- [Mutect](http://archive.broadinstitute.org/cancer/cga/mutect_run)
- [Strelka](https://github.com/Illumina/strelka/blob/master/docs/userGuide/README.md)

Binary executables of the versions that we used in the reanalysis are [available here](variantCallingPipeline/binaries)

## Important

- Install [git large file storage](https://git-lfs.github.com/) before cloning repository
to get some of the larger files in the repository.
- Accessing specific scripts and data may be easier using the navigation tools on the 
main [GitHub Repository here](https://github.com/aryeelab/crispr_reanalysis).

<br><br>
