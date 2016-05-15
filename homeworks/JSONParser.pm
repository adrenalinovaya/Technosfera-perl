package Local::JSONParser;

use strict;
use warnings;
use base qw(Exporter);

use Data::Dumper qw(Dumper);
use JSON::XS;

our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );


sub parse_json {
	my $source = shift;
	my $q = JSON::XS->new->utf8->decode($source);
	
	#убрать скобки в начале и в конце текста
	my $s = substr $source, 1, length($source);
	$s = substr $s, 0, length($s) - 1;
	my $source1 = substr $source, 0, 1;
	my $s1  = $s;
	$s1 =~ s/^\s+|\s+$//g;
	my @strs;
	if ($s1 eq "[]" || $s1 eq "{}") #обработка вложенных пустых массивов и хешей
	{
		@strs[0] = $s1;
	}
	else
	{
	#разбить на подстроки по запятым
	#если перед запятой цифра или " или } или ] и ранее не было знака { или [
	
	#@strs = $s =~ /[^{}\s]+ | \{ (?: (?R) | [^{}]+ )+ \} /gx;
	#@strs = $s =~ /[^\[\]\s]+ | \[ (?: (?R) | [^\[\]]+ )+ \] /gx;
	@strs = $s =~ /[^\[\]\{\},:]+ | [\[\{] (?: (?R) | [^\[\]\{\}]+ )+ [\]\}] /gx;
	}

	#print Dumper \@strs;

	my $al = scalar @strs;
#	print $al;
	my $i = 0;
	while ($i < $al)
	{ 
		my $t = $strs[$i];
		$t =~ s/^\s+|\s+$//g;
		if ($t eq "")
		{
			splice @strs, $i, 1;
			$al = scalar @strs;
		}
		else
		{
			$i++;
		}
	}
	#print $al;
	#print Dumper \@strs;

	$al = scalar @strs;

	#JSON записан как хэш
	if ($source1 eq "{") 
	{

	my %h1 = ();
	my $h2 = \%h1;

	$i = 0;
	while ($i < $al)
	{ 
		my $k = $strs[$i];
		my $v = $strs[$i+1];
		$k =~ s/^\s+|\s+$//g;
		$v =~ s/^\s+|\s+$//g;

		my $t = $k . " " . $v . " !" . substr($v, 0, 1) . "!";
		#print $t;
		#print "\n";

		if (substr($v, 0, 1) eq "[")
		{
			#print "this is array";
			my $k1 = substr($k, 1, length($k) - 2);
			$h1{$k1} = [];
			my $v1 = substr($v, 1, length($v) - 2);
			my @q = split ",", $v1;
			for (my $i = 0; $i < scalar @q; $i++)
			{
				$q[$i] =~ s/^\s+|\s+$//g;
				if ($q[$i] =~ m/^[-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+(?:\.\d*)?)?$/ )
				{
					$h1{$k1}[$i] = $q[$i]+0;
				}
				else
				{
					$h1{$k1}[$i] = substr($q[$i], 1, length($q[$i]) - 2);
				}
			}
		}
		elsif (substr($v, 0, 1) eq "{")
		{
			#print "this is hash";
			my $k1 = substr($k, 1, length($k) - 2);
			$h1{$k1} = {};
			my $v1 = substr($v, 1, length($v) - 2);
			my @q = split ",", $v1;
			for (my $i = 0; $i < scalar @q; $i++)
			{
				$q[$i] =~ s/^\s+|\s+$//g;
				my @q2 = split ":", $q[$i];

				$q2[0] =~ s/^\s+|\s+$//g;
				$q2[1] =~ s/^\s+|\s+$//g;
				$q2[0] = substr($q2[0], 1, length($q2[0]) - 2);
			 	$q2[1] = substr($q2[1], 1, length($q2[1]) - 2);

				if ($q2[1] =~ m/^[-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+(?:\.\d*)?)?$/ )
				{
					$h1{$k1}{$q2[0]} = $q2[1]+0;
				}
				else
				{
					$h1{$k1}{$q2[0]} = $q2[1];
				}
			}
		}
		elsif (substr($v, 0, 1) eq "\"")
		{
			#print "this is string";
			my $k1 = substr($k, 1, length($k) - 2);
			my $v1 = substr($v, 1, length($v) - 2);
			$h1{$k1} = $v1;
		}
		else 
		{
			#print "this is number";
			my $k1 = substr($k, 1, length($k) - 2);
			$h1{$k1} = $v+0;
		}

		$i = $i + 2;
	}
	#print Dumper $h2;
	return $h2;

	} 
	#JSON записан как хэш

	#JSON записан как массив
	elsif ($source1 eq "[") 
	{
	my @h1 = [];
	my $h2 = \@h1;

	#print $al;
	if ($al == 0)
	{
		#print Dumper [];
		return [];
	}

	$i = 0;
	while ($i < $al)
	{ 
		my $v = $strs[$i];
		$v =~ s/^\s+|\s+$//g;

		my $t = $v . " !" . substr($v, 0, 1) . "!";
		#print $t;
		#print "\n";

		if (substr($v, 0, 1) eq "[")
		{
			#print "this is array";
			$h1[$i] = [];
			my $v1 = substr($v, 1, length($v) - 2);
			my @q = split ",", $v1;
			for (my $i1 = 0; $i1 < scalar @q; $i1++)
			{
				$q[$i] =~ s/^\s+|\s+$//g;
				if ($q[$i] =~ m/^[-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+(?:\.\d*)?)?$/ )
				{
					$h1[$i][$i1] = $q[$i1]+0;
				}
				else
				{
					$h1[$i][$i1] = substr($q[$i1], 1, length($q[$i1]) - 2);
				}
			}
		}
		elsif (substr($v, 0, 1) eq "{")
		{
			#print "this is hash";
			$h1[$i] = {};
			my $v1 = substr($v, 1, length($v) - 2);
			
			my @q = split ",", $v1;
			#плохо, иногда запятая может быть не в том месте где надо

			for (my $i = 0; $i < scalar @q; $i++)
			{
				$q[$i] =~ s/^\s+|\s+$//g;
				my @q2 = split ":", $q[$i];

				$q2[0] =~ s/^\s+|\s+$//g;
				$q2[1] =~ s/^\s+|\s+$//g;
				$q2[0] = substr($q2[0], 1, length($q2[0]) - 2);
			 	$q2[1] = substr($q2[1], 1, length($q2[1]) - 2);

				if ($q2[1] =~ m/^[-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+(?:\.\d*)?)?$/ )
				{
					$h1[$i]{$q2[0]} = $q2[1]+0;
				}
				else
				{
					$h1[$i]{$q2[0]} = $q2[1];
				}
			}
		}
		elsif (substr($v, 0, 1) eq "\"")
		{
			#print "this is string";
			my $v1 = substr($v, 1, length($v) - 2);
			$h1[$i] = $v1;
		}
		else 
		{
			#print "this is number";
			$h1[$i] = $v+0;
		}

		$i = $i + 1;
	}
#	print Dumper $h2;
	return $h2;
	}
	#JSON записан как массив
}

1;
