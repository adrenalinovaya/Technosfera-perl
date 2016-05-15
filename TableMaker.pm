package TableMaker;

#use strict;
use warnings;
use Data::Dumper qw(Dumper);

my @data;
my $lines = 0;
my %cols_s; #colums sizes
my $cols_cnt = 0; #columns count to be displayed

my @cols_to_show;

#input is a string of columns
#band,year,album,track,format
#band,year
#band,year,year
#band,band,format
#todo realize function in order to display table as user require in parameter
sub SetShowOption {
	@cols_to_show = split(',', $_[0]);
	#print Dumper \@cols_to_show;	
	$cols_cnt = scalar @cols_to_show;
}

sub SetData {
	if ($cols_cnt == 1) {return};
	$lines = scalar @_;	
	my @s = (0,0,0,0,0);
	my %elem;
	#stupid code in order to count column sizes
	for (my $i = 0; $i < $lines; $i++) {
		if (length($_[$i][0]) > $s[0]) {$s[0] = length($_[$i][0])};
		if (length($_[$i][1]) > $s[1]) {$s[1] = length($_[$i][1])};
		if (length($_[$i][2]) > $s[2]) {$s[2] = length($_[$i][2])};
		if (length($_[$i][3]) > $s[3]) {$s[3] = length($_[$i][3])};
		if (length($_[$i][4]) > $s[4]) {$s[4] = length($_[$i][4])};

		for (my $j = 0; $j < scalar @cols_to_show; $j++)
		{
			my $d;
			if ($cols_to_show[$j] eq "band") { $d = $_[$i][0] };
			if ($cols_to_show[$j] eq "year") { $d = $_[$i][1] };
			if ($cols_to_show[$j] eq "album") { $d = $_[$i][2] };
			if ($cols_to_show[$j] eq "track") { $d = $_[$i][3] };
			if ($cols_to_show[$j] eq "format") { $d = $_[$i][4] };
			$data[$i][$j] = $d;
		};
	}
	%cols_s = ( "band", $s[0],
			"year", $s[1],
			"album", $s[2],
			"track", $s[3],
			"format", $s[4] );

	#print Dumper \%cols_s;

#	print "$s[0] $s[1] $s[2] $s[3] $s[4] $s[5]";
}

sub DisplayResults { 

	if ($lines == 0 || $cols_cnt == 1) {return};

	my $tw = 2 + 3 * ($cols_cnt-1);
	foreach (@cols_to_show) {$tw += $cols_s{$_}};
	#header
	print "/";
	print "-" x $tw;
	print "\\\n";

#print Dumper \@cols_to_show;
#print $cols_s{ $cols_to_show[0] };
#print $cols_s{ "format" };
#print Dumper \%cols_s;



	for (my $i = 0; $i < $lines; $i++){
		print "| ";
		for (my $j = 0; $j < $cols_cnt; $j++){
			print " " x ($cols_s { $cols_to_show[$j] } - length( $data[$i][$j]));
			print $data[$i][$j];
			if ($j != $cols_cnt-1){
				print " | ";
			}
		}
		print " |\n";
		if ($i != $lines - 1){
			print "|";
			for (my $k = 0; $k < $cols_cnt; $k++){
				print "-" x ($cols_s { $cols_to_show[$k] } + 2);
				if ($k != $cols_cnt-1){
					print "+";
				}
			}
			print "|\n";
		}
	}
	
	#footer
	print "\\";
	print "-" x $tw;
	print "/\n";
}


1;