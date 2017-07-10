use strict;
my $vcfFile = shift;
die "usage: perl filter.pl {vcf.gz}" if $vcfFile eq "" || !-e $vcfFile;

open IN, "gunzip -c $vcfFile |" or die $!;

my $line = <IN>;
my $headerLinesCount = 0;
while ($line !~ /^#CHROM\tPOS/)
{
	$line = <IN>;
	$headerLinesCount++;
}

my $qualityCutoff = 20;
my $coverageCutoff = 10;

my $readLineCount = 0;
my $hasSnpCount = 0;
my $hiQualityCount = 0;
my $hetCount = 0;
while ($line = <IN>)
{
	chomp $line;
	$readLineCount++;

	my @lineEls = split "\t", $line;
	next if $lineEls[4] eq "<NON_REF>";
	$hasSnpCount++;

	next if ($lineEls[5] < $qualityCutoff);
	$hiQualityCount++;

	my $desc = $lineEls[8];
	my $tag = $lineEls[9];


	if (substr($desc,0,2) ne "GT")
	{
		die "didn't get genotype at $desc\n";
	}

	my $g1 = substr($tag,0,1);
	my $g2 = substr($tag,2,1);
	if ($g1 ne $g2)
	{
		$hetCount++;
	}
}

print "read $headerLinesCount header lines\n";
print "read $readLineCount lines\n";
print "got $hasSnpCount lines with SNPs\n";
print "got $hiQualityCount lines passing quality (>$qualityCutoff)\n";
print "got $hetCount hets\n";
