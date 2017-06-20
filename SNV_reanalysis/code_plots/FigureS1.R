library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

# Define import functions that return GRanges of variant loci
# For each variant call method

F03_FVB_pub <- pubRead("F03--FVB")
F05_FVB_pub <- pubRead("F05--FVB")

F03_FVB <- intersectAll("n98_t97")
F05_FVB <- intersectAll("n98_t96")

F03_FVB_ds <- intersectAllDS("n98_t97")
F05_FVB_ds <- intersectAllDS("n98_t96")


length(intersectAll("n98_t97"))
length(intersectAll("n97_t98"))
length(intersectAllDS("n98_t97"))
length(intersectAllDS("n97_t98"))


library(tidyverse)
library(BuenColors)

d <- data.frame(
  state = c(rep("Downsampled", 6), rep("Full", 6)),
  normal = rep(c("FVB", "FVB", "F03", "F05", "F05", "F03"),2),
  treated = rep(c("F05", "F03", "FVB", "FVB", "F03", "F05"),2),
  count = c(length(intersectAll("n98_t96")), length(intersectAll("n98_t97")), length(intersectAll("n97_t98")),
            length(intersectAll("n96_t98")), length(intersectAll("n96_t97")), length(intersectAll("n97_t96")),
            length(intersectAllDS("n98_t96")), length(intersectAllDS("n98_t97")), length(intersectAllDS("n97_t98")),
            length(intersectAllDS("n96_t98")), length(intersectAllDS("n96_t97")), length(intersectAllDS("n97_t96")))
  )

p1 <- ggplot(d, aes(normal, count, color = treated)) + pretty_plot() + facet_grid(. ~ state) +
  labs(x = "Control Mouse", y = "SNV Count using Intersection of Methods") +
  geom_bar(width = 0.7, aes(fill = treated), colour="black", stat = "identity", position = position_dodge(width=0.7)) +
  scale_fill_manual(values=c('green4', 'firebrick', 'dodgerblue')) + 
  theme( legend.position="bottom")+labs(colour = "Treatment Mouse", fill = "Treatment Mouse") +
  theme(legend.key = element_blank(), strip.background = element_rect(fill="white", colour="black") ) 
ggsave(p1, file = "variantCallDownsample.png")

length(intersectAll("n98_t97"))
length(intersectAll("n98_t97"))


# Quantify how many variants I was able to recall
sum(countOverlaps(F03_FVB, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB, F05_FVB_pub))/length(F05_FVB_pub)

sum(countOverlaps(F03_FVB_ds, F03_FVB_pub))/length(F03_FVB_pub)
sum(countOverlaps(F05_FVB_ds, F05_FVB_pub))/length(F05_FVB_pub)

sum(countOverlaps(F03_FVB_ds, F03_FVB))/length(F03_FVB)
sum(countOverlaps(F05_FVB_ds, F05_FVB))/length(F05_FVB)

sum(countOverlaps(F03_FVB_pub, F05_FVB_pub))

