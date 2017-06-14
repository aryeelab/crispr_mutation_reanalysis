library(tidyverse)
library(GenomicRanges)
library(data.table)

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

# Define import functions that return GRanges of variant loci
# For each variant call method

readStrelka <- function(sample){
  file <- paste0("../new_variant_calls_raw/strelka_out/strelka_", sample, "/results/passed.somatic.snvs.vcf")
  df <- read.table(file, sep = "\t")
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  gr
}
  
readMutect <- function(sample, filtDBSNP = TRUE){
  file <- paste0("../new_variant_calls_raw/mutect_out/mutect_", sample, "/", sample, "mutect.res.tsv")
  df <- read.table(file, sep = "\t", header = TRUE)
  if(filtDBSNP) df <- df[df$dbsnp_site == "NOVEL", ]
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  gr
}

readLofreq <- function(sample){
  file <- paste0("../new_variant_calls_raw/lofreq_out/", sample, "somatic_final_minus-dbsnp.snvs.vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "X.CHROM", start.field = "POS", end.field = "POS")
  gr
}

sample <- "n98_t96"



