
# 1- set a set of #hitsPerKB
hits_per_kb <- seq(5, 100, by = 5)
npromoters <- 200
prom_len_kb <- 2
prom_seq <- seq(-1000, 1000, by = 1)
ndraws <- 100

fdata <- data.frame(nhits=c(), TF=c(), FP=c())
for(t in 1:ndraws) {
  set.seed(sample(seq(1, 1000000),1))
  l = list()
  k = 1
  for (n in hits_per_kb) {
    print(n)
    for(p in 1:npromoters) {
      nhits <- n * prom_len_kb
      # draw nhits randomely
      s <- sample(x = prom_seq, size = n)
      
      # Compute the TP and FP rates
      tp = 0
      fp = 0
      for(i in s) {
        if (i < 51 && i > -49) {
          tp = tp + 1
        } else {
          fp = fp + 1
        }
      }
      m <- list(N=n, P=p,TP=tp, FP=fp)
      l[[k]] <- unlist(m)
      k = k+1
      #print(paste(s, "   ---- TP = ", tp, " FP = ", fp, sep = ""))
    }
  }
  
  result <- as.data.frame(matrix(unlist(l), ncol = 4, byrow = T))
  colnames(result) <- c("nhits", "promoter_no", "TP", "FP")
  
  final_table <- aggregate(result, by = list(result$nhits), sum)
  final_table$promoter_no <- NULL
  final_table$Group.1 <- NULL
  fdata <- rbind(fdata, final_table)
}

f <- subset(fdata, fdata$nhits == 2000)
level <- factor(nhits)
ggplot(fdata, aes(x=TP)) + geom_bar(stat = "count") + facet_wrap(~nhits)

mean_rand <- aggregate(fdata, by = list(fdata$nhits), mean)
median_rand <- aggregate(fdata, by = list(fdata$nhits), median)
std_rand <- aggregate(fdata, by = list(fdata$nhits), sd)

final_stat <- cbind(mean_rand$nhits, mean_rand$TP, median_rand$TP, std_rand$TP, mean_rand$FP, median_rand$FP, std_rand$FP)
colnames(final_stat) <- c("nhits_total", "mean_TP", "median_TP", "sd_TP", "mean_FP", "median_FP", "sd_FP")
write.table(final_stat, quote = F, row.names = F, sep = "\t", file = "TSSPlant_comparison_random_drawn_hits_stats.xlsx")
