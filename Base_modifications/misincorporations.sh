#!/usr/bin/sh

head -1 Corallorhiza-tRNA-base-modification.txt > fungal_genes_modifications.txt

grep fungal Corallorhiza-tRNA-base-modification.txt >> fungal_genes_modifications.txt

perl misincorporation_formatting.pl fungal_genes_modifications.txt > fungal_genes_modifications.long.txt 


#R scipt to generate plots from the above output: misincorp_plots.R
