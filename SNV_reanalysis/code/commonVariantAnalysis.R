library(data.table)

df <- data.frame(fread("zcat < combinedVariantCalls.txt.gz", sep = "\t"))

gdf <- data.frame(
  gt96 = unname(sapply(df$GT96, function(d){strsplit(d, split = ":")[[1]][1]})),
  gt97 = unname(sapply(df$GT97, function(d){strsplit(d, split = ":")[[1]][1]})),
  gt98 = unname(sapply(df$GT98, function(d){strsplit(d, split = ":")[[1]][1]}))
)

sum(gdf$gt96 != gdf$gt97)
sum(gdf$gt96 != gdf$gt98)
sum(gdf$gt97 != gdf$gt98)
