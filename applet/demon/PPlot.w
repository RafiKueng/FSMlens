@* PPlot. This is an extension of |Plot|.

@(PPlot.java@>=
  package demon;
  import qgd.util.*;
  import java.util.*;
  import java.text.*;
  public class PPlot extends Figure
    { @<Constructor for PPlot@>
      @<Plotting methods@>
    }

@ @<Constructor for PPlot@>=
  public PPlot(int ht, int wd)
    { super(ht,wd);  reset();
    }


@ @<Plotting methods@>=
  Vector<double[]> lis;
  public void reset()
    { super.reset();  @/
      lmar = rmar = 30;
      lis = new Vector<double[]>();
      xmin = ymin = 0; @/
    }

@ @<Plotting methods@>=
  DecimalFormat fmtx;
  void setDecim(int ndec)
    { fmtx = new DecimalFormat();  @/
      fmtx.setMinimumFractionDigits(ndec);
      fmtx.setMaximumFractionDigits(ndec);
    }

@ @<Plotting methods@>=
  void lineseg(double xi, double yi, double xf, double yf)
    { double[] v = new double[4];
      v[0] = xi; v[1] = yi; v[2] = xf; v[3] = yf;  @/
      lis.add(v);  @/
      text.append(fmtx.format(xi)+" ");
      text.append(fmtx.format(yi)+"  ");
      text.append(fmtx.format(xf)+" ");
      text.append(fmtx.format(yf)+"\n");
    }

@ @<Plotting methods@>=
  void plot()
   { @<Find |xmax,ymax| in |PPlot|@>
     int[] fl = new int[2];  @/
     fl[0] = 1; fl[1] = 1; xaxis(fl,tick(xmax));  @/
     fl[0] = 2; fl[1] = 1; yaxis(fl,tick(ymax));
     for (int i=0; i<lis.size(); i++)
      { double v[] = lis.get(i);
        drawLine(v[0],v[1],v[2],v[3]);
      }
   }

@ @<Find |xmax,ymax| in |PPlot|@>=
  xmax = ymax = 0;
  for (int i=0; i<lis.size(); i++)
    { double v[] = lis.get(i);
      if (xmax < v[0]) xmax = v[0];
      if (xmax < v[2]) xmax = v[2];
      if (ymax < v[1]) ymax = v[1];
      if (ymax < v[3]) ymax = v[3];
    }
  if (xmax == 0) xmax = 1;
  if (ymax == 0) ymax = 1;

