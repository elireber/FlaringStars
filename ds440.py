from datetime import datetime
import os
import platform
import subprocess
from os import listdir
from os.path import isfile, join
time = datetime.now()
print("Running DS440 Flare Stars Batch Script v0.2")
print("Run start: ", time)

pathToR         =   "\"c:\Program Files\R\R-3.6.2\\bin\RScript.exe\""    #R's location on this machine
pathToData      =   "test_data"                                     #directory of the data files
pathToRScript   =   "dummy.R"                                       #R script to run on each file
pathToOutput    =   "test_output"                                   #directory of the output
outFileName     =   "results" + str(time.year) + "-" + str(time.month) + "-" + str(time.day) + "-" + str(time.hour) + "-" + str(time.minute) + "-" + str(time.second) + ".out"
outString       =   "Results Generated on " + str(time) + "---\n"   #where the result will eventually be written
if platform.system() == 'Windows':
    fs = "\\" 
else:
    fs = "/"
dataFiles = [f for f in listdir(pathToData) if isfile(join(pathToData, f))]
flares = []
notFlares = []
i = 1
for file in dataFiles:  
    #run the R script for each input data file
    cmd = pathToR + " " + pathToRScript + " " + pathToData + fs + file
    
    subOutput = subprocess.check_output(cmd).decode('UTF-8')
    #process that output and record it to the new datafile
    
    #**********this is a clumsy workaround and is just for test purposes- 
    #will need to figure out how better to parse the R subprocess output later if we want to save other things
    #print(subOutput)
    if str(subOutput[4]) == '1':
        flares.append(file)
    else:
        notFlares.append(file)

   
    print("Processing file: " + file + "("+ str(i) + " of " + str(len(dataFiles)) + ") completed")
    i = i+1
    
#make the results file    
outString = (outString + "Summary:\nScript Used: " + pathToRScript + "\n" 
    + "Files Tested: " + str(len(dataFiles)) + "\n"
    + "Flares Found: " + str(len(flares)) + "\n"
    + "Flare Files---" + "\n")
for flare in flares:
    outString = outString + flare + "\n"



#save the results file
f = open(outFileName,'w+')
print(outString)
#f.write(outString)
f.close()
print("Program Complete, results file saved to " + outFileName)