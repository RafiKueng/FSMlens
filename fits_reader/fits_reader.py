"""
Fits file reader and extractor

v1 2012-03-12 23:50 basic file opening, display, saving
v2 2012-04-02 12:00 advanced options, multiple fitsfiles edit and merge
@author: Rafael Kueng
"""


import numpy as np
import pyfits
import cv2 #using the new pure numpy python interface to opencv


class imgData:
    data = []
    desc = ""
    filename = ""
    datasetnr = -1
    color = [255,255,255]
    transform = []
    hist = []
    histfn = lambda x:x
    
    def __init__(self):
        pass

    def __call__(self):
        return data
        
    def colorImg(self):
        pass
    
    def getColorImg(self):
        pass
    
    def transformImg(self):
        pass

    def getTransformedImg(self):
        pass

    def getHist(self)
        pass


def colorImg(imgData):
    pass
    
def adjHistogram(imgData):
    pass
    
def densityMap(imgData):
    pass
    


def editFile(imgData):
    print "edit file name {0}, datasetnr {1}".format(imgData.desc, imgData.datasetnr)
    print "\n"
    print "1: adjust histogram"
    print "2: create Density map"
    sel = int(raw_input("\n>"))
    if sel == 1:
        pass
    else if sel == 2:
        pass
    
    print "choose color"
    col_r = int(raw_input("\nred>"))
    col_g = int(raw_input("\ngreen>"))
    col_b = int(raw_input("\nblue>"))


def showImg(imgData):
    windowname = "File: {0}".format(imgData.name)
    windownamehist = windowname + " Histogram"

    flags = 0
    cv2.namedWindow(windowname, flags)
    cv2.imshow(windowname, imgData())

    cv2.namedWindow(windownamehist, flags)
    cv2.imshow(windownamehist, imgData.getHist())

    cv2.waitKey(1)


def merge(listOfImgData):
    for imgData in listOfImgData:
        pass

def cut(imgData):
    pass
    
        
def readfile():

    hdulist = pyfits.open('ib0r02010_drz.fits')

    print "\nThe file contains the following datasets, please select:\n(if unsure, use 1, resp the entry with name 'sci' and of type ImageHDU)\n"
    hdulist.info()
    sel = int(raw_input("\n>"))

    # output some useful information about the selected dataset
    header = hdulist[sel].header
    #print '\nYour selection has the following target:'
    #print header['targname']
    print '\nprinting out all the cards:'
    print header.ascardlist()


    # getting the data
    # TODO: some error correction if wrong selection done!!
    scidata = hdulist[sel].data
    print "\n\nGot data.."
    print "   - of shape:", np.shape(scidata)
    print "   - of type:", scidata.dtype.name


    #cleaning up
    hdulist.close()

    return scidata

def main():
    data = readfile()

    flags = 0 #cv2.CV_WINDOW_NORMAL | cv2.CV_WINDOW_KEEPRATIO | cv2.CV_GUI_EXPANDED
    cv2.namedWindow('FITS', flags)
    cv2.imshow('FITS', data)
    print "press space to save the file to out.jpg"
    ch = cv2.waitKey()
    if ch == ord(' '):
        # TODO: need to check if format is right, probably need to convert first using cvtColor...
        cv2.imwrite('out.jpg', data)
    #if ch == 27:
    #    break

if __name__ == '__main__':
    main()
else:
    mainclass()
