library(data.table)
library(GenomicRanges)

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

df <- data.frame(fread("zcat < calledInAll.gatk.vcf.gz", sep = "\t", skip = 193))

gdf <- data.frame(
  gt96 = unname(sapply(df$V10, function(d){strsplit(d, split = ":")[[1]][1]})),
  gt97 = unname(sapply(df$V11, function(d){strsplit(d, split = ":")[[1]][1]})),
  gt98 = unname(sapply(df$V12, function(d){strsplit(d, split = ":")[[1]][1]}))
)

la <- unname(sapply(df$V4, function(d){strsplit(d, split = ",")[[1]][1]}))

gdf <- data.frame(
  gt96 = as.character(gdf$gt96),
  gt97 = as.character(gdf$gt97),
  gt98 = as.character(gdf$gt98), stringsAsFactors = FALSE
)

# Filter Variants based on -- 1) only SNVs, 2) different in 1 mouse, 3) one alt allele, 4)  quality > 20 
gv <- c("0/0", "0/1", "1/1")
boo1 <- (gdf$gt96 != gdf$gt97) | (gdf$gt96 != gdf$gt98) | (gdf$gt97 != gdf$gt98) # Differential Variants
boo <- (gdf$gt96 %in% gv) & (gdf$gt97 %in% gv) & (gdf$gt98 %in% gv) & boo1 & (df$V6 > 20) & nchar(la) == 1

dff <- df[boo,]
gdff <- gdf[boo,]

# Annotate with common SNP or previously ID'd as 'Crispr' snp 
isCommonSNP <- paste0(dff$V1,"_",as.character(dff$V2)) %in% paste0(snps$V1,"_",as.character(snps$V2))

crispF03 <- rbind(
  read.table("F03--FVB.snv.lofreq.v2.1.3a.filtered.vcf", stringsAsFactors = FALSE)[,c(1,2)],
  read.table("F03--FVB.snv.mutect.v1.1.7.filtered.vcf", stringsAsFactors = FALSE)[,c(1,2)],
  read.table("F03--FVB.snv.strelka.v1.0.14.filtered.vcf", stringsAsFactors = FALSE)[,c(1,2)]
)

crispF05 <- rbind(
  read.table("F05--FVB.snv.lofreq.v2.1.3a.filtered.vcf", stringsAsFactors = FALSE)[,c(1,2)],
  read.table("F05--FVB.snv.mutect.v1.1.7.filtered.vcf", stringsAsFactors = FALSE)[,c(1,2)],
  read.table("F05--FVB.snv.strelka.v1.0.14.filtered.vcf", stringsAsFactors = FALSE)[,c(1,2)]
)

isCrisprSNP <- (paste0(dff$V1,"_",as.character(dff$V2)) %in% paste0("chr", crispF03$V1,"_",as.character(crispF03$V2))) &
               (paste0(dff$V1,"_",as.character(dff$V2)) %in% paste0("chr", crispF05$V1,"_",as.character(crispF05$V2)))
sum(isCrisprSNP)

# Annotate with specific mouse
countsdiff <- data.frame(
  c96 = unname(sapply(gdff$gt96, function(d){sum(as.numeric(strsplit(d, split = "/")[[1]]))})),
  c97 = unname(sapply(gdff$gt97, function(d){sum(as.numeric(strsplit(d, split = "/")[[1]]))})),
  c98 = unname(sapply(gdff$gt98, function(d){sum(as.numeric(strsplit(d, split = "/")[[1]]))}))
) %>% data.matrix()

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
anno <- ifelse(uniqVarVec == 1, "F05", ifelse(uniqVarVec == 2, "F03", "FVB"))

# Make Final Output
outdf <- data.frame(dff[,c(1,2)], dff[,c(2)+1], anno, isCrisprSNP, )

#library(dplyr)
#df2 <- data.frame(group_by(gdff, gt96, gt97, gt98) %>% summarize(count = n()))

gdff <- g2dff[isCommonSNP,]
# Get numbers for 1C
sum((gdff$gt96 != gdff$gt97) & (gdff$gt97 == gdff$gt98)) # Shared in FVB and F03
sum((gdff$gt97 != gdff$gt98) & (gdff$gt98 == gdff$gt96)) # Shared in FVB and F05 
sum((gdff$gt96 != gdff$gt98) & (gdff$gt96 == gdff$gt97)) # Shared in F05 and F03

X1 <- 11323
X2 <- 10856
X3 <- 16026
p1 = p2 = p3 = 1/3
n <- X1 + X2 + X3

chisquare <- (X1 - n*p1)^2/(n*p1) + (X2 - n*p2)^2/(n*p2) + (X3 - n*p3)^2/(n*p3)
1- pchisq(chisquare, 3) 

