library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)


readStrelka <- function(sample, type = "novel"){
  file <- paste0("data/", sample, "_FVB_strelka.somatic.snvs.vcf.gz")
  df <- read.table(file, sep = "\t")
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  gr
}
  
readMutect <- function(sample, type = "novel", filt = FALSE){
  file <- paste0("data/mutect_", sample, "_", type, ".vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  if(filt) df <- df[df$judgement == "KEEP", ]
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "contig", start.field = "position", end.field = "position")
  gr
}

readLofreq <- function(sample, type = "novel", meta = "relaxed"){
  file <- paste0("data/", sample, "_FVB-", type, "tumor_",meta, ".vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "X.CHROM", start.field = "POS", end.field = "POS")
  gr
}

intersectAll <- function(sample, type = "novel"){
  s <- readStrelka(sample, type)
  m <- readMutect(sample, type)
  l <- readLofreq(sample, type)
  expected <- bedToGRanges(paste0("data/venn.", type, "110.bed"))
  ov1 <- findOverlaps(s,m)
  ov2 <- findOverlaps(s[data.frame(ov1)$queryHits], l)
  g <- l[data.frame(ov2)$subjectHits]
  ov3 <- findOverlaps(g,expected)
  variantsCalledg <- g[data.frame(ov3)$queryHits]
  variantsCalledg 
}


in2 <- function(gr1, gr2){
  return(length(data.frame(findOverlaps(gr1, gr2))$queryHits))
}
