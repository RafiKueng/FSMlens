FITS FILE READER FOR PYTHON

Install Instructions
0.  Make sure you have:
    - python 2.7 (32bit on win)
    - numpy

-----------
    
1.  download and install pyfits
    http://www.stsci.edu/institute/software_hardware/pyfits/Download

1.a win) 
    use installer from download page
    
1.b lunix)
    no idea, use pip, easy_install or manually compile.
    see guide on download page
    
-----------
    
2.  download & install opencv

2.a win) use the superpack
    - unpack it to some $OPENCVPATH$
    - copy the python modules from $OPENCVPATH$\build\python to $PYTHONPATH$\Lib\site-packages
    - set system variables
        press win+pause, "extended system settings", "environment variables", under the section systemvariables:
        * click new, name: "OPENCV_DIR"; value: $OPENCVPATH$\build\x86\mingw
        * klick on path, edit, and add the following to the end:
          ;$OPENCV_DIR$\bin
      
      OR

        enter on commandline:
        setx -m OPENCV_DIR $OPENCVPATH$\build\x86\mingw
        setx -m path %path%;$OPENCVPATH$\build\x86\mingw\bin
   
    HINT:
    replace $OPENCVPATH$ and $PYTHONPATH$ with the folders you're using in your system:
    example:
    setx -m OPENCV_DIR D:\opencv\build\x86\mingw
    setx -m path %path%;D:\opencv\build\x86\mingw\bin
 
2.b linux) havent tried it yet, probably use sources and compile..
    see here:
    http://opencv.itseez.com/doc/tutorials/introduction/linux_install/linux_install.html#linux-installation
   
-----------

3. get some fits files
    - use some of the demo files rafik used here:
        * http://www.physik.uzh.ch/~rafik/FSMlens/fits_files/
    
    - get your own from
        * http://hla.stsci.edu/hlaview.html
        * http://archive.eso.org/archive/hst/search/
        * http://archive.stsci.edu/

-------------------
some links / dokus
-------------------

pyfits:
    http://www.stsci.edu/institute/software_hardware/pyfits/
    http://www.stsci.edu/institute/software_hardware/pyfits/Download
    http://stsdas.stsci.edu/download/docs/The_PyFITS_Handbook.pdf

opencv:
-   manual for python interface
    http://opencv.itseez.com/index.html
-   download link
    http://sourceforge.net/projects/opencvlibrary/files/opencv-win/

related to the fits file format:
-   fits library overview:
    http://fits.gsfc.nasa.gov/fits_libraries.html
    
related to hst: (key to detectors and apertures)
-   http://www.stsci.edu/hst/HST_overview/instruments/
