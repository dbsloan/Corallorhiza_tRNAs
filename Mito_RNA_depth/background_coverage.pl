#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 annotation_file[csv]  flank_seq_length  depth_files[tsv; command line list is white space delimited] > output_dist\n\n";

my $annotation_file = shift or die ($usage);
my $flank_len = shift or die ($usage);

my @depth_file_array;

while (my $next_file = shift){
	push (@depth_file_array, $next_file);
}

@depth_file_array or die ($usage);
my @annotations = file_to_array($annotation_file);

my %depth_hist;

foreach my $depth_file (@depth_file_array){
	
	my @depth_lines = file_to_array ($depth_file);
	my @first_split_line = split (/\t/, $depth_lines[0]);
	my $scaf = $first_split_line[0];
	
	
	my @gene_starts;
	my @gene_ends;
	foreach my $annot (@annotations){
		my @split_annot = split (/\,/, $annot);
		if ($split_annot[0] eq $scaf){
			push (@gene_starts, $split_annot[1] - $flank_len);
			push (@gene_ends, $split_annot[2] + $flank_len);
		}
	}
	
	foreach (@depth_lines){
		chomp $_;
		my @sl = split (/\t/, $_);
		my $in_gene = 0;
		for (my $i = 0; $i < scalar(@gene_starts); ++$i){
			if ($sl[1] >= $gene_starts[$i] and $sl[1] <= $gene_ends[$i]){
				$in_gene = 1;
				last;
			}
		}
		$in_gene and next;
		++$depth_hist{$sl[2]};
		++$depth_hist{$sl[3]};
	}	
}


print "Depth\tSite_count\n";
for (sort {$a <=> $b} keys %depth_hist){
	print "$_\t$depth_hist{$_}\n";
}