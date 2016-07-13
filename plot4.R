#Installing RODBC to read tables from Local SQL Server 2012
install.packages("RODBC")
library(RODBC)
install.packages("dplyr")
library(dplyr)

#The Household Power Comsumption Data table is loaded in the local SQL server

#Establish Connection to read the table
con<-odbcConnect("DemoData")

#Read data of 1/2/2007 & 2/2/2007 from the SQL Table
queryResult <- sqlQuery(con, "SELECT * FROM dbo.household_power_consumption WHERE [Date] = '1/2/2007' OR [Date] = '2/2/2007'")
class(queryResult)
str(queryResult)
odbcClose(con)

#Changing the Date & Time formats
#queryResult %>% 
#mutate(Date1=as.Date(Date,format="%d/%m/%Y"))
#queryResult$DT<-paste(queryResult$Date,queryResult$Time)
queryResult$Date1<-as.Date(queryResult$Date,format="%d/%m/%Y")
queryResult$Time1<- as.POSIXct(strptime(queryResult$Time,format="%H:%M:%S"))

#Sort by Date & Time
queryResult<-arrange(queryResult,Date1,Time1)

v1<-c(0,length(queryResult$Date1)/2,length(queryResult$Date1))
v2<-c("Thu","Fri","Sat")

#Plotting in PNG

#Plotting in PNG
png("plot4.png",width = 480, height = 480)

par(mfrow=c(2,2))

plot(queryResult$Global_active_power,type="l",xaxt="n",xlab="",ylab="Global Active Power (kilowatts)")
axis(1,at=v1,labels=v2)

plot(queryResult$Voltage,type="l",xaxt="n",xlab="datetime",ylab="Voltage")
axis(1,at=v1,labels=v2)

plot(queryResult$Sub_metering_1,type="l",xaxt="n",xlab="",ylab="Energy sub metering")
lines(queryResult$Sub_metering_2,col="red")
lines(queryResult$Sub_metering_3,col="blue")
v1<-c(0,length(queryResult$Date1)/2,length(queryResult$Date1))
v2<-c("Thu","Fri","Sat")
axis(1,at=v1,labels=v2)
#Adding Legend
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n",lty=c(1,1,1),col=c("black","red","blue"))

plot(queryResult$Global_reactive_power,type="l",xaxt="n",xlab="datetime",ylab="Global_reactive_power")
axis(1,at=v1,labels=v2)

dev.off()
