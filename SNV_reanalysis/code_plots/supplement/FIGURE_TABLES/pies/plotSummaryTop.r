pdf('plotSummaryTop.r.pdf')
par(mfrow=c(2,2))

total = read.table('commonVariants.txt')
colnames(total) = c('chr','start','end','group')
totalTab = table(total$group)

lbls <- paste(names(totalTab), "\n", totalTab, sep="")
pie(totalTab, labels = lbls,main=paste("All dbSNPs N=",nrow(total)))

plotTab = function(pFile,pTitle)
{
	closest = read.table(pFile)
	colnames(closest) = c('chr','start','end','n.chr','n.start','n.end','n.group','n.distance')
	t = table(closest$n.group)
	lbls <- paste(names(t), "\n", t, sep="")

	#do fisher test
	f = fisher.test(matrix(c(t["F03"] + t["F05"],totalTab["F03"] + totalTab["F05"],t["FVB"],totalTab["FVB"]),nrow=2))

	pie(t, labels = lbls,main=paste(pTitle,"N=",nrow(closest)))
	title(sub=paste("Fisher test p=",f$p.value))
}

plotTab('intersect_treatedF03_normalFVB__treatedF05_normalFVB.bed.filt.bed.closest','For intersect_tF03_tF05_nFVB SNPs,\nclosest dbSNP class')

dev.off()
