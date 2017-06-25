library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)


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

#######################################
# Now look at the downsampled analysis
#######################################

readStrelkaDS <- function(sample){
  file <- paste0("../downsampled_variant_calls/strelka_out/strelka_ds_", sample, "/results/passed.somatic.snvs.vcf")
  df <- read.table(file, sep = "\t")
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  gr
}
  
readMutectDS <- function(sample, filtDBSNP = TRUE){
  file <- paste0("../downsampled_variant_calls/mutect_out/", sample, ".downsampled.mutect.res.tsv")
  df <- read.table(file, sep = "\t", header = TRUE)
  if(filtDBSNP) df <- df[df$dbsnp_site == "NOVEL", ]
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "contig", start.field = "position", end.field = "position")
  gr
}

readLofreqDS <- function(sample){
  file <- paste0("../downsampled_variant_calls/lofreq_out/", sample, "somatic_final_minus-dbsnp.snvs.vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "X.CHROM", start.field = "POS", end.field = "POS")
  gr
}

intersectAllDS <- function(sample){
  s <- readStrelkaDS(sample)
  m <- readMutectDS(sample)
  l <- readLofreqDS(sample)
  ov1 <- findOverlaps(s,m)
  ovall <- findOverlaps(s[data.frame(ov1)$queryHits], l)
  variantsCalledg <- l[data.frame(ovall)$subjectHits]
  variantsCalledg 
}


# Read in the published variant data

readLofreqPub <- function(sample2){
  ldf <- read.table(paste0("../original_variant_calls/",sample2,".snv.lofreq.v2.1.3a.filtered.vcf"))
  lg <- makeGRangesFromDataFrame(ldf, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  lg
}

readMutectPub <- function(sample2){
  mdf <- read.table(paste0("../original_variant_calls/", sample2, ".snv.mutect.v1.1.7.filtered.vcf"))
  mg <- makeGRangesFromDataFrame(mdf, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  mg
}

readStrelkaPub <- function(sample2){
  sdf <- read.table(paste0("../original_variant_calls/", sample2, ".snv.strelka.v1.0.14.filtered.vcf"))
  sg <- makeGRangesFromDataFrame(sdf, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  sg
}

pubIntersectAll <- function(sample2){
  lg <- readLofreqPub(sample2)
  mg <- readMutectPub(sample2)
  sg <- readStrelkaPub(sample2)
  ov1 <- findOverlaps(sg,mg)
  ovall <- findOverlaps(sg[data.frame(ov1)$queryHits], lg)
  variantsCalledg <- lg[data.frame(ovall)$subjectHits]
  addchr(variantsCalledg)
}

in2 <- function(gr1, gr2){
  return(length(data.frame(findOverlaps(gr1, gr2))$queryHits))
}
