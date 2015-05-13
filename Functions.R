#Functions.R

#Function to create the index for the first day of the month
startpoints <- function (xts_object, on = "months")  
{                                           
  head(endpoints(xts_object, on) + 1, -1)            
}                                            

#View decimals in percentage format
percent <- function (xts_object)
{
  round(xts_object[,] * 100, digits = 2)
}

#Plot Data 
plot_Monthly_Returns_Chart <- function(xts_Object)
{
  chart.TimeSeries(xts_Object,  
                   auto.grid      = TRUE,  #Fills out a grid 
                   xaxis          = TRUE,  #Fills in "MMM'YY" along x-axis 
                   yaxis          = TRUE,  #Fills in "Stock Prices" along y-axis
                   yaxis.right    = FALSE, #Allows me to place values to the right of the grid
                   main           = "Monthly Return Comparison Chart", #Title of chart                 
                   cex.main       = 1,     
                   cex.lab        = .8, #Changes the font size for the y-axis title
                   ylab           = "Percentage (%)", #Name the y-axis
                   xlab           = "Time (Months)", #Name the x-axis 
                   date.format.in = "#%Y-%m-%d",
                   element.color  = "red",#Frame of the grid 
                   event.color    = "darkgray",
                   period.color   = "aliceblue", 
                   grid.color     = "gray", 
                   grid.lty       = "dotted",
                   legend.loc     = "bottomright", #Position of legend 
                   cex.legend     = 0.9) #Series of stock symbols
}

plot_Annualized_Returns_Chart <- function(xts_Object)
{
  chart.CumReturns(xts_Object, 
                   
                   wealth.index   = TRUE, 
                   main           = "Cumulative (Geometric) Return Chart", 
                   ylab           = "Value ($)", #Name the y-axis
                   cex.main       = 1,     
                   cex.lab        = .8, #Changes the font size for the y-axis title
                   xlab           = "Time (Years)", #Name the x-axis 
                   legend.loc     = "bottomright", 
                   element.color  = "red",#Frame of the grid 
                   event.color    = "darkgray",
                   period.color   = "aliceblue", 
                   grid.color     = "gray", 
                   grid.lty       = "dotted",
                   cex.legend = 0.9, 
                   geometric = TRUE, 
                   colorset = (1:12))  
}
  


