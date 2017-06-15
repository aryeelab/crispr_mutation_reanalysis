use strict;
#my $windowSize = 100000000;
my $windowSize = 10000000;
#my $windowSize = 5000000;
my $slideSize = $windowSize/5;

my $chromSizesFile = "/home/unix/kendell/workDir/genomes/mm10/mm10.chrom.sizes";
my %chromSizes = ();
my %data = ();
open IN, $chromSizesFile or die $!;
while (my $line = <IN>)
{
	chomp $line;
	my @lineEls = split "\t", $line;
	$chromSizes{$lineEls[0]} = $lineEls[1];

	for (my $i = 0; $i < $lineEls[1]; $i+=$windowSize)
	{
		$data{$lineEls[0]}{int($i/$windowSize)} = 0;
	}
}
close IN;

my $file = shift;
open IN, $file or die $!;

while (my $line = <IN>)
{
	next if $line =~ /Start/;
	my @lineEls = split /\s+/, $line;
	my $chr = $lineEls[0];
	$chr = "chr$chr" unless $chr =~ /chr/;
	my $start = $lineEls[1];
	my $startVal = $start - $windowSize;
	$startVal = int($startVal/$slideSize) + 1;
	$startVal = 0 if $startVal < 0;
	my $endVal = $start + $windowSize;
	$endVal = $chromSizes{$chr} if $endVal > $chromSizes{$chr};
	$endVal = int($endVal/$slideSize);

	for (my $i = $startVal ; $i <= $endVal; $i++)
	{
		$data{$chr}{$i}++;
	}
}

my $outfile = "$file.density";
open OUT, ">$outfile" or die $!;

my $bedOut = "$file.bed";
open BED, ">$bedOut" or die $!;

my @chrs = sort keys %data;
foreach my $chr (@chrs)
{
	my @inds = sort {$a <=> $b} keys %{$data{$chr}};
	foreach my $ind (@inds)
	{
		print OUT "$chr\t$ind\t$data{$chr}{$ind}\n";
		my $start = $ind * $slideSize;
		my $end = $start + $slideSize;
		$end = $chromSizes{$chr} if $end > $chromSizes{$chr};
		print BED "$chr\t$start\t$end\t$data{$chr}{$ind}\n";
	}
}
print "printed $outfile\n";
