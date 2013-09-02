#!/usr/bin/python
# Script for converting oommf vector files to bitmap
# Usage:
# batchcrop.py *.omf
# Otherwise it will make ./bmp and put the output bmp files there.
# TODO: 
# - Make a argparser
# - Use crop_dir variable in cmd_to_run output dir

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

# Create a folder in which to store the images (unless it already exists)
# make a new folder with the cropped images
path, dir = os.path.split(os.getcwd())
label_dir = './labeled'
    
if not os.path.exists(label_dir):
    os.makedirs(label_dir)

# Run imagemagick on each of the bmp images in the folder. Save the cropped 
# images to the new folder.
current_dir = os.getcwd()
for i, filename in enumerate(get_bmp(current_dir)): # loop through each file
    print "Working on file: " + filename
    fpath, filename = os.path.split(filename)
    cmd_to_run = 'convert ' + filename + ' -gravity South -annotate 0 \'%f\' ./labeled/labeled_' + filename
    subprocess.call(cmd_to_run, shell=True)
