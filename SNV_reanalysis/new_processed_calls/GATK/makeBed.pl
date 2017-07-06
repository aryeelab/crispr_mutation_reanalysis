use strict;

my $file = shift;
open IN, $file or die $!;
open OUT, ">$file.bed" or die $!;

#if it has a header, get rid of it
my $head = <IN>;
if ($head =~ /chr1/)
{
	seek IN, 0,0;
}

while (my $line = <IN>)
{
	chomp $line;
	my @lineEls = split "\t", $line;

	my $end = $lineEls[1] + 1;
	print OUT "$lineEls[0]\t$lineEls[1]\t$end\n";
}
