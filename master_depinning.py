# This script runs three analysis subscripts:
# 1. odt2dat.py
# 2. avf2bmp.py *.omf
# 3. bmp2avi.py
# Go to /raw folder for that experiment
# TODO:
# - Also include generation of matlab files
import subprocess
import os
import glob

def get_bmp(path):
    # A function to find the omf magnetisation vector files in a particular folder.
    # Since I only want one I have an if statement to try and protect things. Needs improvements.
    # Use os.path.basename(path) to strip away everything but the file name from the path.
    # print os.getcwd()
    # os.chdir('../output/15um90umBarWithCrosses.bmp/strain_0');
    omf_path = '%s/*.bmp' % (path)
    #create an array of file names based on the search for omf files.
    files_array = glob.glob(omf_path)
    return files_array


# Convert odt files to .dat with odt2dat.py
print "Convert data table to .dat format"
subprocess.call("odt2dat.py", shell=True)

# Convert omf files to bmp with avf2bmp.py *.bmp
print "Convert omf vector files to bitmaps"
subprocess.call("avf2bmp.py *.omf", shell=True)

# change to the bmp directory
os.chdir('../bmp')
	
# convert bmpfiles to avi with bmp2avi.py
print "Convert bitmap images to a video"
subprocess.call("bmp2avi.py", shell=True)

# Delete bmp files as they take up so much room.
print "Remove bmp files as they take up so much room"
current_dir = os.getcwd()
for i, filename in enumerate(get_bmp(current_dir)): # loop through each file
    os.remove(filename)