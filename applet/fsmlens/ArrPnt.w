@* CuveLines.

@(CuveLines.java@>=
  package fsmlens;
  import qgd.util.*;
  import java.awt.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.awt.image.*;
  import java.awt.Graphics.*;
  import java.lang.Object.*;
  import java.util.*;

public class LinkPoint extends LinkCuve{
	
	private Complex[] point=new Complex()[3];//potential mistake

	public LinkPoint(Comoplex[] point) {
		this.point = point;
	}
	public LinkPoint(Complex p1, Complex p2, Complex p3) {
		Complex[] temp={p1,p2,p3};
		this.point=temp; 
	}
	public complex[] getPoint()
	{
		return point;
	}

	@Override
	public void update(Complex [] pnt) {
		// TODO Auto-generated method stub
		point=pnt;
		
	}
	@Override
	public void print() {
		// TODO Auto-generated method stub
		for(int i=0; i<3; i++)
		{
			System.out.print(" point "+i+": ");
			System.out.print(point[i].real() +" "+point[i].imaginary());
			System.out.println();
		}
		
		
	}
	
}
