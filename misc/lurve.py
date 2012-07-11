class Lurve:

    def __init__(self,canv,loc):
        self.canv = canv
        self.M = [loc[0],loc[1]/2,loc[2]/2]
        self.next = [None,None,None]
        self.par = [None,1,1]
        H = 5
        W = 2*H-1
        self.H = H
        self.W = W
        r = W*[0j]
        for k in range(1,H):
            r[k] = 1-exp(2j*pi*k/H)
            r[k+W/2] = 1-exp(2j*pi*k/H)
        self.r = r
        self.z = W*[0j]
        
    def breed(self,k):
        M = self.M
        loc = [M[0]+M[k],M[1],M[2]]
        self.next[k] = Lurve(self.canv,loc)

    def trace(self,opar=1):
        H = self.H
        W = self.W
        M = self.M
        r = self.r
        z = self.z
        next = self.next
        for k in (1,2):
            if next[k]:
                M[k] = next[k].M[0] - M[0]
        z[0] = M[0]
        par = [None,opar,opar]
        if (M[2]/M[1]).real > 0:
            if abs(M[1]) < abs(M[2]):
                par[1] *= -1
            else:
                par[2] *= -1
        self.par = par
        for k in range(1,W):
            if k < H:
                z[k] = M[0] + M[1] * r[k]
            else:
                if par[1]*par[2] == -1:
                    z[k] = M[0] + M[2] * r[k]
                else:
                    z[k] = M[0] + M[2] * r[k].conjugate()
        self.curv(z,0,1,-1,2)
        self.curv(z,1,2,0,3)
        for k in range(2,H-2):
            self.curv(z,k,k+1,k-1,k+2)
        self.curv(z,H-2,H-1,H-3,0)
        self.curv(z,H-1,0,H-2,H)
        self.curv(z,0,H,H-1,H+1)
        self.curv(z,H,H+1,0,H+2)
        for k in range(H+1,2*H-3):
            self.curv(z,k,k+1,k-1,k+2)
        self.curv(z,-2,-1,-3,0)
        self.curv(z,-1,0,-2,1)
        if next[1]:
            next[1].trace(par[1]);
        if next[2]:
            next[2].trace(par[2]);
            
    def point(self,z,r=2,col="black"):
        x = z.real
        y = z.imag
        self.canv.create_oval(x-r,y-r,x+r,y+r,outline=col,fill=col)


    def curv(self,z,i,j,k,l):
        a = z[i]
        b = z[j]
        am = a + 0.2*(b - z[k])
        bp = b + 0.2*(a - z[l])
        self.point(a)
        self.point(b)
        for n in range(11):
            t = 0.1*n
            w = a + t*(b-a)
            w = (1-t)**3 * a + 3*(1-t)**2*t * am + 3*(1-t)*t**2 * bp + t**3 * b
            if n > 0:
                self.canv.create_line(wo.real,wo.imag,w.real,w.imag)
            wo = w
        M = self.M
        self.point(M[0],r=4,col='green')
        for k in (1,2):
            if not self.next[k]:
                if self.par[k]==1:
                    self.point(M[0]+M[k],r=4,col='blue')
                if self.par[k]==-1:
                    self.point(M[0]+M[k],r=4,col='red')

    def closep(self,w):
        M = self.M
        loop,ix,ds = (self,0,abs(M[0]-w))
        for k in (1,2):
            if self.next[k]:
                child,k,dstry = self.next[k].closep(w)
                if dstry < ds:
                    loop,ix,ds = (child,k,dstry)
            else:
                dstry = abs(M[0]+M[k]-w)
                if dstry < ds:
                    loop,ix,ds = (self,k,dstry)
        return (loop,ix,ds)

    def closez(self,w):
        z = self.z
        loop,ix,ds = (self,1,abs(z[1]-w))
        for k in range(2,self.W):
            dstry = abs(z[k]-w)
            if dstry < ds:
                loop,ix,ds = (self,k,dstry)
        for k in (1,2):
            if self.next[k]:
                child,k,dstry = self.next[k].closez(w)
                if dstry < ds:
                    loop,ix,ds = (child,k,dstry)
            else:
                dstry = abs(M[0]+M[k]-w)
                if dstry < ds:
                    loop,ix,ds = (self,k,dstry)
        return (loop,ix,ds)

from numpy import pi, exp
from Tkinter import *
root = Tk()
canv = Canvas(root, width=400, height=400)

lemur = Lurve(canv,[200+200j,-150+0j,-50+0j])

def moved(event):
    w = event.x + 1j*event.y
    loop,q,ds = lemur.closep(w)
    if (ds < 20):
        M = loop.M
        if q == 0:
            M[1] += M[0] - w
            M[2] += M[0] - w
            M[0] = w
        else:
            M[q] += w - (M[q]+M[0])
    draw()

def dclick(event):
    w = event.x + 1j*event.y
    loop,ix,ds = lemur.closep(w)
    loop.breed(ix)
    draw()


def draw():
    canv.delete(ALL)
    lemur.trace(1)

canv.bind("<B1-Motion>", moved)
canv.bind("<Double-Button-1>", dclick)
canv.pack()
draw()

root.mainloop()

