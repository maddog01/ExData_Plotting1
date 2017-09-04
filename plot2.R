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


#convert Date class to Date
vect_date <- as.vector(newhp$Date)
new_vect_date <- as.Date(vect_date, format = "%d/%m/%Y")
newhp[["Date"]] <- new_vect_date

#date_time a list combining date and time from newhp
date_time <- as.POSIXct(paste(newhp$Date, newhp$Time),
                        format = "%Y-%m-%d %H:%M:%S")



plot(date_time, newhp$Global_active_power,xlab = "",
     ylab = "Global Active Power (kilowatts)", type = "l")

#Copy plot to a PNG file

dev.copy(png, file = "plot2.png")
dev.off()
