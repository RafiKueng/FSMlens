@* CurveBin.

@(CurveBin.java@>=
package fsmlens;

import qgd.util.*;
import java.util.ListIterator;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.awt.image.*;
import java.awt.Graphics.*;
import java.lang.Object.*;
import java.util.*;
import java.util.Iterator;
import java.util.Vector;


public class CurveBin {

	private Vector<Complex> points = new Vector<Complex>();
	Vector<Complex> zps = new Vector<Complex>();

	Vector<CurveLine> dataBase = new Vector<CurveLine>();
	private Graphics g;


	// Default constructor
	public CurveBin(Graphics g) {
		this.g = g;
		Complex temp1 = new Complex(182, 72);
		Complex temp2 = new Complex(100, 162);
		Complex temp3 = new Complex(200, 183);
		points.add(temp1);
		points.add(temp2);
		points.add(temp3);
		addCurve(temp1, temp2, temp3);
                this.draw();


	}
	public CurveBin(Complex event, Graphics g) 
	{
		this.g = g;
		this.points.add(event);
		this.expandCurve(event);

	}
        

        @<Methods in |CurveBin|@>
        @<Further methods in |CurveBin|@>
}


@ Add a Curve consisting of a saddle point and two max/min or a max
and a min to the data base with all the curves.

@<Methods in |CurveBin|@>=
	private void addCurve(Complex i0, Complex i1, Complex i2) {
		CurveLine newTemp = new CurveLine(i0, i1, i2);
                for (int k=1; k<newTemp.curvW; k++)
                  zps.add(newTemp.zp[k]);
		dataBase.add(newTemp);

	}

	
@ Takes a complex number and returns the index of the point in the
vector points which is closest to the given number.

@<Methods in |CurveBin|@>=
	private int findeClosest(Complex event) {
		double ds = 0;
		double dsmin = (event.subtract(points.get(0))).modSQR();
		int q = 0;
		for (int p = 0; p < points.size(); p++) {
			ds = (event.subtract(points.get(p))).modSQR();
			if (p == 0 || ds < dsmin) {
				dsmin = ds;
				q = p;
			}
		}
		return q;
	}

@ TODO: missing still a function that draws the point using the
coordinates of a given complex number

@<TODO Methods in |CurveBin|@>=
  public void redrawPoint(int index) { Complex temp=points.get(index); int
	x=(int)(temp.real()); int y=(int)(temp.imag());
	g.fillOval(x-5,y-5,10,10); }






@ @<Methods in |CurveBin|@>=

	
	// adding a new point to the vector externally
	private void addPoint(Complex pnt) {
		points.add(pnt);
	}

	public Complex getPoint(int index) {
		return points.get(index);
	}

        public Vector<Complex> getPoints(){
          return points;
        }

        public Vector<CurveLine> getData(){
          return dataBase;
        }



@ @<Methods in |CurveBin|@>=
	public CurveLine getCurve(int index) {
		return dataBase.get(index);
	}


@ This function uses a given mouse event and expands the closest
maxima/minima in to a saddle point and to maximas/minias param event a
complex number holding the x and y position where the mous was clicked

		// expand the point in the vector
		// 1)find the number which corresponds to event
		// 2a)update the flag of the found number
		// 2b)expand the number event into an array of 3 numbers where the first
		// one is a saddle point
		// 3)add the new numbers to the vector
		// the flag should now hold the number which indicates the spot in the
		// vector where the new complex is
		// perhaps use iterator

Perhaps these have to be adjusted; they are just a lucky guess of two
points near the first one.

The fist point is given and the second and third are the ones we just
added at the end of the vector


@<Methods in |CurveBin|@>=
	public void expandCurve(Complex event) {
		int q = this.findeClosest(event);
		addPoint(event.add(new Complex(15, 15)));
		addPoint(event.add(new Complex(-15, -15)));
		int size = points.size();
		addCurve(points.get(q), points.get(size - 1), points.get(size - 2)); 
		this.draw();
	}

        public void reset(){
          points.clear();
          dataBase.clear();        
        }



@ @<Further methods in |CurveBin|@>=
  public void updatePoint(Complex event, Graphics g)
    { this.g = g;
      int q=0,qz=0; double ds=0,dsmin=0,dsminz=0;
      for (int p = 0; p < points.size(); p++)
        { ds = (event.subtract(points.get(p))).modSQR();
          if (p == 0 || ds < dsmin)
            { dsmin = ds; q = p;
            }
        }
      for (int p = 0; p < zps.size(); p++)
        { ds = (event.subtract(zps.get(p))).modSQR();
          if (p == 0 || ds < dsminz)
            { dsminz = ds; qz = p;
            }
        }
      if (dsmin < dsminz)
        { points.get(q).set(event);
          for (int s=0; s<dataBase.size(); s++)
            dataBase.get(s).zp_recalc();
        }
      else
        { zps.get(qz).set(event);
          for (int s=0; s<dataBase.size(); s++)
            dataBase.get(s).rp_recalc();
        }
      draw();
    }


@ @<Further methods in |CurveBin|@>=
	public void draw() {
//		this.drawCurve();
		Iterator<CurveLine> iter = dataBase.iterator();
		while (iter.hasNext()) iter.next().updateExtrema();
		this.drawPoints();
                System.out.println("sizes "+points.size()+" "+zps.size());
	}


@ @<Further methods in |CurveBin|@>=
	private void drawCurve() {
		Iterator<CurveLine> iter = dataBase.iterator();
		while (iter.hasNext()) {
			Vector<Complex> vec = iter.next().curve();
			int x1, x2, y1, y2;
			for (int i = 0; i < vec.size() - 1; i++) {
				x1 = (int) vec.get(i).real();
				y1 = (int) vec.get(i).imag();
				x2 = (int) vec.get(i + 1).real();

				y2 = (int) vec.get(i + 1).imag();
                                if ((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) < 100)
  				  g.drawLine(x1, y1, x2, y2);

			}
		}
	}



@ @<Further methods in |CurveBin|@>=
	private void drawPoints() {
		for (int i = 0; i < points.size(); i++) {
			Complex temp = points.get(i);
			int x = (int) (temp.real());
			int y = (int) (temp.imag());
                        g.setColor(Color.green);
			g.fillOval(x - 5, y - 5, 10, 10);
		}
                @<Draw the extra points@>

	}


@ @<Draw the extra points@>=
  for (int i=0; i<dataBase.size(); i++)
    { CurveLine sad = dataBase.get(i);
      @<Draw newfangled curves@>
      for (int k=1; k<sad.curvW; k++)
        { int x = (int)(sad.zp[k].real()+0.5);
          int y = (int)(sad.zp[k].imag()+0.5);
          g.fillOval(x-2,y-2,4,4);
        }
    }

@ @<Draw newfangled curves@>=
  int H = sad.curvH;
  int W = 2*H-1;
  Complex[] z = sad.zp;
  curv(z,0,1,W-1,2);
  curv(z,1,2,0,3);
  for (int k=2; k<H-2; k++)
    curv(z,k,k+1,k-1,k+2);
  curv(z,H-2,H-1,H-3,0);
  curv(z,H-1,0,H-2,H);
  curv(z,0,H,H-1,H+1);
  curv(z,H,H+1,0,H+2);
  for (int k=H+1; k<2*H-3; k++)
    curv(z,k,k+1,k-1,k+2);
  curv(z,W-2,W-1,W-3,0);
  curv(z,W-1,0,W-2,1);



@ @<Further methods in |CurveBin|@>=
  void curv(Complex[] z, int i, int j, int k, int l)
    { int xo=0,yo=0,x,y;
      Complex a,b,am,bp,w;
      a = z[i]; b = z[j];
      am = b.subtract(z[k]).times(0.2).add(a);
      bp = a.subtract(z[l]).times(0.2).add(b);
      for (int n=0; n<11; n++)
        { double t,omt;
          t = 0.1*n; omt = 1 - t;
	  w = a.times(omt*omt*omt);
          w.set(w.add(am.times(3*t*omt*omt)));
          w.set(w.add(bp.times(3*t*t*omt)));
          w.set(w.add(b.times(t*t*t)));
          x = (int) (w.real()+0.5);
          y = (int) (w.imag()+0.5);
	  if (n > 0)
            g.drawLine(xo,yo,x,y);
          xo = x; yo = y;
        }
    }



