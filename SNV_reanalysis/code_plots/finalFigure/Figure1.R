library(BuenColors)

mv <-  c("F03 & F05", "F03 & FVB", "F05 & FVB")

df1 <- data.frame(Mouse = mv,
                 counts = c(0, 0, 0),
                 class = c("a", "b", "c")
                 )

ggplot(df1, aes(x = Mouse, y = counts)) +
  geom_bar(stat = "identity", aes(fill = class), colour = "black" ) + pretty_plot() +
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50)) + 
  theme(legend.position = "none")

ggsave("plotA.pdf", height = 3, width = 4, dpi = 300, device = "pdf")

df2 <- data.frame(Mouse = mv,
                 counts = c(33.3, 33.3, 33.3),
                 class = c("a", "b", "c")
                 )

ggplot(df2, aes(x = Mouse, y = counts, fill = "val")) +
  geom_bar(stat = "identity", color = "black" ) + pretty_plot() + 
  scale_fill_manual(values=c('grey')) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50)) +
  theme(legend.position = "none")

ggsave("plotB.pdf",  height = 3, width = 4, dpi = 300, device = "pdf")


df3 <- data.frame(Mouse = mv,
                 counts = c(12954/31079*100, 8975/31078*100, 9148/31078*100),
                 class = c("a", "b", "c")
                 )

ggplot(df3, aes(x = Mouse, y = counts, fill = "val")) +
  geom_bar(stat = "identity", color = "black" ) + pretty_plot() + 
  scale_fill_manual(values=c('grey')) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50)) +
  theme(legend.position = "none")

ggsave("plotC.pdf", height = 3, width = 4, dpi = 300, device = "pdf")

df4 <- data.frame(Mouse =  c("F03 & F05", "F03 & F05", "F03 & FVB", "F05 & FVB"),
                 counts = c((16097-1256)/38981*100, 1256/38981*100, 10881/38981*100, 12003/38981*100),
                 class = c("b", "a", "b", "b")
                 )

ggplot(df4, aes(x = Mouse, y = counts, fill = class)) +
  geom_bar(stat = "identity", color = "black" ) + pretty_plot() + 
  scale_fill_manual(values=c('gray20', 'grey')) + 
  labs(x = "Mouse Pairs", y = "% of Pairwise Shared Mutations") + scale_y_continuous(limits = c(0, 50)) +
  theme(legend.position = "none") + 

ggsave("plotD.pdf", height = 3, width = 4, dpi = 300, device = "pdf")


fisher.test(matrix(c(12954, 31079-12954, 16097, 38981- 16097),nrow=2))
