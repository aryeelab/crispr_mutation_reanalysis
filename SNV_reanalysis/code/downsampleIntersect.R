library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

# Define import functions that return GRanges of variant loci
# For each variant call method

F03_FVB_pub <- pubRead("F03--FVB")
F05_FVB_pub <- pubRead("F05--FVB")

F03_FVB <- intersectAll("n98_t97")
F05_FVB <- intersectAll("n98_t96")

F03_FVB_ds <- intersectAllDS("n98_t97")
F05_FVB_ds <- intersectAllDS("n98_t96")

# Quantify how many variants I was able to recall
sum(countOverlaps(F03_FVB, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB, F05_FVB_pub))/length(F05_FVB_pub)

sum(countOverlaps(F03_FVB_ds, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB_ds, F05_FVB_pub))/length(F05_FVB_pub)

sum(countOverlaps(F03_FVB_ds, F03_FVB))/length(F03_FVB)
sum(countOverlaps(F05_FVB_ds, F05_FVB))/length(F05_FVB)



sum(countOverlaps(F03_FVB_pub, F05_FVB_pub))

