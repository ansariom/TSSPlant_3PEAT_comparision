library(ggplot2)
wigs_outdir="~/Downloads/all_scans_ppdv/"
outdir <- "~/Downloads/all_scans_ppdv/plots"
tssplant_out <- "~/Downloads/tssplant_output.pdb_test1.table"

tssplant_res <- read.table(tssplant_out, header = T)
tssplant_res$location <- tssplant_res$location - 1000
wig_list <- list.files(wigs_outdir, full.names = T)

wigfile <- "~/Downloads/all_scans_ppdv/AT1G01010_1.wig"
for (wigfile in wig_list)  {
  print(wigfile)
  wig <- read.table(wigfile, skip = 2, header = F)
  f = basename(wigfile)
  peakname <- tools::file_path_sans_ext(f)
  
  tssplant_peaks <- subset(tssplant_res, tssplant_res$peak_id == peakname)
  #current_peak <- subset(peaks, peaks$PeakID == peakname)
  
  wigdata <- as.data.frame(wig)
  colnames(wigdata) <- "tss_prob"
  
  l  = nrow(wigdata)
  hw = (l-1)/2
  
  wigdata$loc <- seq(-hw,hw)
  #wigdata$tss_prob_scaled <- wigdata$tss_prob * current_peak$ModeReadCount
  
  #current_peak$Start = current_peak$ModeLocation - current_peak$Start
  #current_peak$End = current_peak$End - current_peak$ModeLocation
  
  #p <- ggplot(wigdata, aes(loc, tss_prob)) + geom_line() 
  p <- ggplot(wigdata, aes(loc, tss_prob)) + geom_line() +
    geom_rect(xmin=-50, xmax=50, ymin=0, ymax=1,col="red", alpha=0.003, fill="#F4FEFD") +
    geom_vline(tssplant_peaks, mapping = aes(xintercept=location),col = "blue") 
  p 
  # ylim(0, current_peak$ModeReadCount)  + ggtitle(current_peak$PeakID)
  
  outfile = paste(outdir, "/", peakname, ".png", sep = "")
  ggsave(file=outfile, p)
  
}
