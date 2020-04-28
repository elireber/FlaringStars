library("changepoint")
library("tsoutliers")
library("dtw")
library("lubridate")
library("forecast")

# generate an outlier in a time series to run arima on
sequence <- c(seq(-2,2,0.5), seq(1.5,-1.5,-0.5))
resid <- rep(sequence,20)
resid1a <- resid + rnorm(length(resid), 0,.2)

# generate the flare shape - 2 hour decay
exp_outlier <- 3 * dexp(seq(0.5,20,0.1),2)[1:8]
#plot(exp_outlier)

# set the flare position
position <- 30

# duplicate the original residuals 
resid1 <- resid1a

# insert the flare into the assigned position
resid1[position:(position+length(exp_outlier)-1)] <- resid1[position:(position+length(exp_outlier)-1)] + exp_outlier

# fit using arima
fit1 <- auto.arima(resid1, max.order = 10, stepwise = F)

# Get the residuals from arima
tso_resid1 <- residuals(fit1)

# get the mean of the residuals
mean(abs(tso_resid1) / sequence)

# get the parameters for the outliers library
pars <- coefs2poly(fit1)

# test tsoutliers ovre the residuals
tso_outliers <- locate.outliers(tso_resid, pars, cval=3.5, types = c("TC","AO"), delta = 0.5)
tso_outliers

# plot the residuals example
par(mfrow=c(2,2))
plot(c(rep(0,position), exp_outlier, rep(0,80 - position - 8)), type = "l", main="Flare Shape")
# raw data 
plot(resid1a[1:80], type = "l",main="Raw Data (No Flare)")
# raw with flare
plot(resid1[1:80], type = "l", main="Raw Data (With Flare)")
abline(v=position, lty=2, col="red")
# resids
plot(tso_resid1[1:80], type = "l", main="Residuals")
abline(v=position, lty=2, col="red")

# Measure of flare residuals
SNR <- max(tso_resid1) / IQR(tso_resid1)

# to do:
# Fix the Y label for the graphs
# ACF <- auto correlation function 
# IQR of the original data, and IQR of the final Residuals
# SNR of original vs SNR of the Final
# Toy examples 
# Look at some real stars
# Graph some of davenports stars

# plot for the 70k points
# plot(tso_resid1[1:80], pch=20, cex=0.5, col="#11111130",main="Residuals")

# acf(tso_resid1, xrange=c(1:30))
# SNR <- max(tso_resid1) / IQR(tso_resid1)


