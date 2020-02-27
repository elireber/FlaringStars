install.packages("Hmisc")
library("Hmisc")

# set working directory to wherever your project is stored
setwd("~/Desktop/Flaring Stars/Team 2")

# test Pathnames
test_count <- 15
results_list <- sample(list.files("../Results_Files_1"), 10)

# test intervals
subset_count <- 20
test_interval <- 1:(71427/subset_count)


resid_list <- vector(mode="list", length=length(results_list))

for (test_num in 1:length(results_list)){
  load(paste("../Results_Files_1/", results_list[test_num],sep = ""))
  resid_list[test_num] <- list(results$ARFIMA$residuals[test_interval])
}

rcorr(cbind(do.call("cbind",resid_list)))




