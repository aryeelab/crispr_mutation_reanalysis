library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)


readStrelka <- function(sample, type = "novel"){
  s <- strsplit(sample, split = "_")[[1]]
  file <- paste0("data/strelka/", sample, ".vcf")
  df <- read.table(file, sep = "\t")
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "V1", start.field = "V2", end.field = "V2")
  gr
}
  
readMutect <- function(sample, type = "novel", filt = FALSE){
  file <- paste0("data/mutect/mutect_", sample, "_", type, ".vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  if(filt) df <- df[df$judgement == "KEEP", ]
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "contig", start.field = "position", end.field = "position")
  gr
}

readLofreq <- function(sample, type = "novel", meta = "relaxed"){
  file <- paste0("data/lofreq/", sample, "-", type, "tumor_",meta, ".vcf.gz")
  df <- data.frame(fread(paste("zcat < ", file)))
  gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "X.CHROM", start.field = "POS", end.field = "POS")
  gr
}

intersectPair <- function(sample, type = "novel"){
  s <- readStrelka(sample, type)
  m <- readMutect(sample, type)
  l <- readLofreq(sample, type)
  ov1 <- findOverlaps(l,m)
  #g <- m[data.frame(ov1)$subjectHits]
  ov2 <- findOverlaps(l[data.frame(ov1)$queryHits], s)
  g <- s[data.frame(ov2)$subjectHits]
  g
}

intersectAll <- function(sample, type = "novel"){
  if(sample == "F05"){
    samplePair1 <- "F03_F05"
    samplePair2 <- "FVB_F05"
  } else if(sample == "F03"){
    samplePair1 <- "F05_F03"
    samplePair2 <- "FVB_F03"
  } else {
    samplePair1 <- "F05_FVB"
    samplePair2 <- "F03_FVB"
  }
  sp1 <- intersectPair(samplePair1, type)
  sp2 <- intersectPair(samplePair2, type)
  
  df <- read.table(paste0("data/bed/", type, ".", sample,".bed"), sep = "\t", header = FALSE)
  df$V3 <- df$V2 +1
  expected <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE, seqnames.field = "V1", start.field = "V2", end.field = "V3")
  ov1 <- findOverlaps(sp1, sp2)
  ov2 <- findOverlaps(sp1[data.frame(ov1)$queryHits], expected)
  g <- expected[data.frame(ov2)$subjectHits]
  g
}


in2 <- function(gr1, gr2){
  return(length(data.frame(findOverlaps(gr1, gr2))$queryHits))
}
