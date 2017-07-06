use strict;
my $infile = shift || "GATK.out.sorted";

my $sortedBed = "$infile.sorted.bed";
runCommand("tail -n +2 \"$infile\" > $infile.tmp; sort -t'\t' -k1,1 -k2n,2  $infile.tmp > $infile.sorted; perl makeBed.pl $infile.sorted; rm $infile.tmp") unless -e $sortedBed;

#first, create annotation file using bedtools
my $dbSNPFile = "threeSNPsets.bed.sorted.bed";
my $commonF03F05File = "intersect_treatedF03_normalFVB__treatedF05_normalFVB.bed.filt.bed";
my $flippedF03File = "treatedFVB_normalF03.bed.filt.bed";
my $flippedF05File = "treatedFVB_normalF05.bed.filt.bed";

my %inDBSNP = ();
my %inF03F05 = ();
my %inFlippedF03 = ();
my %inFlippedF05 = ();

my $dbSNPAnnoFile = "$sortedBed.anno.dbSNP";
runCommand("bedtools closest -d -t first -a $sortedBed -b $dbSNPFile > $dbSNPAnnoFile") unless  -e $dbSNPAnnoFile;
open IN, $dbSNPAnnoFile or die $!;
while (my $line = <IN>)
{
	chomp $line;
	my @lineEls = split "\t", $line;
	$inDBSNP{"$lineEls[0] $lineEls[1]"}++ if $lineEls[-1] == 0;
}
close IN;

my $F03F05AnnoFile = "$sortedBed.anno.F03F05";
runCommand("bedtools closest -d -t first -a $sortedBed -b $commonF03F05File > $F03F05AnnoFile") unless  -e $F03F05AnnoFile;
open IN, $F03F05AnnoFile or die $!;
while (my $line = <IN>)
{
	chomp $line;
	my @lineEls = split "\t", $line;
	$inF03F05{"$lineEls[0] $lineEls[1]"}++ if $lineEls[-1] == 0;
}
close IN;

my $flippedF03AnnoFile = "$sortedBed.anno.flippedF03";
runCommand("bedtools closest -d -t first -a $sortedBed -b $flippedF03File > $flippedF03AnnoFile") unless  -e $flippedF03AnnoFile;
open IN, $flippedF03AnnoFile or die $!;
while (my $line = <IN>)
{
	chomp $line;
	my @lineEls = split "\t", $line;
	$inFlippedF03{"$lineEls[0] $lineEls[1]"}++ if $lineEls[-1] == 0;
	if ($lineEls[0] eq "chr1" && $lineEls[1] eq "155319210")
	{
	}
}
close IN;

my $flippedF05AnnoFile = "$sortedBed.anno.flippedF05";
runCommand("bedtools closest -d -t first -a $sortedBed -b $flippedF05File > $flippedF05AnnoFile") unless  -e $flippedF05AnnoFile;
open IN, $flippedF05AnnoFile or die $!;
while (my $line = <IN>)
{
	chomp $line;
	my @lineEls = split "\t", $line;
	$inFlippedF05{"$lineEls[0] $lineEls[1]"}++ if $lineEls[-1] == 0;
}
close IN;

open IN, $infile or die $!;
open KNOWN, ">$infile.dbSNP" or die $!;
open KNOWNBED, ">$infile.dbSNP.bed" or die $!;
open NOVEL, ">$infile.novel" or die $!;
open NOVELBED, ">$infile.novel.bed" or die $!;
open NOTF03F05BED, ">$infile.notF03F05.bed" or die $!;
open ANNO, ">$infile.anno" or die $!;

my $readCount = 0;
my $multiClassCount = 0;
my $qualCutoff = 300;
my $belowQualityCount = 0;
my $covCutoff = 23;
my $belowCoverageCount = 0;
my $knownCount = 0;
my $novelCount = 0;
my $notAtF03F05Count = 0;

my $head = <IN>;
chomp $head;
print KNOWN "$head\n";
print NOVEL "$head\n";
print ANNO "$head\tinDbSNP\tinF03F05\tinFlippedF03\tinFlippedF05\n";
my $countAtDBSNP = 0;
my $countAtF03F05 = 0;
my $countAtFlippedF03 = 0;
my $countAtFlippedF05 = 0;
while (my $line = <IN>)
{
	$readCount++;
	chomp $line;
	my @lineEls = split "\t", $line;

	my $qual = $lineEls[2];
	if ($qual < $qualCutoff)
	{
		$belowQualityCount++;
		next;
	}
	my $covF03 = $lineEls[8];
	my $covF05 = $lineEls[12];
	my $covFVB = $lineEls[16];
	if ($covF03 < $covCutoff || 
		$covF05 < $covCutoff || 
		$covFVB < $covCutoff)
	{
		$belowCoverageCount++;
		next;
	}




	#classes were assigned on which sample had the 'different' genotype
	#sometimes, in cases of 0/0 0/1 and 1/1, it assigns two samples with
	# 'different genotypes' so I discard these ambiguous SNPs
	my $class = $lineEls[-1];
	if (length($class) > 3,)
	{
		$multiClassCount++;
		next;
	}


	my $isAtDBSNP = 0;
	if (exists ($inDBSNP{"$lineEls[0] $lineEls[1]"}))
	{
		$isAtDBSNP = 1;
		$countAtDBSNP++;
	}
	my $isAtF03F05 = 0;
	if (exists ($inF03F05{"$lineEls[0] $lineEls[1]"}))
	{
		$isAtF03F05 = 1;
		$countAtF03F05++;
	}
	my $isAtFlippedF03 = 0;
	if (exists ($inFlippedF03{"$lineEls[0] $lineEls[1]"}))
	{
		$isAtFlippedF03 = 1;
		$countAtFlippedF03++;
	}
	my $isAtFlippedF05 = 0;
	if (exists ($inFlippedF05{"$lineEls[0] $lineEls[1]"}))
	{
		$isAtFlippedF05 = 1;
		$countAtFlippedF05++;
	}

	if ($isAtDBSNP)
	{
		$knownCount++;
		print KNOWN $line."\n";;
		my $end = $lineEls[1] + 1;
		print KNOWNBED "$lineEls[0]\t$lineEls[1]\t$end\t$class\n";
	}
	else {
		$novelCount++;
		print NOVEL $line."\n";
		my $end = $lineEls[1] + 1;
		print NOVELBED "$lineEls[0]\t$lineEls[1]\t$end\t$class\n";
	}

	if (!$isAtF03F05)
	{
		$notAtF03F05Count++;
		my $end = $lineEls[1] + 1;
		print NOTF03F05BED "$lineEls[0]\t$lineEls[1]\t$end\t$class\n";
	}
	print ANNO "$line\t$isAtDBSNP\t$isAtF03F05\t$isAtFlippedF03\t$isAtFlippedF05\n";

}

my $infoString = "";
$infoString .= "Read $readCount lines\n";
$infoString .= "Discarded $multiClassCount multi-class SNPs\n";
$infoString .= "Discarded $belowQualityCount SNPs with qual < $qualCutoff\n";
$infoString .= "Discarded $belowCoverageCount SNPs with qual < $covCutoff\n";
$infoString .= "Printed $knownCount known (in dbSNP) SNPs\n";
$infoString .= "Printed $novelCount novel SNPs\n";
$infoString .= "Printed $notAtF03F05Count SNPs not at F03F05\n";
$infoString .= "$countAtDBSNP SNPs at DBSNP $dbSNPFile\n";
$infoString .= "$countAtF03F05 SNPs at F03F05 $commonF03F05File\n";
$infoString .= "$countAtFlippedF03 SNPs at flippedF03 $flippedF03File\n";
$infoString .= "$countAtFlippedF05 SNPs at flippedF05 $flippedF05File\n";
open INFO, ">$infile.info" or die $!;
print INFO $infoString;
print $infoString;

sub runCommand
{
	my $command = shift;
	my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
	$minute = sprintf("%02d",$minute);
	$second = sprintf("%02d",$second);
	print "$hour:$minute:$second\n$command\n";
	print `$command 2>&1`;
	my $exit_value  = $? >> 8;
	my $signal_num  = $? & 127;
	my $dumped_core = $? & 128;
	if ($exit_value)
	{
		print "========\nJob failed\n========\n";
		print "Exit value: $exit_value\n";
		print "Signal num: $signal_num\n";
		print "Dumped core: $dumped_core\n";
		die;
	}
}
