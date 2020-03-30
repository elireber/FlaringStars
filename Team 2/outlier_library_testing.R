#install.packages("tsoutliers")
#install.packages("changepoint")
#install.packages("dtw")
#install.packages("lubridate")

library("changepoint")
library("tsoutliers")
library("dtw")
library("lubridate")

set.seed(42)

# set working directory to wherever your project is stored
setwd("~/Desktop/Flaring Stars/Team 2")

# test Pathnames
test_count <- 1
results_list <- sample(list.files("../KARPS_Davenport"), test_count)
test_num <-1

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
subset_count <- 10
test_interval <- 1:(71427/subset_count)

# Load in the lightcurve residuals
lc <- load(paste("../KARPS_Davenport/", results_list[test_num],sep = ""))
lc <- results$Lightcurve
resid <- results$ARFIMA$residuals

# create a list of dates for the df
#time_from_start <- seq(ymd_hm('0000-01-01 00:00'),ymd_hm('0004-12-31 23:45'), by = '15 mins')[1:length(resid)]

# create a df from the residuals
#df <- data.frame("ds" = time_from_start[test_interval], "y" = resid[test_interval])

#resid_list <- rep(0,length(results_list))
# get a list of the residuals 
#for (test_num in 1:length(results_list)){
#  load(paste("../KARPS_Davenport/", results_list[test_num],sep = ""))
#  resid_list[test_num] <- list(results$ARFIMA$residuals[test_interval])
#}
# start the clock
#ptm <- proc.time()

#tso_outliers <- tso(window(resid,2000,3000), pars= c(0,0,0), types = c("TC"))
#tso_outliers

#tso_outliers <- outliers(type = c("TC"), ind=resid[2000:3000])
#tso_outliers

ptm <- proc.time()

fit <- arima(resid, order = c(0,0,0))
tso_resid <- residuals(fit)
pars <- coefs2poly(fit)
#tso_outliers <- locate.outliers(tso_resid, pars, cval=3.5, types = c("TC"), delta = 0.7)
tso_outliers <- locate.outliers(tso_resid, pars, cval=3.5, types = c("TC"), delta = 0.5)
#tso_outliers

#tso_outliers$ind[tso_outliers$coefhat > 1]

# print time
proc.time() - ptm

length(tso_outliers$ind[tso_outliers$coefhat > 1]) - length(tso_outliers$ind[tso_outliers$coefhat < 1])

#################################
#        BIAS OF OUTLIERS       #
#################################

results_list <- list.files("../KARPS_Davenport")
davenport_predicted <- read.csv(file = '../test_set_scripts/davenport_KIC.csv')

bias_vs_flares<-c("NFL","NFL68",'bias')
count <- 1

for (file in results_list){
  KIC_num <- strsplit(file,'_')
  results_NFL <- subset(davenport_predicted, KIC == as.integer(KIC_num[[1]][1]))[["Nfl"]]
  results_NFL68 <- subset(davenport_predicted, KIC == as.integer(KIC_num[[1]][1]))[["Nfl68"]]

  load(paste("../KARPS_Davenport/",file,sep = ""))
  resid <- results$ARFIMA$residuals
  
  fit <- arima(resid, order = c(0,0,0))
  tso_resid <- residuals(fit)
  pars <- coefs2poly(fit)

  tso_outliers <- locate.outliers(tso_resid, pars, cval=3.5, types = c("TC"), delta = 0.5)
  
  bias <- length(tso_outliers$ind[tso_outliers$coefhat > 1]) - length(tso_outliers$ind[tso_outliers$coefhat < 1])
  
  bias_vs_flares <- rbind(bias_vs_flares, c(as.integer(results_NFL), as.integer(results_NFL68), as.integer(bias)))
  
  if(count %% 10 == 0){
    print(count / length(results_list))
  }
  count <- count + 1
}

bias_vs_flares

#################################
#              END              #
#################################

# Look at different transformations

bias <- read.csv("bias.csv")

sum(-1000 < bias$bias & bias$bias < 1000 )
hist(bias$bias[-1000 < bias$bias & bias$bias < 1000])
mean(bias$bias[-1000 < bias$bias & bias$bias < 1000])


