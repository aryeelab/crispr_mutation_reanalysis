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
gr <- intersectAll("n97_t96"); seqlevels(gr) <- sort(seqlevels(gr))
F05_F03 <- data.frame(sort(gr)); F05_F03$end <- F05_F03$end + 1

gr <- intersectAll("n96_t98"); seqlevels(gr) <- sort(seqlevels(gr))
FVB_F05 <- data.frame(sort(gr)); FVB_F05$end <- FVB_F05$end + 1
gr <- intersectAll("n96_t97");  seqlevels(gr) <- sort(seqlevels(gr))
F03_F05 <- data.frame(sort(gr)); F03_F05$end <- F03_F05$end + 1


# Export tables of intersected variants
write.table(F03_FVB[,c(1,2,3,6)], file = "../new_processed_calls/treatedF03_normalFVB.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(F05_FVB[,c(1,2,3,6)], file = "../new_processed_calls/treatedF05_normalFVB.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

write.table(FVB_F03[,c(1,2,3,6)], file = "../new_processed_calls/treatedFVB_normalF03.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(F05_F03[,c(1,2,3,6)], file = "../new_processed_calls/treatedF05_nnormalF03.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

write.table(FVB_F05[,c(1,2,3,6)], file = "../new_processed_calls/treatedFVB_normalF05.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(F03_F05[,c(1,2,3,6)], file = "../new_processed_calls/treatedF03_normalF05.bed",
            quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

# Get the intersected variants
writeIntersectFile <- function(sample1, sample2, fileOut){
  g1 <- intersectAll(sample1); seqlevels(g1) <- sort(seqlevels(g1))
  g2 <- intersectAll(sample2); seqlevels(g2) <- sort(seqlevels(g2))
  ovg <- data.frame(sort(g1[queryHits(findOverlaps(g1,g2))])); ovg$end <-  ovg$end + 1
  write.table(ovg[,c(1,2,3,6)], file = paste0("../new_processed_calls/intersections/intersect_", fileOut, ".bed"),
              quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
}

writeIntersectFile("n98_t97", "n98_t96", "treatedF03treatedF05_normalFVB")
writeIntersectFile("n97_t96", "n97_t98", "treatedF05treatedFVB_normalF03")
writeIntersectFile("n96_t97", "n96_t98", "treatedF03treatedFVB_normalF05")

writeIntersectFile("n96_t98", "n97_t98", "treatedFVB_normalF03normalF05")

