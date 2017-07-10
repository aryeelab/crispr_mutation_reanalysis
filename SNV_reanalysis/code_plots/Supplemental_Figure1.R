library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)
library(BuenColors)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

F03_FVB <- intersectAll("n98_t97")
F05_FVB <- intersectAll("n98_t96")
F03_FVB_pub <- pubIntersectAll("F03--FVB")
F05_FVB_pub <- pubIntersectAll("F05--FVB")
shared_F03_FVB <- sum(countOverlaps(F03_FVB, F03_FVB_pub))
shared_F05_FVB <- sum(countOverlaps(F05_FVB, F05_FVB_pub))

df1 <- data.frame(
 Mouse = rep(c("F05", "F03"),3),
 Variant = c("Reproduced", "Reproduced", "New", "New", "Missed", "Missed"), 
 Count = c(shared_F05_FVB, shared_F03_FVB, length(F05_FVB) - shared_F05_FVB, length(F03_FVB) - shared_F03_FVB,
           shared_F05_FVB - length(F05_FVB_pub), shared_F03_FVB - length(F03_FVB_pub)),
  Type = rep("Full", 6)
)

F03_FVB <- intersectAllDS("n98_t97")
F05_FVB <- intersectAllDS("n98_t96")
F03_FVB_pub <- pubIntersectAll("F03--FVB")
F05_FVB_pub <- pubIntersectAll("F05--FVB")
shared_F03_FVB <- sum(countOverlaps(F03_FVB, F03_FVB_pub))
shared_F05_FVB <- sum(countOverlaps(F05_FVB, F05_FVB_pub))

df2 <- data.frame(
 Mouse = rep(c("F05", "F03"),3),
 Variant = c("Reproduced", "Reproduced", "New", "New", "Missed", "Missed"), 
 Count = c(shared_F05_FVB, shared_F03_FVB, length(F05_FVB) - shared_F05_FVB, length(F03_FVB) - shared_F03_FVB,
           shared_F05_FVB - length(F05_FVB_pub), shared_F03_FVB - length(F03_FVB_pub)),
 Type = rep("Downsampled", 6)
)

df <- rbind(df1, df2)

f1a <- ggplot(data = df, aes(x=Mouse, y=Count, fill=Variant)) + facet_grid(~Type) +
  geom_bar(stat = "identity", colour="black") + pretty_plot()+
  scale_fill_manual(values=c('firebrick', 'dodgerblue', 'green4')) + 
  theme( legend.position="bottom")+labs(colour = "Variant Type", fill = "Variant Type")
ggsave(f1a, file = "pngs/SFigure1A.png", dpi = 300, width = 7, height = 5)



