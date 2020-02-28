# install.packages("prophet")
library("prophet")
library("lubridate")

# set working directory to wherever your project is stored
setwd("~/Desktop/Flaring Stars/Team 2")

# test Pathnames
test_num <- 1
results_list <- c("000892713_results.Rdat", "001872210_results.Rdat", "001872078_results.Rdat")

# test intervals
subset_count <- 20
test_interval <- 1:(71427/subset_count)

# Load in the lightcurve residuals
lc <- load(paste("../Results_Files_1/", results_list[test_num],sep = ""))
lc <- results$Lightcurve
resid <- results$ARFIMA$residuals

# create a list of dates for the df
time_from_start <- seq(ymd_hm('0000-01-01 00:00'),ymd_hm('0004-12-31 23:45'), by = '15 mins')[1:length(resid)]

# create a df from the residuals
df <- data.frame("ds" = time_from_start[test_interval], "y" = resid[test_interval])

# start the clock
ptm <- proc.time()

# build the prophet model object
m <- prophet(df,
             daily.seasonality=FALSE,
             weekly.seasonality=FALSE,
             yearly.seasonality=FALSE
             )
# print build time
proc.time() - ptm

# set a small period in the future so prophet can predict
future <- make_future_dataframe(m, periods = 1)

# fit the model
forecast <- predict(m, future)

# print fit time
proc.time() - ptm

# plot the forecast
plot(m, forecast)

# Stop the clock
proc.time() - ptm
