#!/usr/bin/python
# Script for converting oommf vector files to bitmap
import subprocess
import os
import sys
import shutil
import glob

def get_bmp(path):
    # A function to find the omf magnetisation vector files in a particular folder.
    omf_path = '%s/*.bmp*' % (path)
    #create an array of file names based on the search for omf files.
    files_array = glob.glob(omf_path)
    return files_array

# Run the oommf conversion tool - this outputs to the current dir
# Watch out for windows paths with a backslash
# Edit the config file to set how the output bmp files will look.
cmd_to_run = 'tclsh C:/oommf-1.2a5/oommf.tcl avf2ppm -config C:/oommf-1.2a5/avf2ppm.config -format B24 -ipat %s' % sys.argv[1]
subprocess.call(cmd_to_run, shell=True)

# Create a folder in which to store the images (unless it already exists)
# I've added a bit to account for my different directory structures. 
# My current preferred way of doing things is to have the oommf output into ./raw
# so I can have the bmp files go into ../bmp. 
# The old style doesn't use the 'raw' folder so I just make './bmp' and put the 
# bmp files there.
path, dir = os.path.split(os.getcwd())
if  dir == 'raw':
	bmp_dir = '../bmp'
else:
	bmp_dir = './bmp'
	
if not os.path.exists(bmp_dir):
    os.makedirs(bmp_dir)

# move bitmaps to this tmp dir
current_dir = os.getcwd()
for i, filename in enumerate(get_bmp(current_dir)): # loop through each file
    shutil.move(filename, bmp_dir)
# avf2bmp.py