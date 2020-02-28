#install.packages("outliers")
library("outliers")
set.seed(42)

# set working directory to wherever your project is stored
setwd("~/Desktop/Flaring Stars/Team 2")

# test Pathnames
test_count <- 1
results_list <- sample(list.files("../KARPS_Davenport"), test_count)

# get the predicted flares
davenport_predicted <- read.csv(file = '../test_set_scripts/davenport_KIC.csv')
results_list_NFL <- c()
results_list_NFL68 <- c()


# pair the flare count to the results lists
for (i in 1:length(results_list)){
  KIC_num <- strsplit(results_list[i],'_')
  results_list_NFL <- c(results_list_NFL, subset(davenport_predicted, KIC == as.integer(KIC_num[[1]][1]))[["Nfl"]])
  results_list_NFL68 <- c(results_list_NFL68, subset(davenport_predicted, KIC == as.integer(KIC_num[[1]][1]))[["Nfl68"]])
}


# test intervals
subset_count <- 1
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

<<<<<<< HEAD
# find outlier using outlier detection library


=======
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
>>>>>>> d0d6ceb5516d59518818e09a038d62e97f08a556

# print fit time
proc.time() - ptm

# plot the forecast
plot(m, forecast)

# Stop the clock
proc.time() - ptm

