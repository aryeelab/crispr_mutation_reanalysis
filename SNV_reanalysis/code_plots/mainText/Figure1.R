library(BuenColors)
library(cowplot)
v <- rep(0.1, 4)
lh <- 0.2
mv <-  c("F03 & F05", "F03 & FVB", "F05 & FVB")

df1 <- data.frame(Mouse = mv,
                  counts = c(0, 0, 0),
                  class = c("a", "b", "c")
)

pA <- ggplot(df1, aes(x = Mouse, y = counts)) +
  geom_bar(stat = "identity", aes(fill = class), colour = "black" ) + pretty_plot(fontsize = 6) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") +scale_y_continuous(limits = c(0, 50), breaks=seq(0, 40, 10)) +
  theme(legend.position = "none") + ggtitle("Isogenic Model\n") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", lineheight = lh)) +
  theme(plot.margin = unit(v, "cm"))

ggsave(pA, file ="plotA.pdf", height = 3, width = 4, dpi = 300, device = "pdf")

df2 <- data.frame(Mouse = mv,
                  counts = c(33.3, 33.3, 33.3),
                  class = c("a", "b", "c")
)

pB <- ggplot(df2, aes(x = Mouse, y = counts, fill = "val")) +
  geom_bar(stat = "identity", color = "black" ) + pretty_plot(fontsize = 6) + 
  scale_fill_manual(values=c('grey')) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50), breaks=seq(0, 40, 10)) +
  theme(legend.position = "none") + ggtitle("Equal Genetic Distance Model\n") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", lineheight = lh)) +
  theme(plot.margin = unit(v, "cm"))

ggsave(pB, file ="plotB.pdf",  height = 3, width = 4, dpi = 300, device = "pdf")


df3 <- data.frame(Mouse = mv,
                  counts = c(12954/31079*100, 8975/31078*100, 9148/31078*100),
                  class = c("a", "b", "c")
)

pC <- ggplot(df3, aes(x = Mouse, y = counts, fill = "val")) +
  geom_bar(stat = "identity", color = "black" ) + pretty_plot(fontsize = 6) + 
  scale_fill_manual(values=c('grey')) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50), breaks=seq(0, 40, 10)) +
  theme(legend.position = "none") + ggtitle("Observed dbSNP\n") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", lineheight = lh))+
  theme(plot.margin = unit(v, "cm"))

ggsave(pC, file ="plotC.pdf", height = 3, width = 4, dpi = 300, device = "pdf")

df4 <- data.frame(Mouse =  c("F03 & F05", "F03 & F05", "F03 & FVB", "F05 & FVB"),
                  counts = c((16097-1256)/38981*100, 1256/38981*100, 10881/38981*100, 12003/38981*100),
                  class = c("b", "a", "b", "b")
)

pD <- ggplot(df4, aes(x = Mouse, y = counts, fill = class)) +
  geom_bar(stat = "identity", color = "black" ) + pretty_plot(fontsize = 6) + 
  scale_fill_manual(values=c('gray50', 'grey')) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50), breaks=seq(0, 40, 10)) +
  theme(legend.position = "none") + ggtitle("Observed Novel Loci\n") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", lineheight = lh)) +
  theme(plot.margin = unit(v, "cm")) +
  geom_text(aes(x = 2.5, y = 42, label="Schaefer et al. SNVs"), inherit.aes = FALSE, position = position_dodge(width=0.9), size = 2) +
  geom_segment(arrow = arrow(length = unit(0.2,"cm"), type = "closed"), aes(x = 1.7, y = 41.5, xend = 1.5, yend = 40))

ggsave(pD, file = "plotD.pdf", height = 3, width = 4, dpi = 300, device = "pdf")


p4 <- plot_grid(pA,pC,pB,pD, labels = "AUTO", label_size = 10)
ggsave(p4, file = "plot4.pdf", height = 4, width = 4, dpi = 300, device = "pdf")

p3 <- plot_grid(pC,pB,pD, labels = "AUTO", label_size = 10, nrow = 1)
ggsave(p3, file = "plot3.pdf", height = 2, width = 6, dpi = 300, device = "pdf")


fisher.test(matrix(c(12954, 31079-12954, 16097, 38981- 16097),nrow=2))
