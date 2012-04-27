@* LinkCuve.

@(LinkCuve.java@>=
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

public class Point extends LinkCuve{
	
	private Complex pnt;

	Point(Complex pnt)
	{
		this.pnt=pnt;
	}
	public Complex getPnt()
	{
		return this.pnt;
	}
	
	public void Print()
	{
		System.out.println("point is "+ pnt);
	}
	
	public void update(Complex udp)
	{
		this.pnt=udp;
	}

	
}
