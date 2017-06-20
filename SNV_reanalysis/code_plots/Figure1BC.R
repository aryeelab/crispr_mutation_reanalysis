library(data.table)
library(tidyverse)
library(BuenColors)
library(gplots)

df <- data.frame(fread("../new_processed_calls/processedGATK_20june.bed", sep = "\t"))
names(df) <- c("chr", "start", "end", "mouse", "crispr", "snp")
snps <- df[!df$crispr & df$snp,]
other <- df[!df$crispr & !df$snp,]

dim(snps)
dim(other)

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

heatmap.2(t(distingmat), labRow=c("F05", "F03", "FVB"), labCol = NULL, trace="none",
          col = c("grey", "dodgerblue"), key = FALSE)

