from Tkinter import *
 

class LensTemplate:
    def __init__(self,inPoints=[154+69j, 72+99j, 215+77j]):
        self.z0 =inPoints
        self.bezLine=[]
        for i in range(101):
            self.bezLine.append(0)    
        self.pnt=[0,0,0]
    """
    takes an complexnumber and returnes the mod. sqr of the given number
    """
    def modSQR(self,w):
        return w.real*w.real + w.imag*w.imag

    def draw(self):
        #print "bezLine",self.bezLine
        #print "pnt",self.pnt
        z=self.z0
        print z[0],z[1],z[2]
        #if(self.bezLine[0]!=0 or self.bezLine[1]!=0 or self.bezLine[2]!=0 or self.bezLine[3]!=0):
        #    canv.delete(self.pnt)
        
        if(self.pnt[0]!=0 or self.pnt[1]!=0 or self.pnt[2]!=0):
            canv.delete(self.pnt[0])
            canv.delete(self.pnt[1])
            canv.delete(self.pnt[2])
                        
        A = z[0]
        B = z[1] - A
        C = z[2] - A
        B2 = self.modSQR(B)
        C2 = self.modSQR(C)
        D = 2*(B.real*C.imag-B.imag*C.real)
        cen = 1j*(B*C2-C*B2)/D + A # fine the cenntere centre??
        #print cen
        a = z[0] - cen 
        b = z[1] - cen #first other point minima (H) or minima (L)
        c = z[2] - cen #seccond other point minima (H) or minima (L)
        b = a*pow(b/a,1.5) + cen;
        c = a*pow(c/a,1.5) + cen;
        a = z[0] #dis given as the saddel point (S)
        
        #create three "ovals" in the initially given place z
        self.pnt[0]=self.point(z[0])
        self.pnt[1]=self.point(z[1])
        self.pnt[2]=self.point(z[2])
    
        r = pow(self.modSQR(a-cen),0.5) #some sort of radius??
        bl = pow(self.modSQR(b-a),0.5) #an other radius??
        db = 0.25*bl*(b-cen)/r
        dz = 0.5*bl*(z[1]-cen)/r
        self.bezLine[0]=self.bezier(a,z[1]+dz,b+db,b) #draw Bezir curves
        self.bezLine[1]=self.bezier(a,z[1]-dz,b-db,b)
        cl = pow(self.modSQR(c-a),0.5)
        dc = 0.25*cl*(c-cen)/r
        dz = 0.5*cl*(z[2]-cen)/r
        self.bezLine[2]=self.bezier(a,z[2]+dz,c+dc,c) #draw Bezir curves
        self.bezLine[3]=self.bezier(a,z[2]-dz,c-dc,c)
    
    """
    Creates the Bezire lines on the screen
    Bezir Curves:
            B(t)=sum_{i=0}^{n}(n!/(i!(n-i)!))*(1-t)^(n-1)t^i*P_i
        we are using n=4 ==> use of 4 points
    """
    def bezier(self,p1,p2,p3,p4):
        for n in range(101):
            if(self.bezLine[n]!=0):
                #canv.delete(self.bezLine[n])
                pass
                
            t = 0.01*n #the stepp size is given by t. Where t is within [0,1] by definition of the bezier curve.
            w = pow(1-t,3)*p1 + 3*pow(1-t,2)*t*p2 + 3*(1-t)*pow(t,2)*p3
            w += pow(t,3)*p4
            if n > 0:
                self.bezLine[n]=canv.create_line(wo.real,wo.imag,w.real,w.imag)
            wo = w
            
    """
    Takes an imaginary number and creates an oval/point at the coordinates given by the real and imaginary value
    """
    def point(self, z):
        x = z.real
        y = z.imag 
        return canv.create_oval(x-4,y-4,x+4,y+4)
    
    """
       moves  
    """
    def moved(self, event):
        w = event.x + 1j*event.y
        ds = 0
        for p in range(3):
            ds = self.modSQR(w-self.z0[p])
            if p==0 or ds<dsmin:
                dsmin = ds
                q = p
        self.z0[q] = w #create new coordinates for the three points
        self.draw()
        
"""    
def createNew(event):
    a=complex(event.x,event.y)
    z=[a-30j,a,a+30]
    print z
    point(z[0])
    point(z[1])
    point(z[2])
    draw2(z)
"""
    
root = Tk()
canv = Canvas(root, width=700, height=500,bg = 'white')
lense=PhotoImage(file = 'logo.gif')
canv.create_image(50, 10, image = lense, anchor = NW)
ap1= LensTemplate()
ap2= LensTemplate()

canv.bind("<Double-Button-1>",ap2.moved)
canv.bind("<B1-Motion>", ap1.moved)
canv.pack(expand = YES, fill = BOTH)
ap1.draw()
root.mainloop()
