#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(max);
use sloan;

my $usage = "\nUSAGE perl $0 samtools_depth_file window_size log_floor\n\n";

my $depth_file = shift or die ($usage);
my $window_size = shift or die ($usage);
my $floor = shift or die ($usage);

my $FH = open_file($depth_file);


my $base_count=0;
my $window_sum_fr;
my $window_sum_rf;
my $pos = 0;

print "Position\tStrand\tDepth\tTrans_Depth\n";

while (<$FH>){
	chomp $_;
	my @sl = split (/\t/, $_);
	$pos + 1 == $sl[1] or die ("Base positions are not continuous and starting from 1. Check that samtools depth was run with -a option\n");

	if ($base_count == $window_size){
		print $pos - $base_count/2, "\tFR\t", $window_sum_fr / $base_count, "\t", -1 * log(max($floor, $window_sum_fr / $base_count)) / log(10) , "\n";
		print $pos - $base_count/2, "\tRF\t", $window_sum_rf / $base_count, "\t", log(max($floor, $window_sum_rf / $base_count)) / log(10) , "\n";
		$base_count = 0;
		$window_sum_fr = 0;
		$window_sum_rf = 0;
	}
	
	++$pos;
	++$base_count;
	$window_sum_fr += $sl[2];
	$window_sum_rf += $sl[3];
}
