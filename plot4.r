## The code assuemes that the source file is saved in the working directory

library(data.table)
library(lubridate)

## reading the data as character (not to get into problems with the "?" that 
## represents missing data in the raw data)
data <- read.table("household_power_consumption.txt", colClasses=c("character","character","character","character","character","character","character","character","character"), sep=";", header=TRUE)

## changing the Date and Time columns to appropriate classes using lubridate:
data$Date <- dmy(data$Date)
data$Time <- hms(data$Time) 

## replacing the ? with NA in all variables with "?":s (verified earlier when trying to read data as such)
data$Global_active_power[data$Global_active_power == "?"] <- NA
data$Global_reactive_power[data$Global_reactive_power == "?"] <- NA
data$Voltage[data$Voltage == "?"] <- NA
data$Global_intensity[data$intensity == "?"] <- NA
data$Sub_metering_1[data$Sub_metering_1 == "?"] <- NA
data$Sub_metering_2[data$Sub_metering_2 == "?"] <- NA
data$Sub_metering_3[data$Sub_metering_3 == "?"] <- NA

## subsetting for only the dates we need
data2 <- subset(data, data$Date >= "2007-02-01")
data3 <- subset(data2, data2$Date < "2007-02-03") 

## setting system locale if it is not correct (otherwise the weekdays will show incorrectly))
Sys.setlocale("LC_TIME", "English") 

## Combining Date and Time to one single variable to be used in the plots
data3$datetime <- data3$Date + data3$Time

## Converting the character classes to numeric:
data3$Global_active_power <- as.numeric(data3$Global_active_power)
data3$Global_reactive_power <- as.numeric(data3$Global_reactive_power)
data3$Voltage <- as.numeric(data3$Voltage)
data3$Global_intensity <- as.numeric(data3$Global_intensity)
data3$Sub_metering_1 <- as.numeric(data3$Sub_metering_1)
data3$Sub_metering_2 <- as.numeric(data3$Sub_metering_2)
data3$Sub_metering_3 <- as.numeric(data3$Sub_metering_3)

## Creating the fourth plot:
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0)) ##Graphs being plotted row-wise.

#The first subplot is the same as plot2 except for the y axis label:
with(data3, plot(datetime, Global_active_power, type="l", ylab="Global Active Power", xlab=""))
#Second subgraph 
with(data3, plot(datetime, Voltage, type="l", ylab="Global Active Power"))
#The third subplot is the same as plot3 except for the legend having no borders:
with(data3, plot(datetime, Sub_metering_1, type="n", ylab="Energy sub metering", xlab=""))
lines(data3$datetime, data3$Sub_metering_1, type="l")
lines(data3$datetime, data3$Sub_metering_2, col="red", type="l")
lines(data3$datetime, data3$Sub_metering_3, col="blue", type="l")
legend("topright", lty=1, col=c("black", "red","blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
#The fourth plot:
with(data3, plot(datetime, Global_reactive_power, type="l"))

##saving the graph (default size is 480x480px):
dev.copy(png, file="plot4.png", width = 480, height = 480)
dev.off() 
