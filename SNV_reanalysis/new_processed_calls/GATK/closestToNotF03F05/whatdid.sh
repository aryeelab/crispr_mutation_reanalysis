ln -sf ../GATK.out.notF03F05.bed commonVariants.txt
bedtools closest -t first -a ../intersect_treatedF03_normalFVB__treatedF05_normalFVB.bed.filt.bed -d -b commonVariants.txt > intersect_treatedF03_normalFVB__treatedF05_normalFVB.bed.filt.bed.closest

bedtools closest -t first -a ../treatedF03_normalFVB.bed.filt.bed -d -b commonVariants.txt > treatedF03_normalFVB.bed.filt.bed.closest

bedtools closest -t first -a ../treatedF05_normalFVB.bed.filt.bed -d -b commonVariants.txt > treatedF05_normalFVB.bed.filt.bed.closest


bedtools intersect -v -a ../treatedF03_normalFVB.bed.filt.bed -b ../treatedF05_normalFVB.bed.filt.bed > F03_unique.bed
bedtools closest -t first -a F03_unique.bed -d -b commonVariants.txt > F03_unique.bed.closest

bedtools intersect -v -a ../treatedF05_normalFVB.bed.filt.bed -b ../treatedF03_normalFVB.bed.filt.bed > F05_unique.bed
bedtools closest -t first -a F05_unique.bed -d -b commonVariants.txt > F05_unique.bed.closest

