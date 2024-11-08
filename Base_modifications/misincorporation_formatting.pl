#!/usr/bin/perl

use strict;
use warnings;
use sloan;

my $usage = "\nperl $0 input_file > output_file\n\n";

my $file = shift or die ($usage);

my @file_lines = file_to_array($file);

shift @file_lines;

my %summary_HoHoH;
my %refbase_HoH;


foreach (@file_lines){
	chomp $_;
	my @sl = split (/\t/, $_);
	
	my $gene = $sl[4];
	my $pos = $sl[5];
	my $ref_base = $sl[6];
	$refbase_HoH{$gene}->{$pos} = $ref_base;
	
	
	if ($ref_base eq "A"){
		$summary_HoHoH{$gene}->{$pos}->{"Reference"} += $sl[7];
		$summary_HoHoH{$gene}->{$pos}->{"C_Mismatch"} += $sl[8];
		$summary_HoHoH{$gene}->{$pos}->{"G_Mismatch"} += $sl[9];
		$summary_HoHoH{$gene}->{$pos}->{"T_Mismatch"} += $sl[10];
		$summary_HoHoH{$gene}->{$pos}->{"Deletion"} += $sl[12];
	}elsif($ref_base eq "C"){
		$summary_HoHoH{$gene}->{$pos}->{"Reference"} += $sl[8];
		$summary_HoHoH{$gene}->{$pos}->{"A_Mismatch"} += $sl[7];
		$summary_HoHoH{$gene}->{$pos}->{"G_Mismatch"} += $sl[9];
		$summary_HoHoH{$gene}->{$pos}->{"T_Mismatch"} += $sl[10];
		$summary_HoHoH{$gene}->{$pos}->{"Deletion"} += $sl[12];
	}elsif($ref_base eq "G"){
		$summary_HoHoH{$gene}->{$pos}->{"Reference"} += $sl[9];
		$summary_HoHoH{$gene}->{$pos}->{"A_Mismatch"} += $sl[7];
		$summary_HoHoH{$gene}->{$pos}->{"C_Mismatch"} += $sl[8];
		$summary_HoHoH{$gene}->{$pos}->{"T_Mismatch"} += $sl[10];
		$summary_HoHoH{$gene}->{$pos}->{"Deletion"} += $sl[12];	
	}elsif($ref_base eq "T"){
		$summary_HoHoH{$gene}->{$pos}->{"Reference"} += $sl[10];
		$summary_HoHoH{$gene}->{$pos}->{"A_Mismatch"} += $sl[7];
		$summary_HoHoH{$gene}->{$pos}->{"C_Mismatch"} += $sl[8];
		$summary_HoHoH{$gene}->{$pos}->{"G_Mismatch"} += $sl[9];
		$summary_HoHoH{$gene}->{$pos}->{"Deletion"} += $sl[12];		
	}else{
		die ("\nERROR: Could not identify ACGT base in the following line:\n$_\n\n");
	}
}

print "Gene\tPosition\tRefBase\tMapStatus\tReadCount\n";

foreach my $gene (sort keys %summary_HoHoH){
	my %internal_HoH = %{$summary_HoHoH{$gene}};
	foreach my $pos (sort {$a <=> $b} keys %internal_HoH){
		my %internal_hash = %{$internal_HoH{$pos}};
		foreach my $map_status (sort keys %internal_hash){
			print "$gene\t$pos\t", $refbase_HoH{$gene}->{$pos}, "\t$map_status\t$internal_hash{$map_status}\n";
		}
	}
}
