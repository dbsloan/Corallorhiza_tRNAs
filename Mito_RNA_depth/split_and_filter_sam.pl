#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE perl $0 input_sam target_contig output_basename\n\n";

my $sam_file = shift or die ($usage);
my $contig = shift or die ($usage);
my $output = shift or die ($usage);

my $FH = open_file($sam_file);
my $FHO1 = open_output($output . ".fr.sam");
my $FHO2 = open_output($output . ".rf.sam");

while (<$FH>){
	if (substr ($_, 0, 1) eq '@'){
		if (substr ($_, 1, 2) eq 'SQ'){
			if ($_ =~ /$contig/){
				print $FHO1 $_;
				print $FHO2 $_;	
			}
		}else{
			print $FHO1 $_;
			print $FHO2 $_;
		}
		next;
	}
	my @sl = split(/\t/, $_);
	$sl[2] eq $contig or next;

	$sl[1] == 99 and print $FHO1 $_;
	$sl[1] == 147 and print $FHO1 $_;
	$sl[1] == 83 and print $FHO2 $_;
	$sl[1] == 163 and print $FHO2 $_;
	
}

