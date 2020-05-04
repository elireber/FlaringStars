from datetime import datetime
import os
import platform
import subprocess
from queue import Queue
from threading import Thread, Lock
from time import time
from os import listdir
from os.path import isfile, join
from random import randint
from time import sleep
import timeit

#CONFIGURATION PARAMETERS
threadCount     =   4
pathToR         =   "\"c:\Program Files\R\R-3.6.2\\bin\RScript.exe\""   #R's location on this machine
pathToData      =   "test_data"                                         #directory of the data files
pathToRScript   =   "dummy.R"                                           #R script to run on each file
pathToOutput    =   "test_output"                                       #directory of the output
########

#setup
time = datetime.now()
outFileName     =   "results" + str(time.year) + "-" + str(time.month) + "-" + str(time.day) + "-" + str(time.hour) + "-" + str(time.minute) + "-" + str(time.second) + ".out"
outString       =   "Results Generated on " + str(time) + "---\n"   #where the result will eventually be written
if platform.system() == 'Windows':
    fs = "\\" 
else:
    fs = "/"
dataFiles = [f for f in listdir(pathToData) if isfile(join(pathToData, f))]
flares          =   []                                              #list of files flagged as flares by the R script
notFlares       =   []                                              #list of files flagged as not flares
workQueue       =   Queue()                                         #multithreading work queue       
mutex           =   Lock()                                          #mutex lock for multithreading

#----worker thread
class RScriptWorker(Thread):

    def __init__(self, queue):
        Thread.__init__(self)
        self.queue = workQueue

    def run(self):
        while True:
            #get the next file name from the work queue
            file = self.queue.get()
            threadStart = timeit.default_timer()
            try:
                #make the R command and let the R script process the data file
                cmd = pathToR + " " + pathToRScript + " " + pathToData + fs + file
                subOutput = subprocess.check_output(cmd).decode('UTF-8')
                
                #simulate some random processing time (testing only)  
                sleep(randint(2,10))
                
                #right now it only checks output of R script for: 1 = flare 0 = not
                mutex.acquire()
                if str(subOutput[4]) == '1':
                    flares.append(file)
                else:
                    notFlares.append(file)
                mutex.release()    
                print("Processing file: {} ({} of {}) completed in {} seconds".format(file, len(flares)+len(notFlares), len(dataFiles),"%0.2f" % (timeit.default_timer() - threadStart)))
                
            finally:
                self.queue.task_done()
#--------------

#start the processing
print("Running DS440 Flare Stars Script v0.5")
print("Threads: ", threadCount)
print("Run start: ", time)
startTime = timeit.default_timer()

#make X threads listening to the work queue for data files
for x in range(threadCount):  
    thread = RScriptWorker(workQueue)
    thread.daemon = True
    thread.start()
    
#add each datafile to the work queue for threads
for file in dataFiles:
    workQueue.put(file)

#wait for all threads to finish
workQueue.join()
    
#make the results file    
outString = (outString + "Script Used: " + pathToRScript + "\n" 
    + "Files Tested: " + str(len(dataFiles)) + "\n"
    + "Flares Found: " + str(len(flares)) + "\n"
    + "Flare Files---" + "\n")
for flare in flares:
    outString = outString + flare + "\n"

#save(just printing for now) the results file
print(outString)
#f = open(outFileName,'w+')
#f.write(outString)
#f.close()
print("Program Complete, total runtime of %0.2f seconds." % (timeit.default_timer() - startTime))
print("Results file saved to " + outFileName)