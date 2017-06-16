library(data.table)
library(tidyverse)
library(BuenColors)
library(gplots)

df <- data.frame(fread("zcat < ../SNV_reanalysis/snps/combinedVariantCalls.txt.gz", sep = "\t"))

gdf <- data.frame(
  gt96 = unname(sapply(df$GT96, function(d){strsplit(d, split = ":")[[1]][1]})),
  gt97 = unname(sapply(df$GT97, function(d){strsplit(d, split = ":")[[1]][1]})),
  gt98 = unname(sapply(df$GT98, function(d){strsplit(d, split = ":")[[1]][1]})), 
  stringsAsFactors = FALSE
)

# Find differing variance and do an allele count
diff <- gdf[(gdf$gt96 != gdf$gt97) | (gdf$gt96 != gdf$gt98) | (gdf$gt97 != gdf$gt98),]
countsdiff <- data.frame(
  c96 = unname(sapply(diff$gt96, function(d){sum(as.numeric(strsplit(d, split = "/")[[1]]))})),
  c97 = unname(sapply(diff$gt97, function(d){sum(as.numeric(strsplit(d, split = "/")[[1]]))})),
  c98 = unname(sapply(diff$gt98, function(d){sum(as.numeric(strsplit(d, split = "/")[[1]]))}))
) %>% data.matrix()


# Compute the mode and then subtract it out
# https://stackoverflow.com/questions/28094468/how-to-calculate-the-mode-of-all-rows-or-columns-from-a-dataframe
modefunc <- function(x){
    tabresult <- tabulate(x)
    themode <- which(tabresult == max(tabresult))
    if(sum(tabresult == max(tabresult))>1) themode <- NA
    return(themode)
}

# I'm taking the mode to identify the "rare" individual and the contorting it such that
# two 1s appear in the final matrix that indicate that both shared these mutations
distingmat <- abs(abs(countsdiff - apply(countsdiff, 1, modefunc)) - 1)

# Make bedfile output
uniqVarMat <- abs(countsdiff - apply(countsdiff, 1, modefunc))
uniqVarVec <- uniqVarMat[,1]*1 +  uniqVarMat[,2]*2 +  uniqVarMat[,3]*3
odf <- df[(gdf$gt96 != gdf$gt97) | (gdf$gt96 != gdf$gt98) | (gdf$gt97 != gdf$gt98),c(1,2)]
odf$pos2 <- odf$pos + 1
odf$anno <- ifelse(uniqVarVec == 1, "F05", ifelse(uniqVarVec == 2, "F03", "FVB"))
write.table(odf, file = "../SNV_reanalysis/snps/commonVariants.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

heatmap.2(t(distingmat), labRow=c("F05", "F03", "FVB"), labCol = NULL, trace="none",
          col = c("grey", "dodgerblue"), key = FALSE)

sum(distingmat[,3]==0)/dim(distingmat)[1]
binom.test(sum(distingmat[,3]==0), dim(distingmat)[1], 1/3, alternative="two.sided")$p.value

