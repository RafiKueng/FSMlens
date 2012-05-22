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
	private Vector<CurveLine> dataBase = new Vector<CurveLine>();
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

	}
	public CurveBin(Complex event, Graphics g) 
	{
		this.g = g;
		this.points.add(event);
		this.expandCurve(event);
        this.drawPoints();
        this.drawCurve();

	}

	

	/*
	 * add a Curve consisting of a saddle point and two max/min or a max and a
	 * min to the data base with all the curves
	 */
	private void addCurve(Complex i0, Complex i1, Complex i2) {
		CurveLine newTemp = new CurveLine(i0, i1, i2);
		dataBase.add(newTemp);

	}

	

	/*
	 * takes a complex number and returns the index of the point in the vector
	 * points which is closest to the given number
	 */
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

	// TODO: missing still a function that draws the point using the coordinates
	// of a given complex number
	/*
	 * public void redrawPoint(int index) { Complex temp=points.get(index); int
	 * x=(int)(temp.real()); int y=(int)(temp.imaginary());
	 * g.fillOval(x-5,y-5,10,10); }
	 */
	private void drawPoints() {
		for (int i = 0; i < points.size(); i++) {
			Complex temp = points.get(i);
			int x = (int) (temp.real());
			int y = (int) (temp.imaginary());
			g.fillOval(x - 5, y - 5, 10, 10);
		}

	}

	// TODO: create a function which draws the bezier lines; perhaps also
	// calculates them according to given nodes
	private void drawCurve() {
		Iterator<CurveLine> iter = dataBase.iterator();
		while (iter.hasNext()) {
			Vector<Complex> vec = iter.next().curve();
			int x1, x2, y1, y2;
			for (int i = 0; i < vec.size() - 1; i++) {
				x1 = (int) vec.get(i).real();
				y1 = (int) vec.get(i).imaginary();
				x2 = (int) vec.get(i + 1).real();
				y2 = (int) vec.get(i + 1).imaginary();

				g.drawLine(x1, y1, x2, y2);
			}
		}
	}

	private void draw() {
		this.drawCurve();
		this.drawPoints();
	}
	
	// adding a new point to the vector externally
	private void addPoint(Complex pnt) {
		points.add(pnt);
	}

	public Complex getPoint(int index) {
		return points.get(index);
	}

	// updating the point closest to a given event with the coordinates of the
	// given event
	public void updatePoint(Complex event, Graphics g) {
		this.g = g;
		int q = this.findeClosest(event);
		points.set(q, event);
	}

	public void updatePoint(Complex event) {
		int q = this.findeClosest(event);
		points.set(q, event);

		this.draw();
	}
	public CurveLine getCurve(int index) {
		return dataBase.get(index);
	}

	public void printPoints() {
		System.out.println("the points used at the moment are ");
		for (int i = 0; i < points.size(); i++) {
			points.get(i).printNumber();
		}
		System.out.println();
	}
	/*
	 * this function uses a given mouse event and expands the closest
	 * maxima/minima in to a saddle point and to maximas/minias
	 * 
	 * @param event a complex number holding the x and y position where the mous
	 * was clicked
	 */
	public void expandCurve(Complex event) {
		// expand the point in the vector
		// 1)find the number which corresponds to event
		// 2a)update the flag of the found number
		// 2b)expand the number event into an array of 3 numbers where the first
		// one is a saddle point
		// 3)add the new numbers to the vector
		// the flag should now hold the number which indicates the spot in the
		// vector where the new complex is
		// perhaps use iterator
		int q = this.findeClosest(event);
		addPoint(event.add(new Complex(10, 10)));
		addPoint(event.add(new Complex(-10, -10)));// perhaps these have to be
													// adjusted; they are just a
													// lucky guess of two points
													// near the first one
		int size = points.size();// find the current size of the vector
		addCurve(points.get(q), points.get(size - 1), points.get(size - 2)); // the
																				// fist
																				// point
																				// is
																				// given
																				// and
																				// the
																				// second
																				// and
																				// third
																				// are
																				// the
																				// ones
																				// we
																				// just
																				// added
																				// at
																				// the
																				// end
																				// of
																				// the
																				// vector
		this.draw();
	}

}

