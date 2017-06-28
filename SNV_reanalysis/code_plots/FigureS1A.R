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
length(F03_FVB)
length(F05_FVB)


# Export tables of intersected variants
#write.table(data.frame(F03_FVB)[,c(1,2,3)], file = "../new_processed_calls/F03_FVB_n98_t97.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
#write.table(data.frame(F05_FVB)[,c(1,2,3)], file = "../new_processed_calls/F05_FVB_n98_t96.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
#write.table(data.frame(flip_F03_FVB)[,c(1,2,3)], file = "../new_processed_calls/flip_FVB_F03_n97_t98.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)
#write.table(data.frame(flip_F05_FVB)[,c(1,2,3)], file = "../new_processed_calls/flip_FVB_F05_n96_t98.processed.bed", quote = FALSE, row.names = FALSE, col.names = FALSE)


F03_FVB_pub <- pubRead("F03--FVB")
F05_FVB_pub <- pubRead("F05--FVB")

# Quantify how many variants I was able to recall
sum(countOverlaps(F03_FVB, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB, F05_FVB_pub))/length(F05_FVB_pub)

shared_F03_FVB <- sum(countOverlaps(F03_FVB, F03_FVB_pub))
shared_F05_FVB <- sum(countOverlaps(F05_FVB, F05_FVB_pub))

df <- data.frame(
 Mouse = rep(c("F05", "F03"),3),
 Variant = c("Reproduced", "Reproduced", "New", "New", "Missed", "Missed"), 
 Count = c(shared_F05_FVB, shared_F03_FVB, length(F05_FVB) - shared_F05_FVB, length(F03_FVB) - shared_F03_FVB,
           shared_F05_FVB - length(F05_FVB_pub), shared_F03_FVB - length(F03_FVB_pub))
)

f1a <- ggplot(data = df, aes(x=Mouse, y=Count, fill=Variant)) + 
  geom_bar(stat = "identity", colour="black") + pretty_plot()+
  scale_fill_manual(values=c('firebrick', 'green4', 'dodgerblue')) + 
  theme( legend.position="bottom")+labs(colour = "Variant Type", fill = "Variant Type")
ggsave(f1a, file = "Figure1A.png", dpi = 300, width = 5, height = 5)
