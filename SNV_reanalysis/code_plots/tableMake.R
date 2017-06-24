library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control
# n = normal; t = tumor

gr <- intersectAll("n98_t97"); seqlevels(gr) <- sort(seqlevels(gr))
F03_FVB <- data.frame(sort(gr)); F03_FVB$end <- F03_FVB$end + 1
gr <- intersectAll("n98_t96"); seqlevels(gr) <- sort(seqlevels(gr))
F05_FVB <- data.frame(sort(gr)); F05_FVB$end <- F05_FVB$end + 1

gr <- intersectAll("n97_t98"); seqlevels(gr) <- sort(seqlevels(gr))
FVB_F03 <- data.frame(sort(gr)); FVB_F03$end <- FVB_F03$end + 1
gr <- intersectAll("n97_t96")
F05_F03 <- data.frame(sort(gr)); F05_F03$end <- F05_F03$end + 1

gr <- intersectAll("n96_t98"); seqlevels(gr) <- sort(seqlevels(gr))
FVB_F05 <- data.frame(sort(gr)); FVB_F05$end <- FVB_F05$end + 1
gr <- intersectAll("n96_t97");  seqlevels(gr) <- sort(seqlevels(gr))
F03_F05 <- data.frame(sort(gr)); F03_F05$end <- F03_F05$end + 1


# Export tables of intersected variants
write.table(F03_FVB[,c(1,2,3,6)], file = "../new_processed_calls/tF03_nFVB.bed", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(F05_FVB[,c(1,2,3,6)], file = "../new_processed_calls/tF05_nFVB.bed", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

write.table(FVB_F03[,c(1,2,3,6)], file = "../new_processed_calls/tFVB_nF03.bed", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(F05_F03[,c(1,2,3,6)], file = "../new_processed_calls/tF05_nF03.bed", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

write.table(FVB_F05[,c(1,2,3,6)], file = "../new_processed_calls/tFVB_nF05.bed", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(F03_F05[,c(1,2,3,6)], file = "../new_processed_calls/tF03_nF05.bed", quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

# Get the intersected variants

F03_FVBg <- intersectAll("n98_t97"); seqlevels(F03_FVBg) <- sort(seqlevels(F03_FVBg))
F05_FVBg <- intersectAll("n98_t96"); seqlevels(F05_FVBg) <- sort(seqlevels(F05_FVBg))
ovg <- data.frame(sort(F03_FVBg[queryHits(findOverlaps(F03_FVBg,F05_FVBg))])); ovg$end <-  ovg$end + 1
write.table(ovg[,c(1,2,3,6)], file = "../new_processed_calls/overlap_tF03tF05_nFVB.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

FVB_F03g <- intersectAll("n97_t98"); seqlevels(FVB_F03g) <- sort(seqlevels(FVB_F03g))
FVB_F05g <- intersectAll("n96_t98"); seqlevels(FVB_F05g) <- sort(seqlevels(FVB_F05g))
ovg <- data.frame(sort(FVB_F03g[queryHits(findOverlaps(FVB_F03g,FVB_F05g))])); ovg$end <-  ovg$end + 1
write.table(ovg[,c(1,2,3,6)], file = "../new_processed_calls/overlap_tFVB_nF03nF05.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

