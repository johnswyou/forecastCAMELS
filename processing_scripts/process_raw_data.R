# Some tests
# temp <- utils::read.table("./usgs_streamflow/01/01013500_streamflow_qc.txt", skip = 0)
# temp <- utils::read.table("./daymet/03/02051500_lump_cida_forcing_leap.txt", skip=3)
# colnames(temp) <- c("GAGEID", "Year", "Month", "Day", "Q(ft3/s)", "QC_flag")
# temp <- janitor::row_to_names(temp, 1)
# temp$Hr <- NULL
# head(temp)

# Read file names
daymet_filelist <- list.files("./daymet/", recursive = TRUE, pattern = "\\.txt$")
usgs_streamflow_filelist <- list.files("./usgs_streamflow/", recursive = TRUE, pattern = "\\.txt$")

# Extract GAGE ID for each file in file lists
daymet_gageid <- sapply(daymet_filelist, FUN=function(x) stringr::str_extract(x, "[^_]+"))
usgs_streamflow_gageid <- sapply(usgs_streamflow_filelist, FUN=function(x) stringr::str_extract(x, "[^_]+"))

daymet_gageid[!daymet_gageid %in% usgs_streamflow_gageid]

sum(daymet_gageid == usgs_streamflow_gageid)

gageid_pairs_filenames <- cbind(daymet = daymet_filelist,
                                usgs_streamflow = usgs_streamflow_filelist)

row_reader <- function(x) {

  # x is a row (a character vector)
  # x[1] is daymet, x[2] is usgs_streamflow
  # REMEMBER: each row x corresponds to a GAGE ID

  daymet_raw <- paste0("./daymet/", x[1])
  daymet_raw <- utils::read.table(daymet_raw, skip = 3)
  daymet_raw <- janitor::row_to_names(daymet_raw, 1)
  daymet_raw$Hr <- NULL
  daymet_raw <- as.data.frame(sapply(daymet_raw, as.numeric)) # convert character columns to numeric columns

  usgs_streamflow_raw <- paste0("./usgs_streamflow/", x[2])
  usgs_streamflow_colnames <- c("GAGEID", "Year", "Month", "Day", "Q(ft3/s)", "QC_flag")
  usgs_streamflow_raw <- utils::read.table(usgs_streamflow_raw, skip = 0)
  colnames(usgs_streamflow_raw) <- usgs_streamflow_colnames

  # Error Check

  # daymet_date_matrix <- cbind(Year = daymet_raw$Year,
  #                             Month = daymet_raw$Mnth,
  #                             Day = daymet_raw$Day)
  #
  # usgs_streamflow_matrix <- cbind(Year = usgs_streamflow_raw$Year,
  #                                 Month = usgs_streamflow_raw$Month,
  #                                 Day = usgs_streamflow_raw$Day)
  #
  # if (!identical(daymet_date_matrix, usgs_streamflow_matrix)){
  #   stop(paste0("dates don't align between daymet inputs and usgs streamflow target series for gage ", usgs_streamflow_raw$GAGEID))
  # }
  #
  # # Return dataset with daymet inputs and usgs streamflow target combined
  # usgs_streamflow_raw$Year <- NULL
  # usgs_streamflow_raw$Month <- NULL
  # usgs_streamflow_raw$Day <- NULL
  #
  # return(cbind(daymet_raw, usgs_streamflow_raw))

  return(dplyr::left_join(usgs_streamflow_raw, daymet_raw, by = c("Year" = "Year", "Month" = "Mnth", "Day" = "Day")))

}

processed_datalist <- apply(gageid_pairs_filenames, 1, row_reader)
gageid <- daymet_gageid # could also have used usgs_streamflow_gageid
names(gageid) <- NULL

names(processed_datalist) <- gageid

save(processed_datalist, file = "processed_datalist.RData")
