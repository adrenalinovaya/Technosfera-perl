#!/usr/bin/env perl

use Data::Dumper;

use strict;
use warnings;
 
use AnyEvent;
use AnyEvent::HTTP;
 
my $baseURL = "http://newrezume.org/news/2016-06-05-14765";
my @urls = $baseURL;
my %visited;
my $url_count = 0;


 
while (@urls) {
	my $url = shift @urls;
	next if exists $visited{$url};

	my $cv = AnyEvent->condvar;
	#print "Start $url" . "\n";
	$cv->begin;
	http_get $url, sub {
		my ($html) = @_;
		my $l = length $html;
		#print "$url received, Size: " . $l . "\n" ;
		$visited{$url} = $l;
		$url_count++;

		#просканировать html и взять все ссылки 
		while( $html =~ m/<a[^>]*?href=\"([^>]*?)\"[^>]*?>\s*([\w\W]*?)\s*<\/a>/igs )
		{   
		    	#print "before " . $1 . "\n";
			if (substr($1, 0, 6) ne 'mailto' 
			&& substr($1, 0, 4) ne 'java' 
			&& $1 ne '/'
			&& not(substr($1, length ($1) - 3, 3) ~~ ['zip', 'pdf']) #плохо, т.к. нужно перечислить все расширения web страниц, либо парсить ответ от сервера, чтобы понять, что за контент
			&& substr($1, 0, 4) ne 'http' #не абсолютная ссылка, чтобы не уйти на другой сайт, как по-другому не знаю
			) { 
				#print "to add ". $1 . "\n";
				push @urls, $baseURL.$1; 
			}
		}

		$cv->end;
	};
	$cv->recv;
	last if $url_count == 100;
}


#анализируем результаты работы
#print Dumper %visited;

my $total = 0;
my $i = 0;
for my $key (sort { $visited{$a} <=> $visited{$b} } keys %visited )
{  
	my $s = $visited{$key};
   	$total += $s;
	if ($i < 10) {
		print $key . " size is " . $s . "\n";
		$i++;
	}
}

print "total size " . $total . "\n";