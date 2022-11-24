# Script to convert filtered_processed_datalist.RData to csv files.

dat_names <- gsub("/", "_", names(filtered_processed_datalist))

for (i in 1:length(filtered_processed_datalist)) {
  dat1 <- names(filtered_processed_datalist)[i]
  dat2 <- dat_names[i]
  write.csv(filtered_processed_datalist[[dat1]], file=paste0("data_2pct\\", dat2, ".csv"))
}

