@* CurveLine.

@(CurveLine.java@>=
package fsmlens;

import qgd.util.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.awt.image.*;
import java.awt.Graphics.*;
import java.lang.Object.*;
import java.util.*;
import java.util.Vector;



public class CurveLine {

        ComplexExtend[] points = new ComplexExtend[3];

        int curvH = 5; int curvW = 2*curvH-1;

        Complex[] rp,zp;

	CurveLine(Complex i0, Complex i1, Complex i2) {
	   this.points[0]=new ComplexExtend(i0,"S");
	   this.points[1]=new ComplexExtend(i1);
	   this.points[2]=new ComplexExtend(i2);
           rp = new Complex[curvW];
           zp = new Complex[curvW];
           for (int k=0; k<curvW; k++)
             { zp[k] = new Complex(0,0);
               rp[k] = new Complex(0,0);
             }
           for (int k=1; k<curvH; k++)
             { double arg = 2*Math.PI*k/curvH;
               rp[k].set(new Complex(1-Math.cos(arg),-Math.sin(arg)));
               rp[k+curvW/2].set(new Complex(1-Math.cos(arg),-Math.sin(arg)));
             }
           zp_recalc();
	}

        @<Methods in |CurveLine|@>
  
}

@ @<Methods in |CurveLine|@>=

        Complex[] getPoints()
          { Complex[] p = new Complex[3];
            for (int k=0; k<3; k++)  p[k] = points[k].getPnt();
            return p;
          }
	
@ @<Methods in |CurveLine|@>=
	public void updateExtrema()
	{
		double angle;
		Complex ext1=vec(points[0].getPnt(),points[1].getPnt());
		Complex ext2=vec(points[0].getPnt(),points[2].getPnt());
		angle=angle(ext1,ext2);
		//if(angle>=Math.PI/4.0 && angle<=3.0*Math.PI/4.0)
                if(Math.abs(angle)>=Math.PI/8.0)
		{
			//there are two minimas
			points[1].setExtrema("L");
			points[2].setExtrema("L");
		
		}else
		{
			//there is a maximum and a minimuma ->the point that is closer to the saddle point is a maximum
			double dis1=ext1.mod();
			double dis2=ext2.mod();
			if(dis1<dis2)
			{
				//the point 1 is a maximum --> perhaps move to the end
				points[1].setExtrema("H");//maximum
				points[2].setExtrema("L");//minimum
			}
			else
			{
				points[1].setExtrema("L");//minimum
				points[2].setExtrema("H");//maximum
			}
			
		}
	}

@ @<Methods in |CurveLine|@>=
	public double crossP(Complex x, Complex y)
	{
		return (x.real()*y.imag()-x.imag()*y.real());
	}
	public double angle(Complex x, Complex y)
	{
		double sp=x.real()*y.real()+x.imag()*y.imag();
                return Math.acos(sp/(x.mod()*y.mod()));
	}
	public Complex vec(Complex x, Complex y)
	{
		//return x.subtract(y);
                return y.subtract(x);
	}

	

@ @<Methods in |CurveLine|@>=
	public void printCurves()
	{
		System.out.println("this curveLine hos the following points: ");
		for(int i=0;i<3;i++)
		{
			points[i].getPnt().printNumber();
			System.out.println("the index of this pint is "+points[i].getExtrema());
		}
		System.out.println();
	}


@ @<Methods in |CurveLine|@>=
  void zp_recalc()
    { Complex dz1,dz2;
      dz1 = points[1].getPnt().subtract(points[0].getPnt());
      dz2 = points[2].getPnt().subtract(points[0].getPnt());
      double fl = dz2.div(dz1).real();
      for (int k=0; k<curvW; k++)
        { zp[k].set(points[0].getPnt());
          if (k > 0)
            { if (k < curvH)
                zp[k].set(zp[k].add(dz1.times(rp[k])));
              else
                if (fl > 0)
                  zp[k].set(zp[k].add(dz2.times(rp[k])));
                else
                  zp[k].set(zp[k].add(dz2.times(rp[k].conj())));
            }
        }
    }


@ @<Methods in |CurveLine|@>=
  void rp_recalc()
    { Complex dz1 = points[1].getPnt().subtract(points[0].getPnt());
      Complex dz2 = points[2].getPnt().subtract(points[0].getPnt());
      double fl = dz2.div(dz1).real();
      for (int k=0; k<curvW; k++)
        { Complex dz = zp[k].subtract(points[0].getPnt());
          if (k < curvH)
            rp[k].set(dz.div(dz1));
          else
            { rp[k].set(dz.div(dz2));
              if (fl < 0)
                rp[k].set(rp[k].conj());
            }
        }
    }

