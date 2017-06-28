source("targetedImport.R")
options(warn=-1)
length(intersectAll("F05", "novel"))
length(intersectAll("F05", "dbSNP"))

length(intersectAll("F03", "novel"))
length(intersectAll("F03", "dbSNP"))

expected <- bedToGRanges("GATK.out.anno.F03F05.bed")

sum(countOverlaps(intersectLM("F03", "novel"),expected))
sum(countOverlaps(intersectLM("F05", "novel"),expected))

sum(countOverlaps(intersectLM("F03", "novel"), intersectLM("F05", "novel")))
sum(countOverlaps(intersectLM("F03", "dbSNP"), intersectLM("F05", "dbSNP")))


