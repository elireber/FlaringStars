from datetime import datetime
from os import listdir
from os.path import isfile, join
time = datetime.now()
print("Running DS440 Flare Stars Batch Script v0.1")
print("Run start: ", time)

pathToR         =   "c:\Program Files\R\R-3.6.2\bin\R.exe"  #R's location on this machine
pathToData      =   "test_data"                             #directory of the data files
pathToRScript   =   "-"                                     #R script to run on each file
pathToOutput    =   "test_output"                           #directory of the output
outFileName     =   "results" + str(time.year) + "-" + str(time.month) + "-" + str(time.day) + "-" + str(time.hour) + "-" + str(time.minute) + "-" + str(time.second) + ".out"
outString       =   "Results Generated on " + str(time) + "---\n"   #where the result will eventually be written


dataFiles = [f for f in listdir(pathToData) if isfile(join(pathToData, f))]

for file in dataFiles:  
    #this is where we would run the R script for each input data file
    
    
    #this is where we process that output and record it to the new datafile
    print(file)

#save the datafile
f = open(outFileName,'w+')
f.write(outString)
f.close()
print("Program Complete")