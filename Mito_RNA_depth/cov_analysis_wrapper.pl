#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 scaffold_list_file sam_file window_size min_cov\n\n";

my $scaf_file = shift or die ($usage);
my $sam_file = shift or die ($usage);
my $window_size = shift or die ($usage);
my $min_cov = shift or die ($usage);

my @scaf_lines = file_to_array($scaf_file);

foreach (@scaf_lines){
	chomp $_;
	my @sl = split (/\t/, $_);
	system ("perl  split_and_filter_sam.pl $sam_file $sl[0] $sl[1]");
	system ("samtools sort -o $sl[1]\.fr.bam $sl[1]\.fr.sam");
	system ("samtools sort -o $sl[1]\.rf.bam $sl[1]\.rf.sam");
	system ("samtools depth -a -o $sl[1]\.depth.txt $sl[1]\.fr.bam $sl[1]\.rf.bam") ;
	system ("perl sliding_window_depth.pl $sl[1]\.depth.txt $window_size $min_cov > $sl[1]\.SW.txt");
}

