# FlaringStars
Team 1 - Repeat Davenport's experiment
Team 2 - Try some new method

Team 1:
The whole completed work is called Light_Curve_Filtering.RMD

Team 2 folder:
synthetic_ARIMA.Rmd
  - primary work file
  - in this file we generate the 1000 flares for each intensity 
  - generate flare profiles
  - Calculate SNR

arima_outlier_testing.R / arima_testing_markdown.Rmd
  - Toy examples of the synthetic data generation
  - Used to generate plots for the slides
  
outlier_library_testing.R
  - examining tsoutliers performance on the kepler residuals
  - looking at the distribution of outliers compared to davenports catalogue
  
prophet_testin.R
  - testing the prophet library for changepoint detection
  
Residual Correlation Test.R
  - Checking to see if there was any correlation between the residuals of different stars -> there wasn't
  
  
Other:
test_set_scripts
 - Used to separate the test data (Davenport) from all the kepler data
 
KARPS_Davenport
 - Test set data
 
Synth_profiles
 - Contains 1000 synth profiles for each intensity tested
 

