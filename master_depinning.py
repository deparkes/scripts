# This script runs three analysis subscripts:
# 1. odt2dat.py
# 2. avf2bmp.py *.omf
# 3. bmp2avi.py
# Go to /raw folder for that experiment
import subprocess
import os

# Convert odt files to .dat with odt2dat.py
subprocess.call("odt2dat.py", shell=True)

	
# Convert omf files to bmp with avf2bmp.py *.bmp
subprocess.call("avf2bmp.py *.omf", shell=True)

# change to the bmp directory
os.chdir('../bmp')
	
# convert bmpfiles to avi with bmp2avi.py
subprocess.call("bmp2avi.py", shell=True)