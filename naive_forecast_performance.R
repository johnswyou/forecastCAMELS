# Author: John You

csv_filenames <- list.files(path = "./data/")
csv_files <- lapply(paste0("./data/", csv_filenames), read.csv)
names(csv_files) <- gsub(".csv", "", csv_filenames)

# Reference: https://stackoverflow.com/questions/3558988/basic-lag-in-r-vector-dataframe
lagpad <- function(x, k) {
  if (k>0) {
    return (c(rep(NA, k), x)[1 : length(x)] );
  }
  else {
    return (c(x[(-k+1) : length(x)], rep(NA, -k)));
  }
}

naive_forecasts <-
  lapply(csv_files, FUN=function(x) {
    naive_df <- data.frame(pred = lagpad(x$Q.ft3.s., 1), obs = x$Q.ft3.s.)
    hydroGOF::NSE(naive_df$pred, naive_df$obs)
  })

naive_forecasts <- unlist(naive_forecasts)
sort(naive_forecasts)

plot.ts(csv_files$`17_13083000`$Q.ft3.s.) # easy to forecast
acf(csv_files$`17_13083000`$Q.ft3.s.)
plot.ts(csv_files$`12_08195000`$Q.ft3.s.) # hard to forecast
acf(csv_files$`12_08195000`$Q.ft3.s.)
plot.ts(csv_files$`10_06921200`$Q.ft3.s.) # hard to forecast
acf(csv_files$`10_06921200`$Q.ft3.s.)

plot(csv_files$`10_06921200`$prcp.mm.day., csv_files$`10_06921200`$Q.ft3.s.)
plot(csv_files$`17_13083000`$prcp.mm.day., csv_files$`17_13083000`$Q.ft3.s.)

# *************************************
# Naive forecast evaluation for Ourthe
# *************************************

data(ourthe, package = "wddff")
head(ourthe)

naive_df <- data.frame(pred = lagpad(ourthe$Q, 60), obs = ourthe$Q)
head(naive_df, n=20)
tail(naive_df)

hydroGOF::NSE(naive_df$pred, naive_df$obs)

nse_vec <- numeric()

for (k in 1:30) {
  naive_df <- data.frame(pred = lagpad(ourthe$Q, k), obs = ourthe$Q)
  nse_vec[k] <- hydroGOF::NSE(naive_df$pred, naive_df$obs)
}

plot(1:30, nse_vec, ylab = "NSE", xlab = "forecast horizon (aka leadtime)", main = "Naive Forecasts")
grid()
