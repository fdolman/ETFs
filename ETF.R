#Fabian Dolman 

#Data Analysis Project 

#Please set directory to the project files location 

#ETF.R 

#Packages
library(quantmod)
library(PerformanceAnalytics)

#Environment to store stock symbols data
ETF_Data <- new.env()

#Dates needed for getSymbols function
sDate <- as.Date("2007-09-04") #Start Date
eDate <- as.Date("2014-09-02") #End   Date

#Stock symbols
ticker_symbol <- c("IVW","JKE","QQQ","SPYG","VUG" )

#Load functions into memory 
#Functions.R contain functions necessary for the code to complete
source("Functions.R")

#Create empty list
Temp_ETF_Data <- list()


#Log_File.txt will be created for errors and warnings
#Variable is a connection to a specific file that appends the output to the file
connection_string <- file("Log_File.txt", open = "wt")

#Sink allows the R output to a connection file which is connection_string
#Log_File.txt is created to the directory that has been set
sink(connection_string, type="message")

#Loop to retrieve prices from Yahoo's API and assign only the Adjusted column to the list.
for(i in ticker_symbol){  
  tryCatch(
{
  getSymbols(i, env = ETF_Data, from = sDate, to = eDate, src = "yahoo", warning = FALSE) 
  Temp_ETF_Data[[i]] <- Ad(ETF_Data[[i]])
},    

error = function(e) {
  message("-ERROR-")
  message(paste("Error for ticker symbol  :", i, "\n"))
  message("Here's the original error message: ")
  message(e)
  message("")
  return(i)},
finally = {
  message(paste("Data was processed for symbol:", "[", i, "]" ))
  message("\n","******************************************", "\n")
  
}) 
}

#Turns off message once it is on the console and reads the line. 
#Then it closes the sink connection and closes the connection to the Log_File.txt
sink(type = "message")
readLines("Log_File.txt")
close(connection_string)


#Check your data 
View(Temp_ETF_Data)

#Merge list into columns from list 
Daily_Quotes              <- do.call(merge, Temp_ETF_Data)
View(Daily_Quotes)

#Create new xts object with the 1st trading day price of each month and assign column headers 
Monthly_Quotes            <- Daily_Quotes[startpoints(Daily_Quotes,'months')]
ticker_symbol             <- c(colnames(Monthly_Quotes))
names(Monthly_Quotes)     <- c(ticker_symbol)

View(Monthly_Quotes)

#Create new xts object with the monthly returns and assign column headers
Monthly_Returns           <- do.call(merge, lapply(Monthly_Quotes, monthlyReturn))
names(Monthly_Returns)    <- c(ticker_symbol)

View(Monthly_Returns)

#Create a vector on the Geometric average ROI and assign column headers 
Annualized_Returns        <- Return.annualized(Monthly_Returns, geometric = TRUE)
names(Annualized_Returns) <- c(ticker_symbol)

View(Annualized_Returns)

#Display values 
head(percent(Monthly_Returns))
head(percent(Annualized_Returns))

#Plot data - 
# *Note*  - If the Plots section is not big enough to show graph it will return an error
#Error will say "Error in plot.new() : figure margins too large" 
#This can be resolved when you make the graph screen big enough before running the code
plot_Monthly_Returns_Chart(Monthly_Returns)
plot_Annualized_Returns_Chart(Monthly_Returns)


#Clear and Free Memory
rm(Temp_ETF_Data, Daily_Quotes)