#!/usr/bin/sh


#bowtie v2.2.5
bowtie2-build Corallorhiza_organelle_ref.fas Corallorhiza_organelle_ref.fas


#samtools v1.17
samtools faidx Corallorhiza_organelle_ref.fas


#cutadapt v4.0
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --minimum-length 50 -e 0.15 -j 24 -o Corallo1A_1.trim.fq -p Corallo1A_2.trim.fq Corallo1A_1.fq.gz Corallo1A_2.fq.gz

bowtie2 --no-unal -p 24 -x Corallorhiza_organelle_ref.fas -1 Corallo1A_1.trim.fq -2 Corallo1A_2.trim.fq -S Corallo1A.sam

samtools sort Corallo1A.sam > Corallo1A.sort.bam

samtools index Corallo1A.sort.bam

perl cov_analysis_wrapper.pl scaf_list.txt ../Corallo1A.sam 100 10

#R scripts for generating maps and depth plots.

#Depth_plots.R
#contig_maps.R