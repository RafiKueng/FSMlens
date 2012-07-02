from Tkinter import *
 
root = Tk()

z = [10+10j, 50+250j, 200+150j, 290+290j]
z = [154+69j, 72+99j, 215+77j]


def cabs(w):
    return w.real*w.real + w.imag*w.imag

def cross(a,b):
    return  a.real*b.imag - a.imag*b.real

def point(z,col="black"):
    x = z.real
    y = z.imag 
    canv.create_oval(x-4,y-4,x+4,y+4,fill=col)


def draw():
    print z[0],z[1],z[2]
    canv.delete(ALL)
    S,a,b = z[0],z[1],z[2]
    point(S)
    point(a)
    point(b)
    loop(S,a-S,b-S,100+0j)
    loop(S,b-S,a-S,-50+0j)

def loop(S,a,b,q):
    point(S+q,col='red')
    for n in range(101):
        t = 0.02*(n-50)
        w = S + (1-t*t) * ( a*(t+1) + b*(t-1) + (q-a+b)*(1-t**4) )
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

