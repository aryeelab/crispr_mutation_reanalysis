#commonvariants.txt are SNPs from dbSNP that are different in one mouse. The fourth column is the mouse that has the 'other' genome. So entries with 'FVB' in the fourth column are the same in F03 and F05 and different in FVB.
#commonVariants.txt is here: https://github.com/aryeelab/crispr_reanalysis/blob/master/SNV_reanalysis/snps/commonVariants.txt
#The other files (COMMON_F03_F05.bed, F05_FVB_n98_t96.processed_fixed.bed, F03_FVB_n98_t97.processed_fixed.bed) are here: https://github.com/aryeelab/crispr_reanalysis/blob/master/SNV_reanalysis/new_processed_calls/

#use bedtools to find the closest common variant snp
#-d flag prints the distance to the closest snp
bedtools closest -a COMMON_F03_F05.bed -d -b commonVariants.txt > COMMON_F03_F05.bed.closest

bedtools closest -a F05_FVB_n98_t96.processed_fixed.bed -d -b commonVariants.txt > F05_FVB_n98_t96.processed_fixed.bed.closest

bedtools closest -a F03_FVB_n98_t97.processed_fixed.bed -d -b commonVariants.txt > F03_FVB_n98_t97.processed_fixed.bed.closest

#create files with only F03 or only F05 SNPs
bedtools intersect -v -a F03_FVB_n98_t97.processed_fixed.bed -b F05_FVB_n98_t96.processed_fixed.bed > F03_unique.bed
bedtools closest -a F03_unique.bed -d -b commonVariants.txt > F03_unique.bed.closest

bedtools intersect -v -a F05_FVB_n98_t96.processed_fixed.bed -b F03_FVB_n98_t97.processed_fixed.bed > F05_unique.bed
bedtools closest -a F05_unique.bed -d -b commonVariants.txt > F05_unique.bed.closest
