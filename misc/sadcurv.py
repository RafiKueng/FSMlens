from numpy import pi, exp
from Tkinter import *

root = Tk()

H = 4
W = 2*H-1

M = [ 200+200j , 50+0j , -50+0j ]

r = W*[0j]
z = W*[M[0]]

for k in range(1,H):
    r[k] = exp(2j*pi*k/H)
    r[k+W/2] = exp(2j*pi*k/H)

def refresh():
    z[0] = M[0]
    for k in range(1,W):
        dr = r[k]
        if k < H:
            z[k] = M[0] + M[1] * (1 - dr)
        else:
            if (M[2]/M[1]).real < 0:
                dr = dr.conjugate()
            z[k] = M[0] + M[2] * (1 - dr)

def cabs(w):
    return w.real*w.real + w.imag*w.imag

def cross(a,b):
    return  a.real*b.imag - a.imag*b.real

def point(z,r=2,col="black"):
    x = z.real
    y = z.imag
    canv.create_oval(x-r,y-r,x+r,y+r,outline=col,fill=col)


def draw():
    canv.delete(ALL)
    refresh()
    curv(z,0,1,-1,2)
    curv(z,1,2,0,3)
    for k in range(2,H-2):
        curv(z,k,k+1,k-1,k+2)
    curv(z,H-2,H-1,H-3,0)
    curv(z,H-1,0,H-2,H)
    curv(z,0,H,H-1,H+1)
    curv(z,H,H+1,0,H+2)
    for k in range(H+1,2*H-3):
        curv(z,k,k+1,k-1,k+2)
    curv(z,-2,-1,-3,0)
    curv(z,-1,0,-2,1)

def curv(z,i,j,k,l):
    a = z[i]
    b = z[j]
    am = a + 0.2*(b - z[k])
    bp = b + 0.2*(a - z[l])
    point(a)
    point(b)
    for n in range(11):
        t = 0.1*n
        w = a + t*(b-a)
        w = (1-t)**3 * a + 3*(1-t)**2*t * am + 3*(1-t)*t**2 * bp + t**3 * b
        if n > 0:
            canv.create_line(wo.real,wo.imag,w.real,w.imag)
        wo = w
    point(M[0],r=4,col='red')
    point(M[0]+M[1],r=4,col='red')
    point(M[0]+M[2],r=4,col='red')


def moved(event):
    w = event.x + 1j*event.y
    dsmin = ds = cabs(w-M[0])
    q = 0
    for p in range(1,3):
        ds = cabs(w-M[p]-M[0])
        if ds<dsmin:
            dsmin = ds
            q = p
    for p in range(4,3+W):
        ds = cabs(w-z[p-3])
        if ds<dsmin:
            dsmin = ds
            q = p
    print q
    if dsmin > 100:
        return
    if q == 0:
        M[1] += M[0] - w
        M[2] += M[0] - w
        M[0] = w
    elif q < 3:
        M[q] += w - (M[q]+M[0])
    else:
        q -= 3
        if q < H:
            r[q] = 1 - (w-M[0])/M[1]
        else:
            r[q] = 1 - (w-M[0])/M[2]
            if (M[2]/M[1]).real < 0:
                r[q] = r[q].conjugate()
    draw()



canv = Canvas(root, width=400, height=400)
canv.bind("<B1-Motion>", moved)
canv.pack()
draw()
root.mainloop()

