##              Script to create plot2
## note this was created and tested on Windows - may require modification to run on mac/ linux
## Script is in two sections:
## Section A: load, tidy and format the data ready for plotting (same for all 4 scripts)
## Section B: produce the plot file


##-----------------------------------------------------------------------------
##              Section A: tidy and format data ready for plotting


## download, unzip the file
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "power.zip")
unzip("./power.zip")

## read the file, taking account of format, seperators are ";", blanks are "?", first row is headers
## use colClasses to set classes of columns in order to reduce memory requirements and improve speed
power <- read.table("./household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", 
                    colClasses =c("character", "character", "numeric", "numeric", "numeric", "numeric",
                                  "numeric", "numeric", "numeric"))

## create a combined date and time vector
datetime <-paste(power$Date, power$Time)

## make this vector the first table in the dataframe
power <- cbind(datetime, power)

## drop the old time and date columns
power <- power[, -c(2,3)]

## format datatime column as dates and times
power$datetime <- strptime(power$datetime, "%d/%m/%Y %H:%M:%S")

##---------------- create a subset of the data for the two days required-------

## create vector in date only format to compare to two required dates (no hours, mins, secs)
dates <- as.Date(power$datetime)

## subset by comparison to one of two selected dates
datasubset <- power[dates == as.Date("2007-02-01") | dates == as.Date("2007-02-02"), ]

##-----------------------------------------------------------------------------
##              Section B: Create plot

##    Open PNG device and create file
png(filename ="plot2.png", bg ="transparent") ## default size is 480 by 480 which is correct so don't need to set

##  create plot with type "l" for line and setting y axis label with ylab, x axis blank with xlab and 3 breaks for x axis
with(datasubset, plot(datetime, Global_active_power, type ="l", xlab ="", ylab ="Global Active Power (kilowatts)"), breaks = 3)

##-----------------------------------------------------------------------------
## turn off graphics device
dev.off()

##-----------------------------------------------------------------------------
## notify completion of script
msg <- "plot2.R script complete, plot2.png produced in R working directory"
print(msg, quote = FALSE)
