install.packages("prophet")
library("prophet")

# set working directory to wherever your project is stored
setwd("~/Desktop/Flaring Stars/Team 2")

# test Pathnames
test_num <- 1
results_list <- c("000892713_results.Rdat", "001872210_results.Rdat", "001872078_results.Rdat")

# Load in the lightcurve residuals
lc = load(paste("../Results_Files_1/", results_list[test_num],sep = ""))
lc = results$Lightcurve
resid = results$ARFIMA$residuals



