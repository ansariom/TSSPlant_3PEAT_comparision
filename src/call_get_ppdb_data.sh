#!/bin/bash

#infile=data/ath_genes_list.txt
infile=data/a.txt

tmpdir=tmp_data
rm -f -r $tmpdir
mkdir -p $tmpdir

outprefix=$tmpdir/genes.

split -d -l 100 $infile $outprefix

ncpu=40
count=1

for ingenes in `ls $outprefix*`; do
	./get_ppdb_data.R $ingenes &
	if [ $count -lt $ncpu ]; then
		let "count=count+1"
	else
		wait
		count=1
	fi 
done
