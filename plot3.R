rm(list=ls())
library(data.table)

#hp variable for household_power_consumption data frame

hp <- read.table("household_power_consumption.txt",sep = ";",
                 stringsAsFactors = FALSE) 

col_nm <- as.vector(as.character(hp[1,])) 

#substitute actual variable names for V1:V9
setnames(hp, old = colnames(hp), new = col_nm)

#the actual names were entered as 1st row. This removes this row.
hp_nm <- hp[-1,]   

#renumbered the rows after deleting old row 1.
row.names(hp_nm) <- 1:nrow(hp_nm)  

#Subset of hp_nm, but only containing info on dates Feb 1, 2007 and Feb 2, 2007
newhp <- subset(hp_nm, hp_nm$Date %in% c("1/2/2007", "2/2/2007"))  

#Convert Global_active_power to numeric
newhp$Global_active_power <- as.numeric(as.character(newhp$Global_active_power))
newhp$Sub_metering_1 <- as.numeric(as.character(newhp$Sub_metering_1))
newhp$Sub_metering_2 <- as.numeric(as.character(newhp$Sub_metering_2))
newhp$Sub_metering_3 <- as.numeric(as.character(newhp$Sub_metering_3))



#convert Date class to Date
vect_date <- as.vector(newhp$Date)
new_vect_date <- as.Date(vect_date, format = "%d/%m/%Y")
newhp[["Date"]] <- new_vect_date

#date_time a list combining date and time from newhp
date_time <- as.POSIXct(paste(newhp$Date, newhp$Time),
                        format = "%Y-%m-%d %H:%M:%S")


plot(date_time, newhp$Sub_metering_1, type ="l", 
     col = "black", xlab = "", ylab = "Energy sub metering")
lines(date_time, newhp$Sub_metering_2,  col ="red")
lines(date_time, newhp$Sub_metering_3,  col ="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2",
                             "Sub_metering_3"),lwd=c(1,1,1),col=c("black", "red", "blue"))




#Copy plot to a PNG file

dev.copy(png, file = "plot3.png")
dev.off()