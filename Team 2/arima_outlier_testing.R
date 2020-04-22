library("changepoint")
library("tsoutliers")
library("dtw")
library("lubridate")
library("forecast")

# generate an outlier in a time series to run arima on
sequence <- c(seq(-2,2,0.5), seq(1.5,-1.5,-0.5))
resid <- rep(sequence,5)
resid1a <- resid + rnorm(length(resid), 0,.2)
resid2a <- resid + rnorm(length(resid), 0,.2)
resid3a <- resid + rnorm(length(resid), 0,.2)

#plot(seq(0.1,20,0.3),dexp(seq(0.1,20,0.3)))

exp_outlier <- 1.15 * dexp(seq(0.5,20,0.1),2)[1:8]
plot(exp_outlier)

position <- 30

resid1 <- resid1a
resid2 <- resid2a
resid3 <- resid3a

resid1[position:(position+length(exp_outlier)-1)] <- resid1[position:(position+length(exp_outlier)-1)] + exp_outlier
resid2[position:(position+length(exp_outlier)-1)] <- resid2[position:(position+length(exp_outlier)-1)] + exp_outlier
resid3[position:(position+length(exp_outlier)-1)] <- resid3[position:(position+length(exp_outlier)-1)] + exp_outlier

fit1 <- auto.arima(resid1)
fit2 <- auto.arima(resid2)
fit3 <- auto.arima(resid3)

tso_resid1 <- residuals(fit1)
tso_resid2 <- residuals(fit2)
tso_resid3 <- residuals(fit3)

mean(abs(tso_resid1) / sequence)

pars <- coefs2poly(fit)

tso_outliers <- locate.outliers(tso_resid, pars, cval=3.5, types = c("TC","AO"), delta = 0.5)
tso_outliers

# residuals example
par(mfrow=c(2,2))
plot(c(rep(0,25), exp_outlier, rep(0,47)), type = "l", main="Flare Shape")
# first resids
plot(tso_resid1, main="Residuals 1")
abline(v=position, lty=2, col="red")
# second resids
plot(tso_resid2, main="Residuals 2")
abline(v=position, lty=2, col="red")
# 3rd resids
plot(tso_resid3, main="Residuals 3")
abline(v=position, lty=2, col="red")

mean(tso_resid1)
mean(tso_resid2)
mean(tso_resid3)

# residuals example 2
par(mfrow=c(2,2))
plot(c(rep(0,position), exp_outlier, rep(0,80 - position - 8)), type = "l", main="Flare Shape")
# raw data 
plot(resid3a, type = "l",main="Raw Data (No Flare)")
# raw with flare
plot(resid3, type = "l", main="Raw Data (With Flare)")
abline(v=position, lty=2, col="red")
# resids
plot(tso_resid3, type = "l", main="Residuals")
abline(v=position, lty=2, col="red")

