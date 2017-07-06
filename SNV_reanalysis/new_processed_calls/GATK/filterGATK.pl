use strict;

#read input file 
#expecting combined GATK gVCF (with data from F03, F05, FVB)
my $inputfile = shift || "allSamples.merged.fullData.vcf.gz";

#read in output file root (default: GATK.out)
#this script writes $outFileRoot.out and $outFileRoot.vcf
my $outfileRoot = shift || "GATK.out";


#open and unzip input file
open IN, "gunzip -c $inputfile |" or die $!;

#read through VCF header
my $headerLineCount = 0;
my $line = <IN>;
while ($line !~ /^#CHROM\tPOS/)
{
	$line = <IN>;
	$headerLineCount++;
}

#set cutoffs for quality and coverage
my $qualityCutoff = 300; 
my $coverageCutoff = 23; #measures against each sample's DP tag

#write output to two files: a file with parsed information for each sample, and a file showing the raw vcf lines
open OUT, ">$outfileRoot.out" or die $!;
print OUT "chr\tstart\tqual\tref\talt\tgtF03\trefADF03\taltADF03\tdpF03\tgtF05\trefADF05\taltADF05\tdpF05\tgtFVB\trefADFVB\taltADFVB\tdpFVB\tclass\n";
open VCF, ">$outfileRoot.vcf" or die $!;

#initalize counters
my $readLineCount = 0;
my $lowQualityCount = 0;
my $noSNPCount = 0;
my $indelCount = 0;
my $lenGt1AltCount = 0;
my $lenGt1RefCount = 0;
my $gt1AltCount = 0;
my $sameMutCount = 0;
my $belowCoverageCount = 0;
my $printedCount = 0;

#read through body of VCF
while ($line = <IN>)
{
	$readLineCount++;
	chomp $line;
	my @lineEls = split "\t", $line;

	#skip line if <NON_REF> is the only thing in the alternate allele column
	if ($lineEls[4] eq "<NON_REF>")
	{
		$noSNPCount++;
		next;
	}

	#skip line if the quality doesn't meet the cutoff
	if ($lineEls[5] < $qualityCutoff)
	{
		$lowQualityCount++;
		next;
	}

	#skip line if the length of the reference sequence is longer than 1 nuc
	my $ref = $lineEls[3];
	if (length($ref) > 1)
	{
		$lenGt1RefCount++;
		next;
	}


	#parse alternate alleles
	#lineEls[4] can look like:
	#	A,<NON_REF>
	#	<NON_REF>,A
	#	<NON_REF>,A,T
	#	etc.
	#
	#	@alts holds all original alternate alleles (including <NON_REF>, which can appear as the first alternate allele, or a successive alternate allelelternate alleles, and to keep track of which index ($altInd) the real alternate allele is, for use in parsing the allele depth (AD) below
	#	$alt= the alternate allele (not <NON_REF>)
	#	$altInd = index of alternate allele
	#	$altCount = number of alternate alleles. We can't tell how many alternate alleles there just by the length of @alts because <NON_REF> is one of them 
	my @alts = split ",",$lineEls[4]; 
	my $altCount = 0; 
	my $alt = ""; 
	my $altInd = -1;
	for (my $i = 0; $i < @alts; $i++)
	{
		next if ($alts[$i] eq "<NON_REF>");
		$altInd = $i;
		$alt = $alts[$i];
		$altCount++;
	}

	#skip line if the alternate allele is longer than 1 nucleotide
	if (length($alt) > 1)
	{
		$lenGt1AltCount++;
		next;
	}

	#skip line if there is imore than one alternate allele
	if ($altCount > 1)
	{
		$gt1AltCount++;
		next;
	}


	#increment altInd because the first AD entry is for the reference allele
	$altInd++;

	#parse more pieces of the VCF line
	my $desc = $lineEls[8]; # e.g. GT:DP:GQ:MIN_DP:PL:AD:PGT:PID:SB
	my $tagF03 = $lineEls[10]; # e.g. 0/0:62:73:62:0,73,1483,.,.,.:.:.:.:.
	my $tagF05 = $lineEls[9]; 
	my $tagFVB = $lineEls[11];


	#for this line, find the index of the GT, AD, and DP tags
	my $gtInd = -1; #GT: genotype
	my $adInd = -1; #AD: allelic depths
	my $dpInd = -1; #DP: read depth
	my @descEls = split ":",$desc;
	for (my $i = 0; $i < @descEls; $i++)
	{
		if ($descEls[$i] eq "GT")
		{
			$gtInd = $i;
		}
		elsif ($descEls[$i] eq "AD")
		{
			$adInd = $i;
		}
		elsif ($descEls[$i] eq "DP")
		{
			$dpInd = $i;
		}
	}

	### process F03 ##########################################
	my @tagF03Els = split ":", $tagF03;
	my $gtF03 = $tagF03Els[$gtInd];
	my $dpF03 = $tagF03Els[$dpInd];
	#split AD line to get allelic depths for each genotype
	my @adF03Els = split ",", $tagF03Els[$adInd];
	my $refADF03 = $adF03Els[0];
	my $altADF03 = $adF03Els[$altInd];
	
	#if the gVCF for one sample was in a block matching the reference, merging the vcf will put a 0/0 as the genotype, but not set the reference or alternate allele depths (the tag is '.'). So we'll just assume all reads went to the reference.
	if ($gtF03 eq "0/0" && $tagF03Els[$adInd] eq ".")
	{
		$refADF03 = $dpF03;
		$altADF03 = 0;
	}

	#determine whether F03 has reference or alternate alleles
	my $hasRefF03 = 0;
	my $hasAltF03 = 0;
	if ($gtF03 eq "0/0")
	{
		$hasRefF03 = 1;
	}
	elsif (substr($gtF03,0,1) eq 0) #if the first character is a 0 (could be 0/1 or 0/2 depending on the order of the <NON_REF> allele
	{
		$hasRefF03 = 1;
		$hasAltF03 = 1;
	}
	else
	{
		$hasAltF03 = 1;
	}
	### end process F03 ######################################

	### process F05 ##########################################
	my @tagF05Els = split ":", $tagF05;
	my $gtF05 = $tagF05Els[$gtInd];
	my $hasRefF05 = 0;
	my $hasAltF05 = 0;
	my $dpF05 = $tagF05Els[$dpInd];
	my @adF05Els = split ",", $tagF05Els[$adInd];
	my $refADF05 = $adF05Els[0];
	my $altADF05 = $adF05Els[$altInd];
	if ($gtF05 eq "0/0" && $tagF05Els[$adInd] eq ".")
	{
		$refADF05 = $dpF05;
		$altADF05 = 0;
	}
	my $hasRefF05 = 0;
	my $hasAltF05 = 0;
	if ($gtF05 eq "0/0")
	{
		$hasRefF05 = 1;
	}
	elsif (substr($gtF05,0,1) eq 0)
	{
		$hasRefF05 = 1;
		$hasAltF05 = 1;
	}
	else
	{
		$hasAltF05 = 1;
	}
	### end process F05 ######################################

	### process FVB ##########################################
	my @tagFVBEls = split ":", $tagFVB;
	my $gtFVB = $tagFVBEls[$gtInd];
	my $dpFVB = $tagFVBEls[$dpInd];
	my @adFVBEls = split ",", $tagFVBEls[$adInd];
	my $refADFVB = $adFVBEls[0];
	my $altADFVB = $adFVBEls[$altInd];
	if ($gtFVB eq "0/0" && $tagFVBEls[$adInd] eq ".")
	{
		$refADFVB = $dpFVB;
		$altADFVB = 0;
	}
	my $hasRefFVB = 0;
	my $hasAltFVB = 0;
	if ($gtFVB eq "0/0")
	{
		$hasRefFVB = 1;
	}
	elsif (substr($gtFVB,0,1) eq 0)
	{
		$hasRefFVB = 1;
		$hasAltFVB = 1;
	}
	else
	{
		$hasAltFVB = 1;
	}
	### end process FVB ######################################

	#skip line if any sample has below the minimum coerage
	if ($dpF03 < $coverageCutoff || $dpF05 < $coverageCutoff || $dpFVB < $coverageCutoff)
	{
		$belowCoverageCount++;
		next;
	}

	#skip line if all same genotype
	if ($gtF03 eq $gtF05 && $gtF03 eq $gtFVB)
	{
		$sameMutCount++;
		next;
	}

	#set the class -- which sample has an allele that the other two do not?
	my $class = "";
	if (       ($hasRefF03 && $hasRefF05 && !$hasRefFVB)
		|| ($hasAltF03 && $hasAltF05 && !$hasAltFVB)
		|| (!$hasRefF03 && !$hasRefF05 && $hasRefFVB)
		|| (!$hasAltF03 && !$hasAltF05 && $hasAltFVB))
	{
		$class .= "FVB";
	}
	if (    ($hasRefF03 && !$hasRefF05 && $hasRefFVB)
		|| ($hasAltF03 && !$hasAltF05 && $hasAltFVB)
		|| (!$hasRefF03 && $hasRefF05 && !$hasRefFVB)
		|| (!$hasAltF03 && $hasAltF05 && !$hasAltFVB)
		)
	{
		$class .= "F05";
	}
	if ((!$hasRefF03 && $hasRefF05 && $hasRefFVB)
		|| (!$hasAltF03 && $hasAltF05 && $hasAltFVB)
		|| ($hasRefF03 && !$hasRefF05 && !$hasRefFVB)
		|| ($hasAltF03 && !$hasAltF05 && !$hasAltFVB)
		)
	{
		$class .= "F03";
	}
	
	#printe output to the bed file
	print OUT "$lineEls[0]\t$lineEls[1]\t$lineEls[5]\t$ref\t$alt\t$gtF03\t$refADF03\t$altADF03\t$dpF03\t$gtF05\t$refADF05\t$altADF05\t$dpF05\t$gtFVB\t$refADFVB\t$altADFVB\t$dpFVB\t$class\n";

	#print the line to the vcf reference file
	print VCF $line."\n";
	$printedCount++;

	#uncomment the following line for testing purposes to only process the first 50 lines
#	last if $printedCount > 50;
}
close OUT;

runCommand("tail -n +2 \"$outfileRoot\" > $outfileRoot.tmp; sort -t'\t' -k1,1 -k2n,2  $outfileRoot.tmp > $outfileRoot.sorted");


#create a summary string to print to the output as well as to a .info file
my $infoString = "";
print "Finished\n";
$infoString .= "read $headerLineCount header lines\n";
$infoString .= "read $readLineCount lines\n";
$infoString .= "$noSNPCount had no alternate allele\n";
$infoString .= "$lowQualityCount had no quality < $qualityCutoff\n";
$infoString .= "$lenGt1RefCount had length(ref)>1\n";
$infoString .= "$lenGt1AltCount had length(alt)>1\n";
$infoString .= "$gt1AltCount had >1 alternate alleles\n";
$infoString .= "$sameMutCount had the same mutation\n";
$infoString .= "$belowCoverageCount had coverage < $coverageCutoff in one or more samples\n";
$infoString .= "printed $printedCount\n";
open OUT, ">$outfileRoot.info" or die $!;
print OUT $infoString;
print "$infoString";

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
