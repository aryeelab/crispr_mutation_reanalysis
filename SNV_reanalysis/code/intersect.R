library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

F03_FVB <- intersectAll("n98_t97")
F05_FVB <- intersectAll("n98_t96")
length(F03_FVB)
length(F05_FVB)

flip_F03_FVB <- intersectAll("n97_t98")
flip_F05_FVB <- intersectAll("n96_t98")
length(flip_F03_FVB)
length(flip_F05_FVB)

F03_F05 <-  intersectAll("n97_t96")
F05_F03 <-  intersectAll("n96_t97")
length(F03_F05)
length(F05_F03)

# Export tables of intersected variants
write.table(data.frame(F03_FVB)[,c(1,2,3)], file = "../new_processed_calls/F03_FVB_n98_t97.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(data.frame(F05_FVB)[,c(1,2,3)], file = "../new_processed_calls/F05_FVB_n98_t96.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(data.frame(flip_F03_FVB)[,c(1,2,3)], file = "../new_processed_calls/flip_FVB_F03_n97_t98.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(data.frame(flip_F05_FVB)[,c(1,2,3)], file = "../new_processed_calls/flip_FVB_F05_n96_t98.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)

length(intersectAll("n97_t98"))


F03_FVB_pub <- pubRead("F03--FVB")
F05_FVB_pub <- pubRead("F05--FVB")

# Quantify how many variants I was able to recall
sum(countOverlaps(F03_FVB, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB, F05_FVB_pub))/length(F05_FVB_pub)

sum(countOverlaps(F03_FVB_pub, F05_FVB_pub))

