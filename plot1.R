#Installing RODBC to read tables from Local SQL Server 2012
install.packages("RODBC")
library(RODBC)

#The Household Power Comsumption Data table is loaded in the local SQL server

#Establish Connection to read the table
con<-odbcConnect("DemoData")

#Read data of 1/2/2007 & 2/2/2007 from the SQL Table
queryResult <- sqlQuery(con, "SELECT * FROM dbo.household_power_consumption WHERE [Date] = '1/2/2007' OR [Date] = '2/2/2007'")
class(queryResult)
str(queryResult)
odbcClose(con)

#Plotting the Histogram in png
png("plot1.png",width = 480, height = 480)
hist(queryResult$Global_active_power,col="red",xlab = "Global Active Power (kilowatts)",main="Global Active Power")
dev.off()

