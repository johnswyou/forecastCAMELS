load("filtered_processed_datalist.RData")

# Example GAGE ID dataset
temp <- filtered_processed_datalist$`03/02125000`[,c(5, 7, 8, 9, 11, 12, 13)]

plot.ts(temp, nc=2, main="HUC: 03, GAGE ID: 02125000")

# I get warnings when I run the following for some reason
PerformanceAnalytics::chart.Correlation(temp)

# Naive linear regression fit
summary(lm(`Q(ft3/s)`~., data=temp))
