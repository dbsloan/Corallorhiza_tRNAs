#!/usr/bin/sh

#the following script reports a distribution of site-specific coverage depths, excluding annotated genes and a specified amount of flanking sequence around each gene (3000 bp in this case)

perl background_coverage.pl annotation.csv 3000 depth_plots/Scaffold*.depth.txt > intergenic_background/background_hist.txt