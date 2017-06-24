library(tidyverse)
library(GenomicRanges)
library(data.table)
library(diffloop)
library(BuenColors)
library(VennDiagram)

source("importData.R")

# 96 F05 Treated
# 97 F03 Treated
# 98 FVB Control

F03_FVB <- intersectAll("n98_t97")
F05_FVB <- intersectAll("n98_t96")

vdMake <- function(sample){
  colorvec <-  c("purple", "orangered", "turquoise3")
  grid.newpage()
  g1 <- draw.triple.venn(
    area1 = length(readStrelka(sample)),
    area2 = length(readLofreq(sample)),
    area3 = length(readMutect(sample)),
    
    n12 = in2(readStrelka(sample), readLofreq(sample)),
    n23 = in2(readMutect(sample), readLofreq(sample)),
    n13 = in2(readStrelka(sample), readMutect(sample)), 
    
    n123 = length(intersectAll(sample)),
    
    lty = "blank", fontfamily = "sans", fontface = "bold",
    category = c("Strelka", "Lofreq", "Mutect"), 
    fill = colorvec,
    cat.col = colorvec,
    cat.fontfamily = "sans",
    main = "F03 / FVB"
  )
  return(g1)
}
ggsave("F03_FVB.png", plot = vdMake("n98_t97"), device = "png", path = NULL,
       scale = 1, height = 4, width = 4)
ggsave("F05_FVB.png", plot = vdMake("n98_t96"), device = "png", path = NULL,
       scale = 1, height = 4, width = 4)
ggsave("FVB_F03.png", plot = vdMake("n97_t98"), device = "png", path = NULL,
       scale = 1, height = 4, width = 4)
ggsave("FVB_F05.png", plot = vdMake("n96_t98"), device = "png", path = NULL,
       scale = 1, height = 4, width = 4)

