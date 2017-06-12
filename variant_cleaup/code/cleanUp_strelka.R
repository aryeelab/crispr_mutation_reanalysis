library(tidyverse)
library(GenomicRanges)
library(BuenColors)


commonsnps <- data.frame(data.table::fread("zcat < ../data/allMouseSNPloci.bed.gz"))
s <- data