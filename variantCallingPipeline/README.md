<br><br>

# Scripts used for variant calling

**Contact:** [Caleb Lareau](mailto:caleblareau@g.harvard.edu)

##Execution order:

- 1. align/sort-- `alignBWA.sh`
- 2. remove duplicates-- `removeDuplicates.sh`
	- a. add read groups for base recalibration-- `addReadGroup.sh, baseRecalibrator1.sh, baseRecalibrator2.sh`
- 3a. variant calling with Lofreq -- `lofreqCommads.sh`
- 3b. variant calling with Mutect
- 3c. variant calling with Strelka

<br><br>