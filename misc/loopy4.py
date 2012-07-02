from numpy import pi, exp
from Tkinter import *

root = Tk()

z = [200+200j, 250+150j, 300+200j, 250+250j, 150+150j, 100+200j, 150+250j]

W = 11
H = 6

z = W*[200+200j]

for k in range(1,H):
    z[k] = z[0] + 50 - 50*exp(2j*pi*k/H)
    z[k+W/2] = z[0] - 50 + 50*exp(-2j*pi*k/H)

def cabs(w):
    return w.real*w.real + w.imag*w.imag

def cross(a,b):
    return  a.real*b.imag - a.imag*b.real

def point(z,col="black"):
    x = z.real
    y = z.imag
    canv.create_oval(x-4,y-4,x+4,y+4,fill=col)


def draw1():
    canv.delete(ALL)
    curv(z,0,1,6,2)
    curv(z,1,2,0,3)
    curv(z,2,3,1,0)
    curv(z,3,0,2,4)
    curv(z,0,4,3,5)
    curv(z,4,5,0,6)
    curv(z,5,6,4,0)
    curv(z,6,0,5,1)

def draw():
    canv.delete(ALL)
    curv(z,0,1,10,2)
    curv(z,1,2,0,3)
    curv(z,2,3,1,4)
    curv(z,3,4,2,5)
    curv(z,4,5,3,0)
    curv(z,5,0,4,6)
    curv(z,0,6,5,7)
    curv(z,6,7,0,8)
    curv(z,7,8,6,9)
    curv(z,8,9,7,10)
    curv(z,9,10,8,0)
    curv(z,10,0,9,1)

def curv(z,i,j,k,l):
    a = z[i]
    b = z[j]
    am = a + 0.2*(b - z[k])
    bp = b + 0.2*(a - z[l])
    point(a)
    point(b)
#    point(am,col='red')
#    point(bp,col='red')
    for n in range(11):
        t = 0.1*n
        w = a + t*(b-a)
        w = (1-t)**3 * a + 3*(1-t)**2*t * am + 3*(1-t)*t**2 * bp + t**3 * b
        if n > 0:
            canv.create_line(wo.real,wo.imag,w.real,w.imag)
        wo = w


def moved(event):
    w = event.x + 1j*event.y
    ds = 0
    for p in range(W):
        ds = cabs(w-z[p])
        if p==0 or ds<dsmin:
            dsmin = ds
            q = p
    z[q] = w
    draw()


canv = Canvas(root, width=400, height=400)
canv.bind("<B1-Motion>", moved)
canv.pack()
draw()
root.mainloop()

