source("targetedImport.R")
options(warn=-1)
length(intersectAll("F05", "novel"))
length(intersectAll("F05", "dbSNP"))

length(intersectAll("F03", "novel"))
length(intersectAll("F03", "dbSNP"))

length(intersectAll("FVB", "novel"))
length(intersectAll("FVB", "dbSNP"))

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

