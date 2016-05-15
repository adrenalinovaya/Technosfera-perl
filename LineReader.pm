package LineReader;

use strict;
use warnings;

use Data::Dumper qw(Dumper);

#copied from  the Internet )
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

#Путь к каждому файлу стандартизирован: `./группа/год - альбом/трек.формат`.
my @t;
my @t1;
my $i = 0;

my $bandf = '0';
my $yearf = '0';
my $albumf = '0';
my $trackf = '0';
my $formatf = '0';

sub GetRes { return @t1 }

sub SetFilterOptions {
	$bandf = $_[0];
	$yearf = $_[1];
	$albumf = $_[2];
	$trackf = $_[3];
	$formatf = $_[4];
}

#sub LoadTestFile { 
sub AddLine {
	my $group = '0';
	my $year = '0';
	my $yearv = 0;
	my $album = '0';
	my $track = '0';
	my $ext = '0';

#	open FILE, $_[0] or die $!;
#	while (<FILE>) {
	
		#$_ =~ m{
				#^
				#\. /
				#(?<band>[^/]+)
				#/
				#(?<year>\d+)
				#\s+ - \s+
				#(?<album>[^/]+)
				#/
				#(?<track>.+)
				#\.
				#(?<format>[^\.]+)
				#$
				#}x;

				#$group = $+{band};
				#$year = $+{year};
				#$album = $+{album};
				#$track = $+{track};
				#$ext = $+{format};
				#use DDP; p %+;

	#print $_;
				

				@t = split('/', $_);
				
				#print Dumper \@t;
				
			    $group = trim(substr($t[1], 0, length($t[1])));
				$year = trim((split('-', $t[2]))[0]);

				#some logic in order to treat year string value correctly
				$yearv = $year + 0;

				$album = trim((split('-', $t[2]))[1]);
				$track = trim((split('\.', $t[3]))[0]);
				$ext = trim((split('\.', $t[3]))[1]);
				#./Dreams Of Sanity/1999 - Masquerade/The Phantom of the Opera.mp3
		#		print "$group $year $album $track $ext yaro";
		#		print "\n";
		#		print "$bandf $yearf $albumf $trackf $formatf";
		#		print "\n";

				#do not know how to do it better, want sleep
				my $f1 = 0;
				my $f2 = 0;
				if ($bandf ne '0'){
					$f1++;
					if ($bandf eq $group){ $f2++ }
				}
				if ($yearf != 0){
					$f1++;
					if ($yearf == $year){ $f2++ }
				}
				if ($albumf ne '0'){
					$f1++;
					if ($albumf eq $album){ $f2++ }
				}
				if ($trackf ne '0'){
					$f1++;
					if ($trackf eq $track){ $f2++ }
				}
				if ($formatf ne '0'){
					$f1++;
					if ($formatf eq $ext){ $f2++ }
				}

				if ($f1 == $f2) {
					$t1[$i][0] = $group;
					$t1[$i][1] = $year;
					$t1[$i][2] = $album;
					$t1[$i][3] = $track;
					$t1[$i][4] = $ext;
					$t1[$i][5] = $yearv;
					$i++;
				}
		
#	};
#			return @t1;

}

1;