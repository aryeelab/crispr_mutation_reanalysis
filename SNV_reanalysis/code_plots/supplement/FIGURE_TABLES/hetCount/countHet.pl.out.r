#F03	7087153	732263
#F05	6972046	664436
#FVB	6809736 580338

pdf('countHet.pl.out.r.pdf')
barplot(c(732263/7087153,664436/6972046,580338/6809736),names=c('F03','F05','FVB'),main='Percent of all SNPs that are heterozygous')
barplot(c(7087153,6972046,6809736),names=c('F03','F05','FVB'),main='Number of SNPs')
