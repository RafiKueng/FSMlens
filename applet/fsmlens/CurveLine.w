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
	private Complex[] inPoints = new Complex[3];
	private Vector<Complex> bezirLines0=new Vector<Complex>();
	private Vector<Complex> bezirLines1=new Vector<Complex>();
	private Vector<Complex> bezirLines2=new Vector<Complex>();
	private Vector<Complex> bezirLines3=new Vector<Complex>();

	// private Vector<Complex> bezirLines0=new Vector<Complex>();
	// private Vector<Complex> bezirLines1=new Vector<Complex>();
	// private Vector<Complex> bezirLines2=new Vector<Complex>();
	// private Vector<Complex> bezirLines3=new Vector<Complex>();
	//none default Constructor 
	CurveLine(Complex i0, Complex i1, Complex i2) {
		inPoints[0] = i0;
		inPoints[1] = i1;
		inPoints[2] = i2;
	}
	//Default constructor
	/*CurveLine() {
		index[0] = 0;
		index[1] = 1;
		index[2] = 2;
	}*/
	
//TODO: This function should calculate the nodes of the bezier lines around the three points which this instance holds so that they can after be used to
// 		draw the lines.
	
	private void calcNodes() {
		
		/*
		inPoints[0].printNumber();
		inPoints[1].printNumber();
		inPoints[2].printNumber();
		System.out.print("\n");
        */

		Complex temp1 = new Complex();
		Complex temp2 = new Complex();

		Complex A = inPoints[0];
		Complex B = inPoints[1].subtract(A);
		Complex C = inPoints[2].subtract(A);

		double B2 = B.modSQR();
		double C2 = C.modSQR();

		double D = 2.0 * (B.real() * C.imaginary() - B.imaginary() * C.real());

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

		// /*#create three "ovals" in the initially given place z
		// self.pnt[0]=self.point(z[0])
		// self.pnt[1]=self.point(z[1])
		// self.pnt[2]=self.point(z[2])*/

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
		//drawLine(bezirLines0);
		this.bezirLines1 = this.bezier(a, inPoints[1].subtract(dzb), b
				.subtract(db), b);
		//drawLine(bezirLines1);
		this.bezirLines2 = this.bezier(a, inPoints[2].add(dzc), c.add(dc),
				c);
		//drawLine(bezirLines2);
		this.bezirLines3 = this.bezier(a, inPoints[2].subtract(dzc), c
				.subtract(dc), c);
		//drawLine(bezirLines3);

		// draw Point the three points inPoints 0-2
		/*
        if (activeStat)
			g.setColor(Color.red);
		else
			g.setColor(Color.blue);
		//point(inPoints[0]);
		//point(inPoints[1]);
		//point(inPoints[2]);
        */
	}
	
	private Vector<Complex> bezier(Complex p1, Complex p2, Complex p3, Complex p4)
	{
		Complex wNext;
		//Complex wLast;
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
	public void printCurves()
	{
		System.out.println("this curveLine hos the following points: ");
		for(int i=0;i<3;i++)
		{
			inPoints[i].printNumber();
		}
		System.out.println();
	}

}
