library(tidyverse)
library(BuenColors)

d <- data.frame(
  normal = c("FVB", "FVB", "F03", "F03", "F05", "F05"),
  treated = c("F05", "F03", "FVB", "F05", "FVB", "F03"),
  count = c(4608, 7295, 4255, 1643, 3966, 5281)
  )

p <- ggplot(d, aes(normal, count, color = treated)) + pretty_plot() + labs(x = "Control Mouse", y = "SNV Count using Strelka") +
  geom_bar(width = 0.7, aes(fill = treated), colour="black", stat = "identity", position = position_dodge(width=0.7)) +
  scale_fill_manual(values=c('green4', 'firebrick', 'dodgerblue')) + 
  theme( legend.position="bottom")+labs(colour = "Treatment Mouse", fill = "Treatment Mouse") 
ggsave(p, file = "strelka_counts.png")
