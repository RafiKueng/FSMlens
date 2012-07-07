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
	private Vector<Complex> bezirLines0=new Vector<Complex>();
	private Vector<Complex> bezirLines1=new Vector<Complex>();
	private Vector<Complex> bezirLines2=new Vector<Complex>();
	private Vector<Complex> bezirLines3=new Vector<Complex>();

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
		if(angle>=Math.PI/4.0 && angle<=3.0*Math.PI/4.0)
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
		return x.subtract(y);
	}

@ @<Methods in |CurveLine|@>=
	private void calcNodes() {
		updateExtrema();//<----------------------------------------Perhaps is better to calle this update function in some other place
		Complex inPoints[]=new Complex[3];
		for(int i=0;i<3;i++)
		{
			inPoints[i]=points[i].getPnt();
		}

		Complex temp1 = new Complex();
		Complex temp2 = new Complex();

		Complex A = inPoints[0];
		Complex B = inPoints[1].subtract(A);
		Complex C = inPoints[2].subtract(A);

		double B2 = B.modSQR();
		double C2 = C.modSQR();

		double D = 2.0 * (B.real() * C.imag() - B.imag() * C.real());

		// The following part calculates
		// cen = 1j*(B*C2-C*B2)/D + A
		// in a complicated way
		temp1 = B.times(C2);
		temp2 = C.times(B2);
		temp1 = temp1.subtract(temp2);

		temp1 = temp1.div(D).times(Complex.I);
		Complex cen = temp1.add(A);

		Complex a = inPoints[0].subtract(cen);
		Complex b = inPoints[1].subtract(cen);// first other point minima (H) or
												// minima (L)
		Complex c = inPoints[2].subtract(cen);// seccond other point minima (H)
												// or minima (L)

		temp1 = b.div(a);
		temp1 = temp1.pow(1.5);
		temp1 = a.times(temp1);
		b = temp1.add(cen);

		temp1 = c.div(a);
		temp1 = temp1.pow(1.5);
		temp1 = a.times(temp1);
		c = temp1.add(cen);
		a = inPoints[0];

		temp1 = a.subtract(cen);
		double r = temp1.mod(); // some sort of radius??
		temp2 = b.subtract(a);
		double bl = temp2.mod(); // an other radius??

		Complex db = (b.subtract(cen)).times(0.25 * bl).div(r);
		Complex dzb = ((inPoints[1].subtract(cen)).times(0.5 * bl)).div(r);

		temp1 = c.subtract(a);
		double cl = temp1.mod();

		Complex dc = (c.subtract(cen)).times(0.25 * cl).div(r);
		Complex dzc = ((inPoints[2].subtract(cen)).times(cl).times(0.5)).div(r);

		this.bezirLines0 = this.bezier(a, inPoints[1].add(dzb), b.add(db),
				b); // draw Bezir curves
		this.bezirLines1 = this.bezier(a, inPoints[1].subtract(dzb), b
				.subtract(db), b);
		this.bezirLines2 = this.bezier(a, inPoints[2].add(dzc), c.add(dc),
				c);
		this.bezirLines3 = this.bezier(a, inPoints[2].subtract(dzc), c
				.subtract(dc), c);

		// draw Point the three points inPoints 0-2
	}
	
@ @<Methods in |CurveLine|@>=
	private Vector<Complex> bezier(Complex p1, Complex p2, Complex p3, Complex p4)
	{
		Complex wNext;
		Vector<Complex> Lines = new Vector<Complex>();
		double t;
		double scale=0.01;

		for(int n=0; n<100;n++)
		{
	           t = scale*n;
	           wNext = p1.times(Math.pow(1-t,3)).add((p2.times(3*Math.pow(1-t,2)*t)).add(p3.times(3*(1-t)*Math.pow(t,2))));
	           wNext = wNext.add(p4.times(Math.pow(t,3)));

	           Lines.add(wNext);
		}
		return Lines;
	}
	
	public Vector<Complex> curve()
	{
		calcNodes();
		Vector<Complex> theCurve=new Vector<Complex>();
		theCurve.addAll(this.bezirLines0);
		theCurve.addAll(this.bezirLines1);
		theCurve.addAll(this.bezirLines2);
		theCurve.addAll(this.bezirLines3);
		return theCurve;
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

