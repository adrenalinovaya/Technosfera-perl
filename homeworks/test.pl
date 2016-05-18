#!/usr/bin/env perl

use strict;
use warnings;

use Mojo::UserAgent;
use Mojo::URL;

##open file to store links
open my $log, '>', 'D:\Perl\Technosfera-perl-master_new\Technosfera-perl-master\homeworks\crowler\crowler\extracted_links.txt' or die $!;

##starting URL
my $base = Mojo::URL->new('http://stackoverflow.com/');
my @urls = $base;

my $ua = Mojo::UserAgent->new;
my %visited;
my $url_count = 0;

while (@urls) {
  my $url = shift @urls;
  next if exists $visited{$url};

  print "$url\n";
  print $log "$url\n";

  $visited{$url} = 1;
  $url_count++;         

  # find all <a> tags and act on each
  $ua->get($url)->res->dom('a')->each(sub{
    my $url = Mojo::URL->new($_->{href});
    if ( $url->is_abs ) {
      return unless $url->host eq $base->host;
    }
    push @urls, $url;
  });

  last if $url_count == 100;

  sleep 1;
}