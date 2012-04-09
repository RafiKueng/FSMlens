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
import cv2 #using the new pure numpy python interface to opencv
import pyfits #load after opencv, else runtime error
import os


def debug(str):
    print " | debug "+str

class imgData:
    data = [] # original b/w image
    norm = [] #normalised data
    desc = ""
    filename = ""
    datasetnr = -1
    color = [] #using float values in entire project
    colorfn = [0,0,0] #maps grayscale value to rgb g -> [b,g,r]
    transform = []
    hist = []
    histfn = lambda x:x
    #mode = -1 #is this a regular picture (0) or a density map (1)
    
    def __init__(self):
        debug("init imgData")
        
    def setData(self, _data):
        debug("imgData.setData")
        self.data = _data.astype('float')
        self.norm = cv2.normalize(self.data, alpha=0.0, beta=1.0, norm_type=cv2.NORM_MINMAX)
        
    def setColorFn(self, _colorfn):
        debug("imgData.setColorFn")
        #print _colorfn
        self.colorfn = _colorfn
        
        self.colorImg()
        
    def colorImg(self):
        img = self.norm
        
        #self.color = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
                
        self.color = cv2.merge([self.colorfn[0](img),
                                self.colorfn[1](img),
                                self.colorfn[2](img)])

        #self.coloring_done = False;
    
    def getColorImg(self):
        pass
    
    def transformImg(self):
        pass

    def getTransformedImg(self):
        pass

    def getHist(self):
        pass
    
    def printInfo(self, data):
        print data
        print 'type:', type(data)
        print 'shape:', np.shape(data)
        print 'max:', np.max(data), 'min:', np.min(data)

    def printImgInfo(self):
        debug('imginfo:')
        self.printInfo(self.data)

    def printNormInfo(self):
        debug('norminfo:')
        self.printInfo(self.norm)

    def printColorInfo(self):
        debug('colorinfo:')
        self.printInfo(self.color)
        

        
        
#-----------------------------------------------------------------------------



def colorImage(imgData):
    
    text1 = ("blue", "green", "red")
    text2 = ("min", "max")
    coloring_done = False
    
    
    while not coloring_done:   
        
        print imgData.data
        print np.max(imgData.data)
        print np.shape(imgData.data)
        #showImg(imgData.data)

        
        print "\ncoloring image: select option"
        print "  1) bgr; linear; start, end value"
        #print "2: hsv linear"
        print "  3) bgr, own formula"
        if coloring_done: print "  0) ABORT"
        else: print "  0) DONE"

        sel = int(raw_input("> "))

        colorfn = [0,0,0]
        
        if sel == 1:
            text1 = ("blue", "green", "red")
            text2 = ("min", "max")
            fromto = [[0,0,0],[0,0,0]] #start and endvalue of colorrange

            print "enter the colorranges (color in float: 0..1)"

            for i in range(len(text2)):
                for j in range(len(text1)):
                    fromto[i][j] = np.array(input("enter {0} {1} value: > ".format(text1[j], text2[i])))
            
            for i in range(3):
                colorfn[i] = lambda grey: (fromto[1][i]-fromto[0][i]) * grey + fromto[0][i]
            
            coloring_done = True
            

        #elif sel == 2:
        #    pass
        
        elif sel == 3:
            print "please enter 3 valid function, mapping the gray input pixel value one of the three colors (in float)"
            print "example: blue> lambda gray: 1-gray+3"
            
            for i in range(3):
                colorfn[i] = input("{0}> ".format(text1[i]))
            
            coloring_done = True

        elif sel == 0:
            if coloring_done:
                break
            else:
                return
            
        else:
            print "no valid selection"
    
                
    imgData.setColorFn(colorfn)
    showImg(imgData.color)
    
def adjHistogram(imgData):
    while True:
        print "\n\najdusting histogram of file name {0} [{1}]".format(imgData.filename, imgData.datasetnr)
        print "  1) display histgram"
        print "  2) auto adjust"
        print "  3) set adjust function"
        print "  0) DONE"
        
        sel = int(raw_input("> "))
        
        if sel == 1:
            dispHistogram(imgData)
        
        elif sel == 2:
            pass
        elif sel == 3:
            colorImage(imgData)
        elif sel == 0:
            break
        else:
            print "no valid option"
    
    
def dispHistogram(imgData):

    n_bins = 1024
    bin_w = 2
    bin_max_h = 200
    bg_col = [70,255,255]
    
    
    imgData.printNormInfo()
    img = imgData.data   
    
    hist = cv2.calcHist(    [img.astype('float32')],
                            channels=[0],
                            mask=None,#mask=np.ones(img.size).astype('uint8'),
                            histSize=[n_bins], 
                            ranges=[0,1] )
    for i in xrange(len(hist)):
        print int(hist[i][0]),
        if i%10==9: print '\n'
    #maxs = np.argmax(hist)
    #hist[maxs] = -1*hist[maxs]//10
    #cv2.normalize(hist, hist, 0, 1, cv2.NORM_MINMAX);
    hist = cv2.normalize(hist, alpha=0.0, beta=1.0, norm_type=cv2.NORM_MINMAX)
    #for i in xrange(len(hist)):
    #    print hist[i]
    print np.min(hist)
    bin_count = hist.shape[0]
    #img = np.ones((int(bin_max_h*1.1), bin_count*bin_w, 3), np.uint8)*bg_col*255 #last list is background color
    img = np.ones((int(bin_max_h), bin_count, 3), np.uint8)*bg_col*255 #last list is background color

    #print hist
    for i in xrange(bin_count):
        val = hist[i]
        h = int(val*bin_max_h)
        #print h
        if h >=0:
            cv2.rectangle(  img, 
                        (i, int(bin_max_h)),
                        ((i+1), int(bin_max_h)-h),
                        color=[0]*3,
                        thickness=-1)  
        else:
            h*=-1
            cv2.rectangle(  img, 
                        (i, int(bin_max_h)),
                        ((i+1), int(bin_max_h)-h),
                        color=[0,0,255*255],
                        thickness=-1)              
                      
          #(i*bin_w+2, int(bin_max_h*1.1)), ((i+1)*bin_w-2, int(bin_max_h*1.1)-h), [int(255*255.0*i/bin_count)]*3, -1)
          
    #img = cv2.cvtColor(img, cv2.COLOR_HSV2BGR)
    cv2.imshow('hist', img)       

    
    print 'display histogram'
    cv2.waitKey()
        
        
def densityMap(imgData):
    pass
    


def editImage(imgData):

    
    while True:
        print "\n\nediting file name {0} [{1}]".format(imgData.filename, imgData.datasetnr)
        print "  1) adjust histogram"
        print "  2) Set color"
        #print "  3) Convert to Density map"
        print "  0) DONE"
        
        sel = int(raw_input("> "))
        
        if sel == 1:
            adjHistogram(imgData)
        
        elif sel == 2:
            colorImage(imgData)

        elif sel == 3:
            pass
        
        elif sel == 0:
            break
        
        else:
            print "no valid option"
    


def showImgData(imgData):
    windowname = "File: {0}".format(imgData.name)
    windownamehist = windowname + " Histogram"

    flags = 0
    cv2.namedWindow(windowname, flags)
    cv2.imshow(windowname, imgData.data)

    cv2.namedWindow(windownamehist, flags)
    cv2.imshow(windownamehist, imgData.getHist())

    cv2.waitKey(1)
    
def showImg(img):
    print type(img)
    print img
    print np.shape(img)
    print np.max(img), np.min(img)
    cv2.namedWindow("some img", 0)
    cv2.imshow("some img", img)
    cv2.waitKey()


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
    sel1 = int(raw_input("> "))
    
    hdulist = pyfits.open(files[sel1])

    print "\nThe file contains the following datasets, please select:\n(if unsure, use 1, resp the entry with name 'sci' and of type ImageHDU)\n"
    hdulist.info()
    sel2 = int(raw_input("\n> "))
    
    data = imgData()
    data.setData(hdulist[sel2].data)
    data.filename = files[sel1]
    data.datasetnr = sel2

    hdulist.close()

    print 'read file.\ndata infos:'
    data.printImgInfo()
    print '\nnorm infos:'
    data.printNormInfo()    
    
    return data
    
    
def readdemofile(nr):
    files = filter(lambda _:_.startswith('demo'), os.listdir('.'))
    img = cv2.imread(files[nr])
    if len(np.shape(img))==3:
        img=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    print "demo: fn: ", files[nr], "type", type(img)    
    data = imgData()
    data.setData(img)
    data.filename = 'demo.file'
    data.datasetnr = nr
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
    while True:  
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
        print "9x) DEBUG: load DEMO image nr x"
        print "0) QUIT (without saving)"
        
        sel = int(raw_input("> "))
        
        if sel==1:
            #select image
            img = readfile()
            imagelist.append(img)
            
            #print type(img.data)
            #showImg(img.data)
            
            #directly go to the edit image section with current
            editImage(img)


        elif sel==2:
            print "\nenter image nr to edit:"
            sel2 = int(raw_input("> "))
            editImage(imagelist[sel2])

        elif sel==3:
            print "\nenter image nr to remove:"
            sel2 = int(raw_input("> "))
            imagelist.pop(sel2)
            
        elif sel==9:
            break #continue with program
            
        elif sel==0:
            return -1 #abort program

        elif sel//10==9:
            img = readdemofile(sel%10)
            imagelist.append(img)
            editImage(img)            
        else:
            print "no valid selection"
    
    return 0
        
    
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
    os.sys.exit(main())
    #pass
else:
    mainclass()
