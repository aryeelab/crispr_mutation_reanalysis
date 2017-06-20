pdf('recombinationCorrelation.r.pdf')
rec = read.table('recombination.txt.density')
rec$name = paste(rec$V1, rec$V2)

F03_FVB = read.table("F03_FVB_n98_t97.processed.bed.density")
F05_FVB = read.table("F05_FVB_n98_t96.processed.bed.density")
flip_FVB_F05 = read.table("flip_FVB_F05_n96_t98.processed.bed.density")
flip_FVB_F03 = read.table("flip_FVB_F05_n97_t98.processed.bed.density")

COMMON = read.table("COMMON_F03_F05.bed.density")
FLIP = read.table("COMMON_FLIP.bed.density")

op = par(no.readonly = TRUE)
par(mar=c(20,5,4,2))

barplot(c(0.451024,0.971919,0.374614,0.0760438),names=c('F03/FVB vs F05/FVB','Flipped SNPs (FVB/F03 vs FVB/F05)','Recombination Hotspots vs Common SNPs','Recombination Hotspots vs Flipped SNPs'),las=2,main='Distribution Correlation')
par(op)

title = "Density (per 10000000bp)"


m = merge(rec,COMMON,by=c('V1','V2'),suffixes = c('.rec','.COMMON'))
plot(m$V3.rec,m$V3.COMMON,xlab="Recombination hotspots",ylab="COMMON_F03_F05 SNPs",main=paste(title,"\nCorrelation: 0.374614"))
abline(lm(m$V3.COMMON~m$V3.rec),col='red')

smoothScatter(m$V3.rec,m$V3.COMMON,xlab="Recombination hotspots",ylab="COMMON_F03_F05 SNPs",main=paste(title,"\nCorrelation: 0.374614"),nrpoints=0)
abline(lm(m$V3.COMMON~m$V3.rec),col='red')

m = merge(rec,FLIP,by=c('V1','V2'),suffixes = c('.rec','.FLIP'))
plot(m$V3.rec,m$V3.FLIP,xlab="Recombination hotspots",ylab="COMMON_FLIP SNPs",main=paste(title,"\nCorrelation: 0.0760438"))
abline(lm(m$V3.FLIP~m$V3.rec),col='red')

smoothScatter(m$V3.rec,m$V3.FLIP,xlab="Recombination hotspots",ylab="COMMON_FLIP SNPs",main=paste(title,"\nCorrelation: 0.0760438"),nrpoints=0)
abline(lm(m$V3.FLIP~m$V3.rec),col='red')


m = merge(rec,F03_FVB,by=c('V1','V2'),suffixes = c('.rec','.F03_FVB'))
plot(m$V3.rec,m$V3.F03_FVB,xlab="Recombination hotspots",ylab="F03_FVB SNPs",main=paste(title,"\nCorrelation: -0.00414933"))
abline(lm(m$V3.F03_FVB~m$V3.rec),col='red')

m = merge(rec,F05_FVB,by=c('V1','V2'),suffixes = c('.rec','.F05_FVB'))
plot(m$V3.rec,m$V3.F05_FVB,xlab="Recombination hotspots",ylab="F05_FVB SNPs",main=paste(title,"\nCorrelation: 0.286885"))
abline(lm(m$V3.F05_FVB~m$V3.rec),col='red')

m = merge(rec,flip_FVB_F05,by=c('V1','V2'),suffixes = c('.rec','.flip_FVB_F05'))
plot(m$V3.rec,m$V3.flip_FVB_F05,xlab="Recombination hotspots",ylab="flip_FVB_F05 SNPs",main=paste(title,"\nCorrelation: 0.0975554"))
abline(lm(m$V3.flip_FVB_F05~m$V3.rec),col='red')

m = merge(rec,flip_FVB_F03,by=c('V1','V2'),suffixes = c('.rec','.flip_FVB_F03'))
plot(m$V3.rec,m$V3.flip_FVB_F03,xlab="Recombination hotspots",ylab="flip_FVB_F03 SNPs",main=paste(title,"\nCorrelation: 0.0775865"))
abline(lm(m$V3.flip_FVB_F03~m$V3.rec),col='red')
