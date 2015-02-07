# data storage
library("data.table")

# set up the environment
#Sys.setenv(tz = "UTC")
options(digits = 5)
options(prompt = "d.tbl>")
date()

# load the dataset; input is a file name to read
load_dataset <- function(input, ...) {
  require("data.table")
  function(x) {
    data_set = NULL
    try(data_set <- fread(input = input, ...), silent = TRUE)
    cat(sprintf("Processing dataset...\n"))
    return(data_set)
  }
}

# read data ------------------------------------------------
# create directory to hold downloaded file
if(!file.exists("data")) {
  dir.create("data")
}
# unzip file into data directory
dest_file <- "exdata-data-household_power_consumption.zip"
if(file.exists(dest_file)) {
  unzip(zipfile = dest_file, exdir = path.expand("./data"))
}

list.files("./data")

file_input <- file.path("./data/household_power_consumption.txt")
# only read in column names and class, "test run"                      
nrows <- 0             
na.strings <- "?"
epc <- load_dataset(input = file_input, nrows = nrows, na.strings = na.strings) 
epc_test <- epc()
classes <- sapply(epc_test, class)
classes

# read in a select number of rows 
# file size info
cat("File size:", file.info(file_input)$size, "\n")
# check 3 lines after matching line beginning with 1/2/2007
system("grep -A 3 -n '^1/2/2007' ./data/household_power_consumption.txt | head -3")
# 66638
cat("\n")
# check 3 lines before matching line beginning with 3/2/2007
system("grep -B 3 -n '^3/2/2007' ./data/household_power_consumption.txt | head -3")
# 69518

nrows <- 69518 - 66638 # number of rows to read in
skip <- "1/2/2007"     # start read at the beginning of this line
epc <- load_dataset(input = file_input, nrows = nrows, na.strings = na.strings,
                    skip = skip, stringsAsFactors = FALSE, 
                    colClasses = list(character = 1:9)) 

# combine heading and data into list
epcl <- list(epc_test, epc())
# electric power consumption dataset
epc <- rbindlist(epcl)

# convert data to suitable classes
epc[, Date := as.IDate(Date, format = "%d/%m/%Y")]
epc[, Time := as.ITime(Time, format = "%H:%M:%S")]
# convert class for multiple columns
epc[, (3:9) := lapply(.SD,as.numeric), .SDcols = 3:9]
# add Date_time to dataset
epc[, Date_time := as.POSIXct(Date, time = Time, tz = "UTC")]
# change column order
setcolorder(epc, c("Date_time","Date","Time", "Global_active_power",
                   "Global_reactive_power", "Voltage", "Global_intensity",
                   "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# check load -------------------------------------------
class(epc)
classes <- sapply(epc, class)
classes
epc
names(epc)
dim(epc)
# list data tables 
#tables()

# Hmisc package
library("Hmisc")
print(contents(epc))
#describe(epc)

# Plot data ---------------------------------------------
# create folder to hold plot
if(!file.exists("figure")) {
  dir.create("figure")
}
# plot saved into figure folder
png("./figure/plot1.png", width = 480, height = 480, units = "px", type = "cairo")
opar <- par(mar = c(4,4,2,2))
epc[
  i = !is.na(Global_active_power),
  j = {
    print(head(Global_active_power)) # quick look of data
    hist(Global_active_power, 
         main = ("Global Active Power"),
         col = "red",
         xlab = "Global Active Power (kilowatts)"
    )
  }
  ]
par(opar)
dev.off()

save(epc, file = "epc.RData")
