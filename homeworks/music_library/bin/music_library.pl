#!/usr/bin/env perl

use strict;
use warnings;
use lib "./lib/local";
use lib "./../lib/local";
require LineReader;
require DataSorter;
require TableMaker;
use Getopt::Long;

my @t;
my @s;
#parameters
my $band = '0';
my $year = '0';
my $album = '0';
my $track = '0';
my $format = '0';
my $sort = '0';
my $columns = '0';

GetOptions (
'band=s' => \$band, 
'year=s' => \$year, 
'album=s' => \$album, 
'track=s' => \$track, 
'format=s' => \$format, 
'sort=s' => \$sort, 
'columns=s' => \$columns
);
if ($columns eq '0') {$columns = "band,year,album,track,format"}

#print "$band $year $album $track $format $sort $columns";

#due to windows 8 and\or strawberry error with piping I will load tests manually and manually compare them with result
#so I will make work of Test::More package
#load a test data and filter it
LineReader::SetFilterOptions($band, $year, $album, $track, $format);
#@t  = LineReader::AddLine("db1.txt");
while (<>) {
	LineReader::AddLine($_);
}
@t  = LineReader::GetRes();

#sort the data and get sizes
DataSorter::SetSorterOption($sort);
@t = DataSorter::Sort(@t);

#display a table
TableMaker::SetShowOption($columns);
TableMaker::SetData(@t);
TableMaker::DisplayResults();