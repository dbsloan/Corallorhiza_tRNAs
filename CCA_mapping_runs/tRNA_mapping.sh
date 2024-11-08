#!/bin/sh

#merge R1 and R2 reads with bbmerge
for file in *1.fq.gz; do bbmerge.sh in1=$file in2=${file%1.fq.gz}2.fq.gz out=${file%_CKDL240022801-1A_22C7HCLT4_L1_1.fq.gz}.bbmerge.fq outu=${file%_CKDL240022801-1A_22C7HCLT4_L1_1.fq.gz}.unmerged1.fq outu2=${file%_CKDL240022801-1A_22C7HCLT4_L1_1.fq.gz}.unmerged2.fq ihist=${file%_CKDL240022801-1A_22C7HCLT4_L1_1.fq.gz}.bbmerge_hist.txt ordered=t qtrim=r minoverlap=30 mismatches=4 2> ${file%_CKDL240022801-1A_22C7HCLT4_L1_1.fq.gz}.bbmerge_log.txt; done

#trim MSR-seq adapter sequence
for file in *bbmerge.fq; do perl MSR-seq_trim.pl $file ACTGGAA 6 > ${file%fq}trim.fas; done

#generate a file that collapses all identical read sequences into a single sequence
for file in *trim.fas; do perl collapse_identical_seqs.pl $file > ${file%trim.fas}collapsed.fas; done

#loop to trim 5' extension of reads, map them to reference, and quantify read counts including CCA tail state.
for file in *collapsed.fas; do blastn -task blastn -db Corallorhiza_ref_20240913.fas -query $file -evalue 1e-12 -num_threads 12 -out ${file%collapsed.fas}blast.txt; perl trim_5prime_blast.pl ${file%collapsed.fas}blast.txt $file ${file%collapsed.fas}trim.fas > ${file%collapsed.fas}blast_processed.fas; bowtie2 --no-unal -p 12 -L 10 -i C,1 --mp 5,2 --score-min L,-0.7,-0.7 -f -x Corallorhiza_ref_20240913.fas -U ${file%collapsed.fas}blast_processed.fas -S ${file%collapsed.fas}sam; perl CC_vs_CCA_counter.sam4.pl ${file%collapsed.fas}sam > ${file%collapsed.fas}CC_vs_CCA.txt; perl CC_vs_CCA_counter.sam4.pl ${file%collapsed.fas}sam --unique > ${file%collapsed.fas}CC_vs_CCA.unique.txt; done
