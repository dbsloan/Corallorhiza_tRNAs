#!/usr/bin/sh


#cutadapt v4.0

cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --minimum-length 50 -e 0.15 -j 24 -o Corallo1A_1.trim.fq -p Corallo1A_2.trim.fq Corallo1A_1.fq.gz Corallo1A_2.fq.gz


#Trinity-v2.15.2

docker run --rm -v`pwd`:`pwd` trinityrnaseq/trinityrnaseq Trinity --seqType fq --CPU 64 --max_memory 200G --SS_lib_type RF --left `pwd`/Corallo1A_1.trim.fq --right `pwd`/Corallo1A_2.trim.fq --output `pwd`/trinity_out_dir