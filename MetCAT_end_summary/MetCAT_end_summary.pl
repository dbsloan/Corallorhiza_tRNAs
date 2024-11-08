#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nUSAGE: perl $0 sam_file >> output.txt\n\n";

my $file = shift or die ($usage);

my $FH = open_file ($file);


my $read_count = 0;
my $CCA_count = 0;
my $CA_count = 0;

while (<$FH>){
	$_ =~ /^\@/ and next;
	$_ =~ /mitochondrial\_fungal\-Cma\-MetCAT\-19/ or next;
	
	++$read_count;
	my @sl = split (/\t/, $_);
	if (substr ($sl[9], -4) eq "CCCA"){
		++$CCA_count;
	}elsif(substr ($sl[9], -3) eq "CCA"){
		++$CA_count;	
	}
}

print "$file\t$read_count\t$CCA_count\t$CA_count\n";
