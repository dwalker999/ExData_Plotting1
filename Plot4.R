# Week 1 project
# Text file downloaded from UC Irvine Machine Learing Repository

# NOTE: This project requires the dplyr package.

# dataset description:
# Measurements of electric power consumption in one household 
# with a one-minute sampling rate over a period of almost 4 years. 
# Different electrical quantities and some 
# sub-metering values are available.

# column descriptions:
# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (in kilowatt)
# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Voltage: minute-averaged voltage (in volt)
# Global_intensity: household global minute-averaged current intensity (in ampere)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

# load dependancies
library(dplyr)

# Download data file and create the data_frame...
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp, method = "curl", quiet = TRUE)
power<-read.table(unz(temp, "household_power_consumption.txt"), header = TRUE, sep=";", stringsAsFactors = FALSE)
unlink(temp)

# only include what we need
vals <- c("1/2/2007", "2/2/2007")
power <- filter(power, Date %in% vals)

# Convert to numerics...
power$Global_active_power <- as.numeric(as.character(power$Global_active_power))

# create a datetime string
power$Datetime <- paste(power$Date,  power$Time)

# Convert datetime from string...
power$Datetime <- strptime(power$Datetime, "%d/%m/%Y %H:%M:%S")

# Convert date from string...
power$Date <- strptime(power$Date, "%d/%m/%Y")



# Plot 4 ...
png(filename="Plot4.png", height = 480, width = 480, units = "px")
par(mfrow = c(2,2))

plot(power$Datetime, power$Global_active_power, type = "n", xlab = NA, ylab = "Global Active Power (kilowatts)")
lines(power$Datetime, power$Global_active_power)

plot(power$Datetime, power$Voltage, type = "n", xlab = "Datetime", ylab = "Voltage")
lines(power$Datetime, power$Voltage)

plot(power$Datetime, power$Sub_metering_1,   type = "n", xlab = NA, ylab = "Energy sub metering")
lines(power$Datetime, power$Sub_metering_1)
lines(power$Datetime, power$Sub_metering_2, col = "red")
lines(power$Datetime, power$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), lwd=1, legend = c("Sub_metering_1",  "Sub_metering_2", "Sub_metering_3"))

plot(power$Datetime, power$Global_reactive_power, type = "n", xlab = "Datetime", ylab = "Global_reactive_power")
lines(power$Datetime, power$Global_reactive_power)


#dev.copy(png, "Plot3.png")
dev.off()