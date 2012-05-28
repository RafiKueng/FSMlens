@* Interactive lens applet.  This is a program to illustrate image
formation interactively in a simple model of a galaxy lensing a
quasar.  It is written using Java 1.1 and should run on all the
currently common browsers, as well as stand-alone.  The following
assumes familiarity with the Java AWT (Abstract Windowing Toolkit) and
with basic gravitational lensing theory.

@(Daemon.java@>=
  package demon;
  import qgd.util.*;
  @<Imported classes for |Daemon|@>
  public class Daemon extends Dual
    { @<GUI for lens plots@>
      @<Lens equations@>
    }

@ @<Imported classes for |Daemon|@>=
  import java.util.Vector;
  import java.awt.event.*;
  import javax.swing.*;
  import java.awt.BorderLayout;
  import java.awt.Color;


@ @<GUI for lens plots@>=
  public static void main(String[] args)
    { Daemon wyn = new Daemon();
      if (args.length==1) wyn.parse_flag(args[0]);
      wyn.main();
    }

@ @<GUI for lens plots@>=
  int flag=0;  @/
  LensModel lens;  // Has its own GUI.
  MPlot caus;  Figure crit,arriv;
  Figure ex;
  Console text;
  PPlot dels;
  public void main()
    { if (Dual.mode()==2) parse_flag(getParameter("basemodel"));
      int siz = 300;
      caus = new MPlot(this,siz,siz);
      caus.setBackground(Color.black);
      caus.setTitle("mass");  @/
      crit = new Figure(siz,siz);
      crit.setBackground(Color.black);
      crit.setTitle("potential"); @/
      arriv = new Figure(siz,siz);
      arriv.setBackground(Color.black);
      arriv.setTitle("arrival time"); @/
      dels = new PPlot(siz,siz);  @/

        ex = new Figure(siz,siz);
      	ex.setBackground(Color.black);
      	ex.setTitle("example pic"); @/
 
	text = new Console(4,80);
	text.setBackground(Color.white);
	text.append("Explanatory text here");


      mainPane.add("West",caus.getPanel());
	mainPane.add("East",ex.getPanel());
	mainPane.add("South",text.getPanel());
	
//      mainPane.add("East",crit.getPanel());
      if (flag==1)
        { mainPane.add("Center",dels.getPanel());  dels.setDecim(6);
        }
      else mainPane.add("Center",arriv.getPanel());
      lens = new LensModel(this);
      mainPane.add("North",lens);  @/
      lens.model_vanilla();
      show("Daemon version 0.1","Show Daemon window");
    }


@ @<GUI for lens plots@>=
  private void parse_flag(String str)
    { if (str!=null)
        if (str.compareTo("fudge")==0) flag = 1;
    }

@ Here field size (radius really).  The first plot is more convenient
if zoomed.
@<GUI for lens plots@>=
  double fs=2;
  void curves()
    { caus.erase(); crit.erase(); arriv.erase(); ex.erase();  @/
      caus.setColor(Color.white.getRGB());
ex.setColor(Color.white.getRGB());
      crit.setColor(Color.white.getRGB());
      arriv.setColor(Color.white.getRGB());  @/
      caus.drawAxes(fs/2); crit.drawAxes(fs); arriv.drawAxes(fs); ex.drawAxes(fs/2);  @/
      dels.reset();  @/
      find_curves();  @/
      caus.repaint(); crit.repaint(); arriv.repaint(); dels.repaint(); ex.repaint();
    }

@ Now we move on the the messy numerical stuff.

@ @<Lens equations@>=
  void find_curves()
    { @<Variables in |find_curves|@>
      if (flag!=-1)
        { @<Plot mass contours@>
          @<Plot potential contours@>
        }
      @<Plot critical curves and caustics@>
    }

@ @<Variables in |find_curves|@>=
  final int L=25;
  double[][] grid = new double[2*L+1][2*L+1];
  Vector<double[]> cl; int nc; double vlo,vhi;
  double[] lim,lev;  @/
  lim = new double[4];  @/
  lim[0] = -fs; lim[1] = -fs; lim[2] = fs; lim[3] = fs;  @/


@ @<Plot mass contours@>=
  for (int i=-L; i<=L; i++)
    for (int j=-L; j<=L; j++)
      { double x,y; x = (i*fs)/L; y = (j*fs)/L;
        grid[L+i][L+j] = lens.kappa(x,y);
      }
  nc = (int)(2*lens.kappa(0,0));
  lev = new double[nc];
  for (int l=0; l<nc; l++) lev[l] = (l+1)/2.;
  cl = Mesh.contour(grid,lim,lev);  @/
  caus.setColor(Color.green.getRGB());
  for (int i=0; i<cl.size(); i++)
    { double[] pi,pf,seg;  @/
      seg = cl.get(i);
      if (seg[0] > -fs/2 && seg[0] < fs/2 && seg[1] > -fs/2 && seg[1] < fs/2)
        caus.drawLine(seg[0],seg[1],seg[2],seg[3]);
    }

@ @<Plot potential contours@>=
  nc = 10; vlo = lens.poten(fs,fs); vhi = lens.poten(0,0);
  for (int i=-L; i<=L; i++)
    for (int j=-L; j<=L; j++)
      { double x,y; x = (i*fs)/L; y = (j*fs)/L;
        grid[L+i][L+j] = lens.poten(x,y);
      }
  lev = new double[nc];
  for (int l=0; l<nc; l++) lev[l] = vlo + l*(vhi-vlo)/(nc-1);
  cl = Mesh.contour(grid,lim,lev);  @/
  crit.setColor(Color.green.getRGB());
  for (int i=0; i<cl.size(); i++)
    { double[] pi,pf,seg;  @/
      seg = cl.get(i);
      crit.drawLine(seg[0],seg[1],seg[2],seg[3]);
    }

@ @<Plot critical curves and caustics@>=
  for (int i=-L; i<=L; i++)
    for (int j=-L; j<=L; j++)
      { double x,y; x = (i*fs)/L; y = (j*fs)/L;
        grid[L+i][L+j] = lens.maginv(x,y);
      }
  lev = new double[1]; lev[0] = 0;  @/
  cl = Mesh.contour(grid,lim,lev);  @/
  caus.setColor(Color.yellow.getRGB());
  crit.setColor(Color.yellow.getRGB());
  for (int i=0; i<cl.size(); i++)
    { double[] pi,pf,seg;  @/
      seg = cl.get(i);
      crit.drawLine(seg[0],seg[1],seg[2],seg[3]);
      pi = lens.sour(seg[0],seg[1]); pf = lens.sour(seg[2],seg[3]);
      caus.drawLine(pi[0],pi[1],pf[0],pf[1]);
      if (flag==1) trace_caus(pi[0],pi[1],pf[0],pf[1]);
    }
  if (flag==1) dels.plot();

@ @<Lens equations@>=
  double sx=0,sy=0;
  void source(double sx, double sy)
    { this.sx = sx; this.sy = sy; source();
    }
  void source()
    { curves();
      if (flag!=1)
        { @<Set |lis| to image positions@>
          @<Plot saddle point contours@>
          @<Plot images@>
        }
    }


@ @<Set |lis| to image positions@>=
  final int L=25;
  double[][] dx,dy; double w;
  dx = new double[2*L+1][2*L+1];  dy = new double[2*L+1][2*L+1];
  w = fs/L;
  for (int i=-L; i<=L; i++)
    for (int j=-L; j<=L; j++)
      { double x,y; x = i*w; y = j*w;
        double[] sxy = lens.sour(x,y);  @/
        dx[L+i][L+j] = sxy[0] - sx;  dy[L+i][L+j] = sxy[1] - sy;
      }
  Vector<double[]> lis = new Vector<double[]>();
  for (int i=-L; i<L; i++)
    for (int j=-L; j<L; j++)
      zoom(lis,i*w,j*w,(i+1)*w,(j+1)*w,
           dx[L+i][L+j],dx[L+i][L+j+1],dx[L+i+1][L+j],dx[L+i+1][L+j+1],
           dy[L+i][L+j],dy[L+i][L+j+1],dy[L+i+1][L+j],dy[L+i+1][L+j+1]);


@ @<Plot saddle point contours@>=
  Vector<double[]> cl;
  double[][] grid = new double[2*L+1][2*L+1];  @/
  double[] lim,lev,llev;  lim = new double[4];
  lev = new double[1];  llev = new double[20];  @/
  lim[0] = -fs; lim[1] = -fs; lim[2] = fs; lim[3] = fs;  @/
  for (int i=-L; i<=L; i++)
    for (int j=-L; j<=L; j++)
      { double x,y; x = (i*fs)/L; y = (j*fs)/L;
        grid[L+i][L+j] = (x*x+y*y)/2 - lens.poten(x,y) - (sx*x+sy*y);
      }
  arriv.setColor(Color.magenta.getRGB());
  double tmin=1e20,tmax=-1e20;
  for (int m=0; m<lis.size(); m++)
    { double[] p = lis.get(m);
      double x,y,t; x = p[0]; y = p[1];
      t = (x*x+y*y)/2 - lens.poten(x,y) - (sx*x+sy*y);
      if (t < tmin) tmin = t;
      if (t > tmax) tmax = t;
      if (lens.maginv(x,y) < 0)
        { lev[0] = t;
          cl = Mesh.contour(grid,lim,lev);  @/
          for (int l=0; l<cl.size(); l++)
            { double[] seg = cl.get(l);
              arriv.drawLine(seg[0],seg[1],seg[2],seg[3]);
            }
        }
    }
  for (int l=0; l<llev.length; l++)
    llev[l] = tmin + (l+1)*(tmax-tmin)/(lev.length+1);
  cl = Mesh.contour(grid,lim,llev);
  for (int l=0; l<cl.size(); l++)
    { double[] seg = cl.get(l);
      arriv.drawLine(seg[0],seg[1],seg[2],seg[3]);
    }



@ @<Plot images@>=
  crit.setColor(Color.red.getRGB());
  arriv.setColor(Color.red.getRGB());
  for (int i=0; i<lis.size(); i++)
    { double[] p = lis.get(i);
      crit.drawPoint(p[0],p[1]);
      double mag = lens.maginv(p[0],p[1]);  mag = 1/Math.sqrt(Math.abs(mag));
      int ds = 2*(int)(mag+1);
      arriv.setDotsize(ds); arriv.drawPoint(p[0],p[1]); arriv.setDotsize(4);
    }
  caus.setColor(Color.cyan.getRGB()); caus.drawPoint(sx,sy); caus.repaint();



@ This is ugly, but for a multi-root search in two dimensions, what do
you expect?
@<Lens equations@>=
  void zoom(Vector<double[]> lis,
            double xm, double ym, double xp, double yp, @|
            double mmx, double mpx, double pmx, double ppx, @|
            double mmy, double mpy, double pmy, double ppy)
    { if ((mmx*ppx <= 0 || mpx*pmx <= 0) && (mmy*ppy <= 0 || mpy*pmy <= 0))
        if (xp-xm < 1e-3 && yp-ym < 1e-3)
          { double[] im = new double[2];
            im[0] = (xm+xp)/2; im[1] = (ym+yp)/2;
            lis.add(im);
          }
        else
          { @<Zoom in@>
          }
    }

@ @<Zoom in@>=
  double xz,yz,mzx,mzy,zmx,zmy,zzx,zzy,zpx,zpy,pzx,pzy;
  double[] alf = new double[2];
  xz = (xm+xp)/2; yz = (ym+yp)/2;  @/
  alf = lens.sour(xm,yz);  mzx = alf[0]-sx; mzy = alf[1]-sy;  @/
  alf = lens.sour(xz,ym);  zmx = alf[0]-sx; zmy = alf[1]-sy;  @/
  alf = lens.sour(xz,yz);  zzx = alf[0]-sx; zzy = alf[1]-sy;  @/
  alf = lens.sour(xz,yp);  zpx = alf[0]-sx; zpy = alf[1]-sy;  @/
  alf = lens.sour(xp,yz);  pzx = alf[0]-sx; pzy = alf[1]-sy;  @/
  zoom(lis,xm,ym,xz,yz,mmx,mzx,zmx,zzx,mmy,mzy,zmy,zzy);
  zoom(lis,xm,yz,xz,yp,mzx,mpx,zzx,zpx,mzy,mpy,zzy,zpy);
  zoom(lis,xz,ym,xp,yz,zmx,zzx,pmx,pzx,zmy,zzy,pmy,pzy);
  zoom(lis,xz,yz,xp,yp,zzx,zpx,pzx,ppx,zzy,zpy,pzy,ppy);


@ @<Lens equations@>=
  void trace_caus(double x1, double y1, double x2, double y2)
    { double shr=0.99;
      for (int n=1; n<=2; n++)
        { if (n==1)
            { sx = shr*x1; sy = shr*y1;
            }
          else
            { sx = shr*x2; sy = shr*y2;
            }
          @<Set |lis| to image positions@>
          @<Evaluate longest time delay@>
          if (n==1)
            { x1 = ar; y1 = ra;
            }
          else
            { x2 = ar; y2 = ra;
            }
        }
      dels.lineseg(x1,y1,x2,y2);
    }

@ @<Evaluate longest time delay@>=
  double[] first = new double[3];
  double[] last = new double[3];
  first[0] = 1e10; last[0] = -1e10;
  for (int m=0; m<lis.size(); m++)
    { double[] p = (double[]) lis.get(m);
      double x,y; x = p[0]; y = p[1];
      double t = (x*x+y*y)/2 - lens.poten(x,y) - (sx*x+sy*y);
      if (t<first[0])
        { first[0] = t; first[1] = x; first[2] = y;
        }
      if (t>last[0] && lens.maginv(x,y)<0)
        { last[0] = t; last[1] = x; last[2] = y;
        }
    }
  double ar,ra;
  ar = Math.sqrt(first[1]*first[1]+first[2]*first[2]) + 
       Math.sqrt(last[1]*last[1]+last[2]*last[2]);
  ar = ar*ar/16;  @/
  double r1,r2;
  r1 = Math.sqrt(first[1]*first[1]+first[2]*first[2]);
  r2 = Math.sqrt(last[1]*last[1]+last[2]*last[2]);
  ar = (r1-r2)*(r1+r2)/2;
  ra = (last[0]-first[0])/ar;


