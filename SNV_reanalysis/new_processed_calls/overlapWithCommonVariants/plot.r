library(ggplot2)
pdf('plot.r.pdf')

total = read.table('commonVariants.txt')
colnames(total) = c('chr','start','end','group')
totalTab = table(total$group)

plotTab = function(pFile,pTitle)
{
	closest = read.table(pFile)
	colnames(closest) = c('chr','start','end','n.chr','n.start','n.end','n.group','n.distance')
	t = table(closest$n.group)
	lbls <- paste(names(t), "\n", t, sep="")

	#do fisher test
	f = fisher.test(matrix(c(t["F03"] + t["F05"],totalTab["F03"] + totalTab["F05"],t["FVB"],totalTab["FVB"]),nrow=2))

	pie(t, labels = lbls,main=paste(pTitle,"N=",nrow(closest)))
	title(sub=paste("Fisher test:",f$p.value))

	ggplot(closest, aes(n.distance, fill = n.group)) + geom_histogram(alpha = 0.5, position = 'identity') + labs(title=pTitle)
	ggplot(closest, aes(n.distance, fill = n.group)) + geom_histogram(alpha = 0.5, aes(y = ..density..), position = 'identity') + labs(title=pTitle)

}

plotTab('COMMON_F03_F05.bed.closest','COMMON_F03_F05')
plotTab('F03_FVB_n98_t97.processed_fixed.bed.closest','All F03')
plotTab('F05_FVB_n98_t96.processed_fixed.bed.closest','All F05')
plotTab('F03_unique.bed.closest','Unique F05')
plotTab('F05_unique.bed.closest','Unique F05')

dev.off()
