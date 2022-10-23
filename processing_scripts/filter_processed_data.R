load("processed_datalist.RData")

# Visualize
hist(rlist::list.cbind(lapply(processed_datalist, FUN = function(x) sum(x$QC_flag == "A")/nrow(x))))
hist(rlist::list.cbind(lapply(processed_datalist, FUN = function(x) sum(x$QC_flag == "M")/nrow(x))))

# 1. filter for GAGE ID's that have no missing target values
temp1 <- rlist::list.filter(processed_datalist, sum(QC_flag == "M") == 0)

# BELOW DOES THE SAME THING

# Filter out GAGE ID datasets that contain missing usgs_streamflow values (indicated by QC_flag being "M")
# tempfunc <- function(x) {
#   if ("M" %in% unique(x$QC_flag)) {
#     return(NA)
#   } else {
#     return(x)
#   }
# }
#
# temp2 <- lapply(processed_datalist, FUN = tempfunc)
# temp2 <- temp2[!is.na(temp2)]

# Check
# lapply(temp1, FUN=function(x) print(unique(x$QC_flag)))

# Check if temp1 and temp2 are the same
# length(temp1) == length(temp2)
# sum(useful::compare.list(temp1, temp2)) == length(temp1)

# 2. Filter GAGE ID's with less than 5% estimated usgs_streamflow (QC_flag of "A:e")
filtered_processed_datalist <- rlist::list.filter(temp1, mean(QC_flag == "A:e") < 0.01)

# Check
sum(rlist::list.cbind(lapply(filtered_processed_datalist, FUN = function(x) (sum(x$QC_flag == "A:e")/nrow(x)) < 0.01)))

# 3. Save
save(filtered_processed_datalist, file = "filtered_processed_datalist.RData")








