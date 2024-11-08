#!/usr/bin/sh

#cutadapt 4.0

cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --minimum-length 50 -e 0.15 -j 24 -o CM_1A.R1.trim.fq -p CM_1A.R2.trim.fq Cm_1A_CKDN240011140-1A_227NL7LT4_L3_1.fq.gz Cm_1A_CKDN240011140-1A_227NL7LT4_L3_2.fq.gz

head -60000000 CM_1A.R1.trim.fq > CM_1A.R1.trim.15M.fq
head -60000000 CM_1A.R2.trim.fq > CM_1A.R2.trim.15M.fq

#Spades v4.0.0

spades.py --meta -t 48 -m 400 -1 CM_1A.R1.trim.15M.fq -2 CM_1A.R2.trim.15M.fq -o CM_1A_assembly


#NovoPlasty v4.3.1

perl NOVOPlasty4.3.1.pl -c config.txt