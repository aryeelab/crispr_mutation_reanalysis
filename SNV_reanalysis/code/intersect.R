library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)

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
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "contig", start.field = "position", end.field = "position")
  gr
}

readLofreq <- function(sample){
  file <- paste0("../new_variant_calls_raw/lofreq_out/", sample, "somatic_final_minus-dbsnp.snvs.vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "X.CHROM", start.field = "POS", end.field = "POS")
  gr
}

intersectAll <- function(sample){
  s <- readStrelka(sample)
  m <- readMutect(sample)
  l <- readLofreq(sample)
  ov1 <- findOverlaps(s,m)
  ovall <- findOverlaps(s[data.frame(ov1)$queryHits], l)
  variantsCalledg <- l[data.frame(ovall)$subjectHits]
  variantsCalledg 
}

F03_FVB <- intersectAll("n98_t97")
F05_FVB <- intersectAll("n98_t96")

length(intersectAll("n97_t98"))

# Read in the published variant data
pubRead <- function(sample2){
  ldf <- read.table(paste0("../original_variant_calls/",sample2,".snv.lofreq.v2.1.3a.filtered.vcf"))
  lg <- makeGRangesFromDataFrame(ldf, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  mdf <- read.table(paste0("../original_variant_calls/", sample2, ".snv.mutect.v1.1.7.filtered.vcf"))
  mg <- makeGRangesFromDataFrame(mdf, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  sdf <- read.table(paste0("../original_variant_calls/", sample2, ".snv.strelka.v1.0.14.filtered.vcf"))
  sg <- makeGRangesFromDataFrame(sdf, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  ov1 <- findOverlaps(sg,mg)
  ovall <- findOverlaps(sg[data.frame(ov1)$queryHits], lg)
  variantsCalledg <- lg[data.frame(ovall)$subjectHits]
  addchr(variantsCalledg)
}

F03_FVB_pub <- pubRead("F03--FVB")
F05_FVB_pub <- pubRead("F05--FVB")

# Quantify how many variants I was able to get
sum(countOverlaps(F03_FVB, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB, F05_FVB_pub))/length(F05_FVB_pub)

sum(countOverlaps(F03_FVB_pub, F05_FVB_pub))

