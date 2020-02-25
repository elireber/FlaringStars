import pandas as pd
import os
import shutil

# import the davenport stars into a list of their KIC numbers
davenport = pd.read_csv("KIC_stars.csv", dtype={"KIC":int})
davenport_stars = davenport.KIC.values.tolist()
print(davenport_stars[0:10])


# import all the files in the directory
file_list = os.listdir("/Volumes/Seagate Backup Plus Drive/STAR DATA/Results_Files_6")

#print(type(davenport_stars[0])) # Both are string types
#print('10005966' in davenport_stars)
#print(len(file_list))

# initialize the test set list of filenames
test_set = []

for file in file_list:
    file_name = str(int(file.split(sep="_")[0]))
    if file_name in davenport_stars:
        print(file_name)
        test_set.append(file)

print(len(test_set))

"""
for item in test_set:
    shutil.copy("/Volumes/Seagate Backup Plus Drive/STAR DATA/" + item, '/Volumes/Seagate Backup Plus Drive/STAR DATA/test_set')

print(len(os.listdir('/Volumes/Seagate Backup Plus Drive/STAR DATA/test_set')))

""" 
