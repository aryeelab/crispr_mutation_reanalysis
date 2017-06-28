library(data.table)
library(tidyverse)
library(BuenColors)
library(gplots)

novel <- data.frame(fread("../new_processed_calls/GATK/GATK.out.novel.bed", sep = "\t"))
names(novel) <- c("chr", "start", "end", "mouse")

# Make integer approximation to speed up
ratios <- round(table(novel$mouse) / sum(table(novel$mouse))*100,0)
distMat <- data.frame(
  F03 = as.numeric(c(rep(1, ratios["F03"]), rep(0, ratios["F05"]), rep(0, ratios["FVB"]))), 
  F05 = as.numeric(c(rep(0, ratios["F03"]), rep(1, ratios["F05"]), rep(0, ratios["FVB"]))), 
  FVB  =as.numeric(c(rep(0, ratios["F03"]), rep(0, ratios["F05"]), rep(1, ratios["FVB"])))
) %>% data.matrix()

snps <- data.frame(fread("../new_processed_calls/GATK/GATK.out.dbSNP.bed", sep = "\t"))
names(snps) <- c("chr", "start", "end", "mouse")
ratios2 <- round(table(snps$mouse) / sum(table(snps$mouse))*100,0)
distMat2 <- data.frame(
  F03 = as.numeric(c(rep(1, ratios2["F03"]), rep(0, ratios2["F05"]), rep(0, ratios2["FVB"]))), 
  F05 = as.numeric(c(rep(0, ratios2["F03"]), rep(1, ratios2["F05"]), rep(0, ratios2["FVB"]))), 
  FVB  =as.numeric(c(rep(0, ratios2["F03"]), rep(0, ratios2["F05"]), rep(1, ratios2["FVB"])))
) %>% data.matrix()

png("Figure1_snp.png")
heatmap.2(t(distMat2), labCol = rep("", 100), trace="none",
          col = c("purple3", "grey"), key = FALSE, 
          dendrogram = "row")
dev.off()
png("Figure1_novel.png")
heatmap.2(t(distMat), labCol = rep("", 100), trace="none",
          col = c("purple4", "grey"), key = FALSE, 
          dendrogram = "row")
dev.off()

