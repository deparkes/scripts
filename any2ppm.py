#!/usr/bin/python
import subprocess
import sys
import glob
import os
# Script to call any2ppm

def get_omf(path):
    # A function to find the omf magnetisation vector files in a particular folder.
    # Since I only want one I have an if statement to try and protect things. Needs improvements.
    # Use os.path.basename(path) to strip away everything but the file name from the path.
    # print os.getcwd()
    # os.chdir('../output/15um90umBarWithCrosses.bmp/strain_0');
    omf_path = '%s/*.omf' % (path)
    #create an array of file names based on the search for omf files.
    files_array = glob.glob(omf_path)
    return files_array

def do_avf2ppm(files):
    if not files:
        avf = raw_input('Please give avf to work on')
    else:
        avf = os.path.abspath(files)
        
    options = '-format B24'
    tcl_path = os.path.abspath('C:\\Tcl\\bin\\tclsh85')
    avf2ppm_path = os.path.abspath('C:\\oommf\\oommf.tcl avf2ppm %s %s' % (options, avf))
    print tcl_path + ' ' + avf2ppm_path
    subprocess.call(tcl_path + ' ' + avf2ppm_path, shell=True)

def main(argv):

    if os.path.isfile(argv[1]):
        do_avf2ppm(argv[1])
    elif os.path.isdir(argv[1]):
        file_list = get_omf(argv[1])
    else:
        print "You didn't give a valid file or directory"

if __name__ == "__main__":
    main(sys.argv)
