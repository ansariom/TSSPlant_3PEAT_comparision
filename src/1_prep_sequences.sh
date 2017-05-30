#!/bin/bash

infile=data/ath_ppdb_tss_locs
genome=~/mitra/data/tair10/genome.fas

tssplant_output=data/tssplant_output.pdb_test1
tssplant_result=$tssplant_output.table
out_fasta_file=$infile.fa
seqs_bed_file=$infile.bed

#awk -F "," '{if (NR > 1) {gsub(/\./, "_"); print $1"\t"($4-1000)"\t"($4+1000)"\t"$3"\t"$2}}' $infile > $seqs_bed_file

#bedtools getfasta -fi $genome -bed $seqs_bed_file -fo $out_fasta_file -s -name

peat_exe_dir="/nfs0/BPP/Megraw_Lab/mitra/Projects/3PEAT_model/exe"
#cd $3peat_exe_dir
#./call_3peat_scan_TSSPlant.sh

#### Process outputs

# TSSPlant 
tail -n +8 $tssplant_output | grep -v "Length of Query" | grep -v "promoter(s) predicted" | sed 's/Query: //g' | sed 's/(TATA-) //g' | awk 'NF {p=1;if (/^>/) { name=$1; p=0}; if (/^+/ || /^-/) {strand=$1; loc=$5} ; if (p == 1) {print name"\t"loc"\t"strand} }' | sed 's/>//g' | sed '1 i\peak_id\tlocation\tstrand' > $tssplant_result
