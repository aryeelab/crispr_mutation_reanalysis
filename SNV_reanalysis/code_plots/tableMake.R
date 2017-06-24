library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control
# n = normal; t = tumor

F03_FVB <- data.frame(intersectAll("n98_t97")); F03_FVB$end <- F03_FVB$end + 1
F05_FVB <- data.frame(intersectAll("n98_t96")); F05_FVB$end <- F05_FVB$end + 1

FVB_F03 <- data.frame(intersectAll("n97_t98")); FVB_F03$end <- FVB_F03$end + 1
F05_F03 <- data.frame(intersectAll("n97_t96")); F05_F03$end <- F05_F03$end + 1

FVB_F05 <- data.frame(intersectAll("n96_t98")); FVB_F05$end <- FVB_F05$end + 1
F03_F05 <- data.frame(intersectAll("n96_t97")); F03_F05$end <- F03_F05$end + 1


# Export tables of intersected variants
write.table(F03_FVB[,c(1,2,3,6)], file = "../new_processed_calls/tF03_nFVB.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(F05_FVB[,c(1,2,3,6)], file = "../new_processed_calls/tF05_nFVB.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)

write.table(FVB_F03[,c(1,2,3,6)], file = "../new_processed_calls/tFVB_nF03.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(F05_F03[,c(1,2,3,6)], file = "../new_processed_calls/tF05_nF03.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)

write.table(FVB_F05[,c(1,2,3,6)], file = "../new_processed_calls/tFVB_nF05.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(F03_F05[,c(1,2,3,6)], file = "../new_processed_calls/tF03_nF05.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Get the intersected variants

F03_FVBg <- intersectAll("n98_t97")
F05_FVBg <- intersectAll("n98_t96")
ovg <- data.frame(F03_FVBg[queryHits(findOverlaps(F03_FVBg,F05_FVBg))]); ovg$end <-  ovg$end + 1
write.table(ovg[,c(1,2,3,6)], file = "../new_processed_calls/overlap_tF03tF05_nFVB.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)

FVB_F03g <- intersectAll("n97_t98")
FVB_F05g <- intersectAll("n96_t98")
ovg <- data.frame(F03_FVBg[queryHits(findOverlaps(FVB_F03g,FVB_F05g))]); ovg$end <-  ovg$end + 1
write.table(ovg[,c(1,2,3,6)], file = "../new_processed_calls/overlap_tFVP_nF03nF05.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)

