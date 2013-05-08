REM -ipat is needed in windows to accept glob-style wild cards
tclsh C:\oommf-1.2a5\oommf.tcl avf2ppm -config  C:\oommf-1.2a5\avf2ppm.config -format B24 -ipat %*

REM Create destination folder
if not exists ..\bmp mkdir ..\bmp

REM Copy all created bmp files to output folder
for /R . %%f in (*.omf) do copy %%f ..\bmp

REM tclsh C:\oommf-1.2a5\oommf.tcl
