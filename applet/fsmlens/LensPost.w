@* LensPost.

@(LensPost.java@>=
  package fsmlens;
  import java.text.*;
  public abstract class LensPost extends LensData
    { @<Postprocessing the mean model@>
      @<Some statistics on the current model@>
    }


@ @<Postprocessing the mean model@>=
  double f(double x, double y)
    { int i,j,n;
      double sum=0;
      for (i=-L; i<=L; i++)
        for (j=-L; j<=L; j++)
          if ((n=pmap[L+i][L+j]) != 0)
            sum -= sol[n]*Poten.poten(x-i*a,y-j*a,a);
      for (n=npix+1; n<=npix+nex; n++)
        sum -= sol[n]*shear.poten(n-npix,x,y);
      return sum;
    }

@ @<Postprocessing the mean model@>=
  double g(double x, double y)
    { double sum=0;
      for (int n=npix+1; n<=npix+nex; n++)
        sum -= sol[n]*shear.poten(n-npix,x,y);
      return sum;
    }


@ @<Postprocessing the mean model@>=
  double[] spos(int s)
    { double[] xy = new double[3];
      int offs=npix+nex+2*s;
      xy[1] = sol[offs+1] - sourceShiftConstant;
      xy[2] = sol[offs+2] - sourceShiftConstant;
      return xy;
    }

@ @<Postprocessing the mean model@>=
  void update_mass()
    { for (int ii=-ZB; ii<=ZB; ii++)
        for (int jj=-ZB; jj<=ZB; jj++)
          { double xn,yn;  int i,j,n;
            xn = ii*1./S; yn = jj*1./S;
            if (xn >= 0) i = (int) (xn+0.5);
            else i = -(int) (-xn+0.5);
            if (yn >= 0) j = (int) (yn+0.5);
            else j = -(int) (-yn+0.5);
            n = pmap[L+i][L+j];
            if (n != 0) mass_grid[ZB+ii][ZB+jj] = sol[n];
            else mass_grid[ZB+ii][ZB+jj] = 0;
          }
    }



@ @<Postprocessing the mean model@>=
  void update_poten()
    { for (int ii=-ZB; ii<=ZB; ii++)
      for (int jj=-ZB; jj<=ZB; jj++)
        { double x,y,sum;  int n;
          x = ii*a/S; y = jj*a/S;
          sum = 0;
          for (int i=-L; i<=L; i++)
            for (int j=-L; j<=L; j++)
              if ((n=pmap[L+i][L+j]) != 0)
                { int qi,qj; double dx,dy;
                  qi = 2*ii-2*i*S-S;  qj = 2*jj-2*j*S-S;
                  dx = qi*a/(2*S);  dy = qj*a/(2*S);
                  qi = (Q+qi)/2; qj = (Q+qj)/2;
                  sum -= sol[n] * (lnr[qi][qj]+lnr[qi+S][qj+S]
                                  -lnr[qi+S][qj]-lnr[qi][qj+S]);
                }
          for (n=npix+1; n<=npix+nex; n++)
            sum -= sol[n]*shear.poten(n-npix,x,y);
          poten_grid[ZB+ii][ZB+jj] = sum;
        }
    }




@ @<Some statistics on the current model@>=
  double[][] imdels(double[] sol)
    { double[][] taus = new double[imsys.size()][];
      for (int s=0; s<imsys.size(); s++)
        { double[][] data = (double[][]) imsys.elementAt(s);
          taus[s] = new double[data.length];
          double zcap = data[0][0];
          @<Set |sx,sy| to source position@>
          for (int im=0; im<data.length; im++)
            { int i,j,n; double x,y;  @/
              x = data[im][1]; y = data[im][2];  @/
              taus[s][im] = (x*x+y*y)/2 - x*sx - y*sy;
              taus[s][im] *= zcap;
              @<Add pixel contribution to |taus|@>
              @<Add shear contribution to |taus|@>
              taus[s][im] /= sol[nunk];
            }
        }
      return taus;
    }  

@ Note: this is not equivalent to |spos(s)|!
@<Set |sx,sy| to source position@>=
  double sx,sy;  @/
  int offs=npix+nex+2*s;
  sx = sol[offs+1] - sourceShiftConstant;
  sy = sol[offs+2] - sourceShiftConstant;


@ @<Add pixel contribution to |taus|@>=
  for (i=-L; i<=L; i++)
    for (j=-L; j<=L; j++)
      if ((n=pmap[L+i][L+j]) != 0)
        { x = data[im][1] - i*a;  y = data[im][2] - j*a;
          taus[s][im] -= sol[n]*Poten.poten(x,y,a);
        }


@ @<Add shear contribution to |taus|@>=
  for (n=npix+1; n<=npix+nex; n++)
    { x = data[im][1]; y = data[im][2];
      taus[s][im] -= sol[n]*shear.poten(n-npix,x,y);
    }


@ @<Some statistics on the current model@>=
  double[][][] maginv(double[] sol)
    { double[][][] imag = new double[imsys.size()][][];
      for (int s=0; s<imsys.size(); s++)
        { double[][] data = (double[][]) imsys.elementAt(s);
          double zcap = data[0][0];
          imag[s] = new double[data.length][3];
          for (int im=0; im<data.length; im++)
            { int n; double x,y,theta,xx,yy,xy;
              x = data[im][1]; y = data[im][2];
              theta = 180/Math.PI*Math.atan2(y,x);
              xx = zcap; yy = zcap; xy = 0;
              for (int i=-L; i<=L; i++)
                for (int j=-L; j<=L; j++)
                  if ((n=pmap[L+i][L+j]) != 0)
                    { double[] mag = Poten.maginv(x-i*a,y-j*a,theta,a);
                      xx -= sol[n]*mag[1];
                      yy -= sol[n]*mag[2];
                      xy -= sol[n]*mag[0];
                    }
              for (n=npix+1; n<=npix+nex; n++)
                { double[] mag = shear.maginv(n-npix,x,y,theta);
                  xx -= sol[n]*mag[1];
                  yy -= sol[n]*mag[2];
                  xy -= sol[n]*mag[0];
                }
              // Nothing done for point masses
              imag[s][im][0] = xy/zcap;
              imag[s][im][1] = xx/zcap;
              imag[s][im][2] = yy/zcap;
            }
        }
      return imag;
    }


@ @<Some statistics on the current model@>=
  double maginv(double x, double y, double zcap)
    { int n; double xx,yy,xy;
      xx = zcap; yy = zcap; xy = 0;
      for (int i=-L; i<=L; i++)
        for (int j=-L; j<=L; j++)
          if ((n=pmap[L+i][L+j]) != 0)
            { double[] mag = Poten.maginv(x-i*a,y-j*a,0,a);
              xx -= sol[n]*mag[1];
              yy -= sol[n]*mag[2];
              xy -= sol[n]*mag[0];
            }
     for (n=npix+1; n<=npix+nex; n++)
       { double[] mag = shear.maginv(n-npix,x,y,0);
         xx -= sol[n]*mag[1];
         yy -= sol[n]*mag[2];
         xy -= sol[n]*mag[0];
       }
     // Nothing done for point masses
      xx /= zcap; yy /= zcap; xy /= zcap;
      return xx*yy-xy*xy;
    }



