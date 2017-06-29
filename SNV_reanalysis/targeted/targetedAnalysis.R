source("targetedImport.R")
options(warn=-1)
length(intersectAll("F05", "novel"))
length(intersectAll("F05", "dbSNP"))

length(intersectAll("F03", "novel"))
length(intersectAll("F03", "dbSNP"))

expected <- bedToGRanges("GATK.out.anno.F03F05.bed")
snps <- bedToGRanges("data/venn.dbSNP110.bed")
novel <- bedToGRanges("data/venn.novel110.bed")

sum(countOverlaps(expected, intersectAll("F03", "novel")) != 0)
sum(countOverlaps(expected, intersectAll("F05", "novel")) != 0)

sum(countOverlaps(intersectAll("F03", "novel"), intersectAll("F05", "novel")))
sum(countOverlaps(intersectAll("F03", "dbSNP"), intersectAll("F05", "dbSNP")))


m <- matrix(c(sum(countOverlaps(intersectAll("F03", "dbSNP"),  intersectAll("F05", "dbSNP"))), length(snps),
                     sum(countOverlaps(intersectAll("F03", "novel"), intersectAll("F05", "novel"))), 
                     length(novel)), ncol = 2)
m

fisher.test(m)
chisq.test(m)

binom.test(sum(countOverlaps(intersectAll("F03", "novel"), intersectAll("F05", "novel"))), length(novel), 
           sum(countOverlaps(intersectAll("F03", "dbSNP"),intersectAll("F05", "dbSNP")))/ length(snps))

