# This script was used to combine the bcftools
# variant calls and output only variants called 
# in both samples. The input files do not exist
# in this repo due to size and the computational
# burden of this script. 

library(data.table)

# Import and merge data from three variant calls

dt1 <- fread("zcat < SRR5450996.calls.vcf.gz", sep = "\t", skip = 94)
dt1 <- dt1[,c(1,2,4,5,6,8,10)]
colnames(dt1) <-  c("chrom", "pos", "ref", "alt", "qual96", "Info96", "GT96")

dt2 <- fread("zcat < SRR5450997.calls.vcf.gz", sep = "\t", skip = 94)
dt2 <- dt2[,c(1,2,4,5,6,8,10)]
colnames(dt2) <-  c("chrom", "pos", "ref", "alt", "qual97", "Info97", "GT97")

mdt <- merge(dt1, dt2, all = FALSE)
remove(dt1)
remove(dt2)
message("merge 1 finished")

dt3 <- fread("zcat < SRR5450998.calls.vcf.gz", sep = "\t", skip = 94)
dt3 <- dt3[,c(1,2,4,5,6,8,10)]
colnames(dt3) <-  c("chrom", "pos", "ref", "alt", "qual98", "Info98", "GT98")

mmdt <- merge(mdt, dt3, all = FALSE)
message("merge 2 finished")
remove(mdt)
remove(dt3)

# Subset / Output data such that a variant is called for all three and is non reference / reference
mout <- mmdt[(mmdt$GT96 != "0/0" | mmdt$GT97 != "0/0" |  mmdt$GT98 != "0/0") & (mmdt$GT96 != "./." & mmdt$GT97 != "./." &  mmdt$GT98 != "./.") ,]
fwrite(mout, file = "combinedVariantCalls.txt", sep = "\t", quote = FALSE, col.names = TRUE)
