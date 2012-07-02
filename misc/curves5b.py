from Tkinter import *
 
root = Tk()

z = [10+10j, 50+250j, 200+150j, 290+290j]
z = [154+69j, 72+99j, 215+77j]


def cabs(w):
    return w.real*w.real + w.imag*w.imag

def cross(a,b):
    return  a.real*b.imag - a.imag*b.real

def draw():
    print z[0],z[1],z[2]
    canv.delete(ALL)
    A = z[0]
    B = z[1] - A
    C = z[2] - A
    B2 = cabs(B)
    C2 = cabs(C)
    D = 2*(B.real*C.imag-B.imag*C.real)
    cen = 1j*(B*C2-C*B2)/D + A
    print cen
    point(cen,"red")
    a = z[0] - cen
    b = z[1] - cen
    c = z[2] - cen
    b = a*pow(b/a,1.5) + cen;
    c = a*pow(c/a,1.5) + cen;
    a = z[0]
    point(z[0])
    point(z[1])
    point(z[2])
    serpent(a,b,c,cen)
    serpent(a,c,b,cen)

def point(z,col="black"):
    x = z.real
    y = z.imag 
    canv.create_oval(x-4,y-4,x+4,y+4,fill=col)
    


def serpent(S,A,B,C):
    a = A - S
    b = B - S
    c = C - S
    W = [ S, b-0.5*(a+c) , 0.75*a+1.25*b , 0.5*(c-b) , -0.25*a-0.75*b ]
    W = [ S, -c , 0.75*a +1.25*b , -a + 1.5*(b+c) , -.25*a -.75*b ,
          -0.5*c + 0.5*a - b ]
    W = [ S, -0.5*(b+c) , 0.75*a +1.25*b , -a + 2.5*b + 0.5*c , -.25*a -.75*b ,
          0.5*a - 1.5*b ]
    W = [ S, -0.5*(a+c) , 0.75*a +1.25*b , 1.5*b + 0.5*c , -.25*a -.75*b ,
          -b ]
    for n in range(101):
        t = 0.02*(n-50)
        w = W[0] + W[1]*t + W[2]*t**2 + W[3]*t**3 + W[4]*t**4 + W[5]*t**5
        if n > 0:
            canv.create_line(wo.real,wo.imag,w.real,w.imag)
        wo = w

def moved(event):
    w = event.x + 1j*event.y
    ds = 0
    for p in range(3):
        ds = cabs(w-z[p])
        if p==0 or ds<dsmin:
            dsmin = ds
            q = p
    z[q] = w
    draw()


canv = Canvas(root, width=300, height=300)
canv.bind("<B1-Motion>", moved)
canv.pack()
draw()
root.mainloop()

