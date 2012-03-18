@* Plotting surface density.

@(PlotMass.java@>=
  package fsmlens;
  @<Imports for |PlotMass|@>
  public class PlotMass extends Figure implements ActionListener
    { @<Generic stuff in |PlotMass|@>
      @<Event handler in |PlotMass|@>
      @<Plotting code in |PlotMass|@>
    }

@ @<Imports for |PlotMass|@>=
  import qgd.util.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.util.*;
  import java.text.*;
  import java.io.*;
  import java.awt.Color;

@ @<Generic stuff in |PlotMass|@>=
  LensBase lens;  @/
  double zm,cstep;  @/
  InputField zm_txt,cstep_txt;  @/
  double[][] grid;  @/


@ @<Generic stuff in |PlotMass|@>=
  public PlotMass()
    { super(320,320);
      @<Set up input fields in |PlotMass|@>
      @<Initialize fields in |PlotMass|@>
    }


@ @<Generic stuff in |PlotMass|@>=
  public void reset()
    { super.reset();
      @<Initialize fields in |PlotMass|@>
    }

@ @<Set up input fields in |PlotMass|@>=
  if (Dual.mode() != 0)
    { cstep_txt = new InputField("step",5," ",hook);
      cstep_txt.addActionListener(this);  @/
      zm_txt = new InputField("zm",3," ",hook);
      zm_txt.addActionListener(this);  @/
    }

@ @<Initialize fields in |PlotMass|@>=
  lens = null; grid = null;
  if (Dual.mode() != 0)
    { cstep_txt.set(-2.512);  zm_txt.set(1);
    }
  cstep = -2.512; zm = 1;

@ @<Generic stuff in |PlotMass|@>=
  public void update(LensBase lens)
    { this.lens = lens; plot();
    }


@ @<Event handler in |PlotMass|@>=
  public void actionPerformed(ActionEvent event)
    { Object src = event.getSource();
      if (lens!=null)
        if (src instanceof InputField)
          { @<Read the |InputField|s in |PlotMass|@>
            plot();
          }
    }

@ @<Read the |InputField|s in |PlotMass|@>=
  cstep = cstep_txt.readDouble(-10,10);
  if (cstep < 0 && cstep > -1) cstep_txt.set(--cstep);
  zm = zm_txt.readDouble(0.01,5);

@ @<Plotting code in |PlotMass|@>=
  private void plot()
    { int L = lens.L; double a = lens.a;
      int Z = lens.Z; int ZB = lens.ZB; int S=lens.S;  @/
      erase(); drawAxes(zm*(L+1)*a);
      double[] lim = new double[4];  @/
      lim[0] = -ZB*a/S; lim[1] = -ZB*a/S;
      lim[2] =  ZB*a/S; lim[3] =  ZB*a/S;  @/
      @<Set |grid[][]| to the specified mass map@>
      @<Set |lev[]| to mass contour levels@>
      Vector cl = Mesh.contour(grid,lim,lev);
      setColor(Color.green.getRGB());
      for (int i=1; i<cl.size(); i++)
        { double[] seg = (double[]) cl.elementAt(i);
          drawLine(seg[0],seg[1],seg[2],seg[3]);
        }
      double[] sol = lens.sol; int p = lens.npix+lens.nex;
      for (int s=0; s<lens.imsys.size(); s++)
        { setColor(Color.red.getRGB()); dotsize = 6;
          double[][] data = lens.imsys.get(s).data;
          for (int i=0; i<data.length; i++)
            drawPoint(data[i][1],data[i][2]);
          setColor(Color.cyan.getRGB()); dotsize = 4;
          double[] xy = lens.spos(s);  drawPoint(xy[1],xy[2]);
        }
      repaint();
    }

@ @<Set |grid[][]| to the specified mass map@>=
  grid = new double[Z][Z];
  for (int i=-ZB; i<=ZB; i++)
    for (int j=0; j<=ZB; j++)
      { double m1,m2;  @/
        m1 = lens.mass_grid[ZB+i][ZB+j]; m2 = lens.mass_grid[ZB-i][ZB-j];
        grid[ZB+i][ZB+j] = m1; grid[ZB-i][ZB-j] = m2;
      }


@ @<Set |lev[]| to mass contour levels@>=
  double[] lev;
  if (cstep > 0)
    { lev = new double[1+(int)(lens.sol[1]/cstep)];
      for (int l=0; l<lev.length; l++) lev[l] = l*cstep;
    }
  else
    { double v; int l;  @/
      for (v=1, l=0;;)
        { l++; v *= -cstep;
          if (v > lens.sol[1]) break;
        }
      for (v=1;;)
        { v /= -cstep;
          if (v < 0.1) break;
          l++;
        }
      lev = new double[l];
      for (v=1, l=0;;)
        { lev[l++] = v;  @/
          v *= -cstep;
          if (v > lens.sol[1]) break;
        }
      for (v=1;;)
        { v /= -cstep;
          if (v < 0.1) break;
          lev[l++] = v;
        }
    }

