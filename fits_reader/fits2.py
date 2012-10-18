# -*- coding: utf-8 -*-
"""
Created on Mon May 21 23:14:53 2012

@author: rafik
"""
import numpy as np
import cv2 #using the new pure numpy python interface to opencv
import pyfits #load after opencv, else runtime error
import os



def debug(str):
    print " | debug "+str


class imgData():
    def setData(self, _data):
        debug("imgData.setData")
        self.data = _data.astype('float32')
        self.norm = cv2.normalize(self.data, alpha=0.0, beta=1.0, norm_type=cv2.NORM_MINMAX)
        self.logged = cv2.normalize(np.log(np.clip(self.data, 10e-4, 10e+4)), alpha=0.0, beta=1.0, norm_type=cv2.NORM_MINMAX)
        self.dim = np.shape(self.data)
        self.nPix = self.dim[0] * self.dim[1]
        self.filename = ""        
        self.roi = None
        self.color = None


def savefile(img):
    
    cv2.imwrite(img.filename+'.png', img.color)
    pass


def colorfunct(c0, c1, c2, c3, c4, x):
    r=0
    g=0
    b=0
    
    if x < c1:
        r=0
        g=0
        b=255.0/(c1-c0)*(x-c0)
    elif x < c2:
        r=0
        g=255.0/(c2-c1)*(x-c1)
        b=255.0/(c1-c2)*(x-c2)
    elif x < c3:
        r=255.0/(c3-c2)*(x-c2)
        g=255.0/(c2-c3)*(x-c3)
        b=0
    else:
        r=255
        g=255.0/(c4-c3)*(x-c3)
        b=g
    
    return np.array((b,g,r), dtype=int)



def colorfunctArr(c0, c1, c2, c3, c4, x):
    #r1 =  
    #print "r1:", np.max(r1), np.min(r1)
    r = np.clip(
            (x<c3) * 1.0/(c3-c2)*(x-c2) + (x>=c3) * 1.0,
            0, 1)
    
    g = np.clip(
            (x<c2)          * 1.0/(c2-c1)*(x-c1) + 
            (x>=c2)*(x<c3)  * 1.0/(c2-c3)*(x-c3) + 
            (x>c3)          * 1.0/(c4-c3)*(x-c3),
            0,1)

    b = np.clip( 
            (x<c1)          * 1.0/(c1-c0)*(x-c0) + 
            (x>=c1)*(x<c2)  * 1.0/(c1-c2)*(x-c2) + 
            (x>c3)          * 1.0/(c4-c3)*(x-c3),
            0,1)

    return [r, g, b]

def colorfunctB(c0, c1, c2, c3, c4, x):
    if x < c1:
        return 255.0/(c1-c0)*(x-c0)
    elif x < c2:
        return 255.0/(c1-c2)*(x-c2)
    elif x < c3:
        return 0
    else:
        return 255.0/(c4-c3)*(x-c3)
    
    
def colorfunctR(c0, c1, c2, c3, c4, x):
    if x < c2:
        return 0
    elif x < c3:
        return 255.0/(c3-c2)*(x-c2)
    else:
        return 255
    
    
def colorfunctG(c0, c1, c2, c3, c4, x):
    if x < c1:
        return 0
    elif x < c2:
        return 255.0/(c2-c1)*(x-c1)
    elif x < c3:
        return 255.0/(c2-c3)*(x-c3)
    else:
        return 255.0/(c4-c3)*(x-c3)

c1=0
c2=0
c3=0
c4=0
c0=0

def adjColor(img):
    cv2.namedWindow('AdjustColor', flags=cv2.WINDOW_NORMAL)
    #print "picture infos:"
    #print np.shape(img.roi)
    #print np.max(img.roi)
    #print np.min(img.roi)
    
    #img.roi = np.array([range(800)]*6) / 800.0
    #print img.roi
    
    def update(dummy=None):

        c0 = cv2.getTrackbarPos('black', 'AdjustColor') /1024.#0.0
        c1 = cv2.getTrackbarPos('blue', 'AdjustColor') /1024.
        c2 = cv2.getTrackbarPos('green', 'AdjustColor') /1024.
        c3 = cv2.getTrackbarPos('red', 'AdjustColor') /1024.
        c4 = cv2.getTrackbarPos('white', 'AdjustColor') /1024. #1024.0/1024.
        
    #def updatePic():
        #r = np.array([colorfunctR(c0,c1,c2,c3,c4,d) for d in img.roi.flat]).reshape(img.roi.shape)
        #g = np.array([colorfunctG(c0,c1,c2,c3,c4,d) for d in img.roi.flat]).reshape(img.roi.shape)
        #b = np.array([colorfunctB(c0,c1,c2,c3,c4,d) for d in img.roi.flat]).reshape(img.roi.shape)
        
        #print c0, c1, c2, c3, c4
        r, g, b = colorfunctArr(c0,c1,c2,c3,c4,img.roi)        
        
        #print np.shape(img.roi)
        #print np.shape(r)
        #print r
    
        #print img.roi
        #print np.shape(img.roi)
        #print type(img.roi)
        #print img.roi.dtype
        #print np.max(img.roi), np.min(img.roi)      
        
        color = cv2.merge([b,g,r, np.array(img.roi, dtype=np.float64)])*255
        color = np.array(color, dtype=np.uint8)
        #print color
        #print np.shape(color)
        #print type(color)
        #print color.dtype
        #print np.max(color), np.min(color)
        cv2.imshow('AdjustColor', color)
        img.color = color   

        

    cv2.createTrackbar('black', 'AdjustColor', 0, 1024, update)
    cv2.createTrackbar('blue', 'AdjustColor', 0, 1024, update)
    cv2.createTrackbar('green', 'AdjustColor', 0, 1024, update)
    cv2.createTrackbar('red', 'AdjustColor', 0, 1024, update)
    cv2.createTrackbar('white', 'AdjustColor', 0, 1024, update)

    cv2.setTrackbarPos('black', 'AdjustColor', 0)
    cv2.setTrackbarPos('blue', 'AdjustColor', 500)
    cv2.setTrackbarPos('green', 'AdjustColor', 1000)
    cv2.setTrackbarPos('red', 'AdjustColor', 1010)
    cv2.setTrackbarPos('white', 'AdjustColor', 1024)
    
    update()
    while True:
        ch = 0xFF & cv2.waitKey()
        if ch == 27:
            ret_code = -1
            break
        if ch == ord(' '):
            ret_code = 0
            break
        update()

 
    cv2.destroyAllWindows()
    return ret_code
    

pt1 = (1,1)
pt2 = (2,2)
    
def selectROI(img):
    #display image
    
    cv2.namedWindow('SelectROI', flags=cv2.WINDOW_NORMAL)
    cv2.namedWindow('SelectedROI')
    #erd = cv2.erode(rszimg, )
    
    logmode = False
    
    def mouseEvent(event, x, y, flag, param):
        #print "mouse click", event, x, y, flag, param
        if flag!=0:
            #print dir(globals()['selectROI'])
            if flag==1: #left click:
                #print "left", x, y
                globals()['pt1'] = (x, y)
            if flag==2:#right click:
                #print "right", x, y
                globals()['pt2'] = (x, y)
            update()
    
    def update(dummy=None):
        #print "dummy", dummy
        
        if logmode:
            ii = img.logged
        else:
            ii = img.norm
            
        sz=5
        scalefact = cv2.getTrackbarPos('scale', 'SelectROI')
        iters = cv2.getTrackbarPos('erode iters', 'SelectROI')
        bright = cv2.getTrackbarPos('bright', 'SelectROI')

        rszimg = cv2.resize(ii, (0,0), fx=1.0/scalefact, fy=1.0/scalefact)

        rszimg = rszimg + rszimg * (bright/10.0)

        st = cv2.getStructuringElement(cv2.MORPH_DILATE, (sz, sz))
        res = cv2.morphologyEx(rszimg, cv2.MORPH_DILATE, st, iterations=iters)

        #print res
        #print pt1
        #print pt2
        
        cv2.rectangle(res, pt1, pt2, color=(1.0,1.0,1.0), thickness=1)
        
        cv2.imshow('SelectROI', res)
        
        img.roi = ii[pt1[1]*scalefact:pt2[1]*scalefact, pt1[0]*scalefact:pt2[0]*scalefact]
        cv2.imshow('SelectedROI', img.roi)


    cv2.createTrackbar('scale', 'SelectROI', 1, 10, update)
    cv2.setTrackbarPos('scale', 'SelectROI', 5)
    
    cv2.createTrackbar('bright', 'SelectROI', -10, 10, update)
    cv2.setTrackbarPos('bright', 'SelectROI', 0)
    
    cv2.createTrackbar('erode iters', 'SelectROI', 0, 10, update)  
    cv2.setTrackbarPos('erode iters', 'SelectROI', 1)
    

    cv2.setMouseCallback('SelectROI', mouseEvent)
    

    
    #cv2.resizeWindow('SelectROI', 800,800)
    print 'waiting for key'
    
    update()
    ret_code = -1
    while True:
        ch = 0xFF & cv2.waitKey()
        if ch == 27:
            ret_code = -1
            break
        if ch == ord(' '):
            ret_code = 0
            break
        if ch == ord('l'):
            logmode = not logmode
        update()
    
    cv2.destroyAllWindows()
    return ret_code
    

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


def readfile():

    while True:
        files = filter(lambda _:_.endswith('fits'), os.listdir('.'))
    
        print "\nselect file: (0 to reload)"    
        for i, file in enumerate(files):
            print "  {0:3}: {1}".format(i+1, file)
        sel1 = int(raw_input("> "))-1
        if sel1>=0:
          break
    
    hdulist = pyfits.open(files[sel1])

    print "\nThe file contains the following datasets, please select:\n(if unsure, use 1, resp the entry with name 'sci' and of type ImageHDU)\n"
    hdulist.info()
    sel2 = int(raw_input("\n> "))
    
    data = imgData()
    data.setData(hdulist[sel2].data)
    data.filename = files[sel1]
    data.datasetnr = sel2

    hdulist.close()

    #print 'read file.\ndata infos:'
    #data.printImgInfo()
    #print '\nnorm infos:'
    #data.printNormInfo()    
    
    return data

def testcol():
    for i in range(4*4+1):
        if i%4==0:
            print ">",
        else:
            print " ",
        print colorfunct(0,1,2,3,4,i/4.0)
    
    f = 13
    a = np.array([range(6)]*2)/5.0

    #r = np.array([colorfunctR(0,1,2,3,4,d) for d in a.flat]).reshape(a.shape)
    #g = np.array([colorfunctG(0,1,2,3,4,d) for d in a.flat]).reshape(a.shape)
    #b = np.array([colorfunctB(0,1,2,3,4,d) for d in a.flat]).reshape(a.shape)

    r, g, b = colorfunctArr(0,0.25,0.5,0.75,1.0,a)
    
    print a
    print r
    print g
    print b

def main():
    
    #testcol()
    #return

    print "select file"
    img = readfile()
    #img = readdemofile(2)
    
    print "select roi"
    ret_code = selectROI(img)
    
    if ret_code == -1:
        print "break at select roi"
        return -1  
        
    print "adjust color"
    ret_code = adjColor(img)
    
    if ret_code == -1:
        print "break adj color"
        return -1
        
    print "save file"
    savefile(img)

    print ""
    print "start again? (0=yes)"
    sel1 = int(raw_input("> "))
    if sel1==0:
      return 1
    
    return 0



def mainclass():
    pass

    
if __name__ == '__main__':

    ret = 1
    while ret == 1:
        print ""
        print ""
        print "..............starting over..............."
        print ""
        globals()['pt1'] = (1, 1)
        globals()['pt2'] = (2, 2)
        ret = main()
    os.sys.exit()
    #pass
else:
    mainclass()