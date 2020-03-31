library("changepoint")
library("tsoutliers")
library("dtw")
library("lubridate")
library("forecast")

# generate an outlier in a time series to run arima on
resid <- rep(c(-2,-1,0,1,2,1,0,-1),10)
resid <- resid + rnorm(length(resid), 0,0.25)

#plot(seq(0.1,20,0.3),dexp(seq(0.1,20,0.3)))

exp_outlier <- dexp(seq(0.5,20,0.1),3)[1:8]
plot(exp_outlier)

resid[25:(25+length(exp_outlier)-1)] <- resid[25:(25+length(exp_outlier)-1)] + exp_outlier

fit <- auto.arima(resid)
tso_resid <- residuals(fit)
pars <- coefs2poly(fit)

tso_outliers <- locate.outliers(tso_resid, pars, cval=3.5, types = c("TC","AO"), delta = 0.5)
tso_outliers

plot(tso_resid)

