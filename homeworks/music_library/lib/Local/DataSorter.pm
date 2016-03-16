package DataSorter;

use strict;
use warnings;

use Data::Dumper qw(Dumper);

my $sort = '0';

sub SetSorterOption() {
	$sort = $_[0];
}



sub Sort { 

	if ($sort eq '0') {return @_};

	#мою структуру нужно в лист сделать	

	#my @t = ([4, 0, 0, 0, 0, 1999], [3, 0, 0, 0, 0, 2015], [7, 0, 0, 0, 0, 2000]);
	my @t = @_;

	#print Dumper \@t;

	if ($sort eq 'year')
		{ @t = sort { $a->[5]+0 <=> $b->[5]+0 } @t };
	if ($sort eq 'format')
		{ @t = sort { $a->[4] cmp $b->[4] } @t };
	if ($sort eq 'track')
		{ @t = sort { $a->[3] cmp $b->[3] } @t };
	if ($sort eq 'album')
		{ @t = sort { $a->[2] cmp $b->[2] } @t };
#	if ($sort eq 'year')
#		{ @t = sort { $a->[1] cmp $b->[1] } @t };
	if ($sort eq 'band')
		{ @t = sort { $a->[0] cmp $b->[0] } @t };

	#print Dumper \@t;

	return @t;
}

1;