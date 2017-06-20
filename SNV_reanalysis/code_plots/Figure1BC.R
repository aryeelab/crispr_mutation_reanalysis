library(data.table)
library(tidyverse)
library(BuenColors)
library(gplots)

df <- data.frame(fread("../new_processed_calls/processedGATK_20june.bed", sep = "\t"))
names(df) <- c("chr", "start", "end", "mouse", "crispr", "snp")
snps <- df[!df$crispr & df$snp,]
other <- df[!df$crispr & !df$snp,]
all <-  df[!df$crispr,]
table(all$mouse) / sum(table(all$mouse))
table(other$mouse) / sum(table(other$mouse))
table(snps$mouse) / sum(table(snps$mouse))

dim(snps)
dim(other)
dim(all)
table(all$mouse)

f1bdf <- data.frame(
  rate = c(table(snps$mouse)/sum(table(snps$mouse)), table(other$mouse)/sum(table(other$mouse))) * 100,
  type = c(rep("SNP", 3), rep("Other", 3)),
  shared = rep(c("F05-FVB", "F03-FVB", "F03-F05"), 2),
  unique = rep(names(table(snps$mouse)), 2)
)

nulldf <- data.frame(
  rate = c(1/3, 1/3)*100,
  type = c(rep("SNP", 1), rep("Other", 1)),
  shared = rep(c("Isogenic"), 2),
  unique = rep("NULL", 2)
)
f1bdf <- rbind(f1bdf, nulldf)
f1bplot <- ggplot(f1bdf, aes(shared, rate, color = type)) + pretty_plot() +
  labs(x = "", y = "% Shared Mutations") +
  geom_bar(width = 0.7, aes(fill = type), colour="black", stat = "identity", position = position_dodge(width=0.7)) +
  scale_fill_manual(values=c('purple3', 'purple4')) + 
  theme( legend.position="bottom")+labs(colour = "Variant Annotation", fill = "Variant Annotation") 

ggsave(f1bplot, file = "Figure1B.png")

# Make integer approximation to speed up
ratios <- round(table(snps$mouse) / sum(table(snps$mouse))*100,0)
distMat <- data.frame(
  F03 = as.numeric(c(rep(1, ratios["F03"]), rep(0, ratios["F05"]), rep(0, ratios["FVB"]))), 
  F05 = as.numeric(c(rep(0, ratios["F03"]), rep(1, ratios["F05"]), rep(0, ratios["FVB"]))), 
  FVB  =as.numeric(c(rep(0, ratios["F03"]), rep(0, ratios["F05"]), rep(1, ratios["FVB"])))
) %>% data.matrix()



ratios2 <- round(table(other$mouse) / sum(table(other$mouse))*100,0)
distMat2 <- data.frame(
  F03 = as.numeric(c(rep(1, ratios2["F03"]), rep(0, ratios2["F05"]), rep(0, ratios2["FVB"]))), 
  F05 = as.numeric(c(rep(0, ratios2["F03"]), rep(1, ratios2["F05"]), rep(0, ratios2["FVB"]))), 
  FVB  =as.numeric(c(rep(0, ratios2["F03"]), rep(0, ratios2["F05"]), rep(1, ratios2["FVB"])))
) %>% data.matrix()

png("Figure1C1.png")
heatmap.2(t(distMat2), labCol = rep("", 100), trace="none",
          col = c("grey", "purple3"), key = FALSE, 
          dendrogram = "row")
dev.off()
png("Figure1C2.png")
heatmap.2(t(distMat), labCol = rep("", 100), trace="none",
          col = c("grey", "purple4"), key = FALSE, 
          dendrogram = "row")
dev.off()

