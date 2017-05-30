#!/usr/bin/Rscript
args <- commandArgs(trailingOnly = TRUE)

if(length(args) < 1) {
  print("./get_ppdb_data.R [input gene ids|list.txt]")
  quit()
}


#geneFile <- "data/ath_genes_list.txt"
geneFile <- args[1]
outfile <- paste(geneFile, ".processed", sep = "")

genelist <- read.table(geneFile, sep = "\t", header = F)
genelist <- genelist[(genelist$V2 == "protein_coding"), ]
#a <- genelist$V1


site_url <- "http://ppdb.agr.gifu-u.ac.jp/ppdb/cgi-bin/display.cgi?organism=At&gene="
final_list <- list()
k <- 1
for (i in 1:nrow(genelist)) {
  gene <- genelist[i,1]
  print(gene)
  search_url <- paste(site_url, gene, ".1", sep = "")
  #search_url <- paste(site_url, "AT1G01010", ".1", sep = "")
  #print(search_url)
  x <- readLines(search_url)
  foundlines <- x[grep('TSS peak',x)]
  #print(foundlines)
  #print("----------")
  
  mypattern <- '<tr id=\"TSS\\d*\\D*\" class=\"tss\"><td>\\D+</td><td><tt>\\D</tt></td><td>(\\d*)</td><td>(\\D)</td><td><a href=\"#Fv\" onClick=\"F\\d\\D\'TSS\\d+\\D\'\\D*(\\d*)</a></td><td>(\\D*\\d*)</td></tr>'
  result <- sub(mypattern,"\\1=\\2=\\3=\\4", foundlines)
  #print(result)
  result <- unlist(strsplit(result, "="))
  
  score <- as.numeric(result[1])
  if (length(result) == 4 && !is.null(result) && score > 10) {
    final_list[[k]] <- result
    k <- k +1
     #final_list <- list(final_list, result)
    
  }
  #print(paste(gene, "=",result, sep = ""))
}

r <- as.data.frame(matrix(unlist(final_list), ncol = 4, byrow = T))
write.table(r, col.names = F, row.names = F, quote = F, file = outfile)

print("Finished all the genes from file")

for (i in 1:length(final_list)) {
  item <- final_list[[i]]
  score <- item[1]
  strand <- item[2]
  loc <- as.numeric(item[3])
  rel_loc <- as.numeric(item[4])
  print(paste(gene, score, strand, loc, rel_loc, sep = "\t"))
}

print(final_list)
### Single Tests
x = readLines('http://ppdb.agr.gifu-u.ac.jp/ppdb/cgi-bin/display.cgi?organism=At&gene=AT1G01050.1')

foundlines <- x[grep('TSS peak',x)]

mypattern <- '<tr id=\"TSS\\d*\\D*\" class=\"tss\"><td>\\D+</td><td><tt>\\D</tt></td><td>(\\d*)</td><td>(\\D)</td><td><a href=\"#Fv\" onClick=\"F\\d\\D\'TSS\\d+\\D\'\\D*(\\d*)</a></td><td>(\\D*\\d*)</td></tr>'
result <- sub(mypattern,"\\1=\\2=\\3=\\4", foundlines)
result
result <- unlist(strsplit(result, "="))
