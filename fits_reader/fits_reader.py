"""
Fits file reader and extractor

conventions:
- only use float values thouout the project for image / colordata
- use wcs for image pos, map to pixel x/y (for transform)

v1 2012-03-12 23:50 basic file opening, display, saving
v2 2012-04-02 12:00 advanced options, multiple fitsfiles edit and merge
@author: Rafael Kueng
"""


import numpy as np
import pyfits
import cv2 #using the new pure numpy python interface to opencv
import os


class imgData:
    data = [] # original b/w image
    desc = ""
    filename = ""
    datasetnr = -1
    color = [] #using float values in entire project
    colorfn = lambda x:[x,x,x] #maps grayscale value to rgb g -> [b,g,r]
    transform = []
    hist = []
    histfn = lambda x:x
    mode = -1 #is this a regular picture (0) or a density map (1)
    
    def __init__(self, _data):
        self.data = _data.astype('float')
        
    def colorImg(self):
        self.coloring_done = False;
        while not self.coloring_done:            
            print "coloring image\n"
            print "select option:"
            print "1: bgr, start, end value, linear"
            #print "2: hsv linear"
            print "3: bgr, own formula"
            print "0: DONE"

            sel = int(raw_input("\n>"))

            self.colorfn = [0,0,0]
    
            if sel == 1:
                print "enter an array from [b, g, r] for the min values"
                bgr_from = np.array(input("\n>"))
                print "enter an array to [b, g, r] for the max values"
                bgr_to = np.array(input("\n>"))
                self.colorfn = lambda grey: bgr_to * grey + bgr_from
    
            #elif sel == 2:
            #    pass
            
            elif sel == 3:
                print "please enter a valid function, mapping one input value to 3 output values"
                print "example: lambda gray: [1-gray, gray, 1-gray/2]"
                self.colorfn = input("\n>")
            else:
                self.coloring_done = True
        
        
    
    def getColorImg(self):
        pass
    
    def transformImg(self):
        pass

    def getTransformedImg(self):
        pass

    def getHist(self):
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
    elif sel == 2:
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
    files = filter(lambda _:_.endswith('fits'), os.listdir('.'))
    
    print "\nselect file:"    
    for i, file in enumerate(files):
        print "  {0}: {1}".format(i, file)
    sel1 = int(raw_input(">"))
    
    hdulist = pyfits.open(files[sel1])

    print "\nThe file contains the following datasets, please select:\n(if unsure, use 1, resp the entry with name 'sci' and of type ImageHDU)\n"
    hdulist.info()
    sel2 = int(raw_input("\n>"))
    
    data = imgData(hdulist[sel2].data)
    data.filename = files[sel1]
    data.datasetnr = sel2

    hdulist.close()
    
    return data
    
    
"""    
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
"""
    
def main():
    imagelist = []
    selection_finished = False
    while not selection_finished:  
        print "\n\nCreate picture\n=============="
        if len(imagelist)>0:
            print "\noverview:"
            for i, f in enumerate(imagelist):
                print "   image {0}: {1} [{2}]".format(i, f.filename, f.datasetnr)
        print "\nselect a task:"
        print "1) add image"
        if len(imagelist)>0:
            print "2) edit image"
            print "3) remove image"
            print "9) finish (merge and cut)"
        print "0) QUIT (without saving)"
        
        sel = int(raw_input(">"))
        
        if sel==1:
            imagelist.append(readfile())


        elif sel==2:
            print "\nenter image nr to edit:"
            sel2 = int(raw_input(">"))

        elif sel==3:
            print "\nenter image nr to remove:"
            sel2 = int(raw_input(">"))
            imagelist.pop(sel2)
            
        elif sel==9:
            selection_finished=True
            
        elif sel==0:
            return 0

        else:
            pass
    
    
        
    
    #while not done
        #select image
        #transform image
        #edit image
        #preview
    
    #merge images
    #cut image


"""
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
"""

def mainclass():
    pass

    
if __name__ == '__main__':
    main()
else:
    mainclass()
