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

import java.util.Vector;

public class CuveLines{
	public static int COUNT=0;
	//private Complex[] inPoints={new Complex(154,69),new Complex(72,99),new Complex(215,77)};##
        private Complex[] inPoints={new Complex(182,72),new Complex(100,162),new Complex(200,183)};
	private Vector<Complex> cuvePoints=new Vector();//=new Vector<Complex>(inPoints); How to initialize the vector with the points of an rray

	private Vector<Complex> bezirLines0=new Vector<Complex>();
	private Vector<Complex> bezirLines1=new Vector<Complex>();
	private Vector<Complex> bezirLines2=new Vector<Complex>();
	private Vector<Complex> bezirLines3=new Vector<Complex>();
	Graphics g;	

	CuveLines(Complex[] pnt)
	{
		CuveLines.COUNT+=1;
		System.out.println(CuveLines.COUNT);
		this.inPoints=pnt;
		for(int i=0;i<3;i++)
		{
			cuvePoints.add(pnt[i]);//add the initial point to the vector to the vector to initialze the vector
		}
	}
	CuveLines()
	{
		CuveLines.COUNT+=1;
		System.out.println(CuveLines.COUNT);
		Complex temp;
		for(int i=0;i<3;i++)
		{
			temp=inPoints[i];
			cuvePoints.add(temp);//add the point given as defaiult to the vector to initialze the vector
		}
	}

	
	public Vector<Complex> getbezier0()
	{
		assert(!bezirLines0.isEmpty());
		return bezirLines0;
	}
	public Vector<Complex> getbezier1()
	{
		assert(!bezirLines1.isEmpty());
		return bezirLines1;
	}
	public Vector<Complex> getbezier2()
	{
		assert(!bezirLines2.isEmpty());
		return bezirLines2;
	}
	public Vector<Complex> getbezier3()
	{
		assert(!bezirLines3.isEmpty());
		return bezirLines3;
	}
	

	private void draw(Complex [] inPoints)
	{            
            inPoints[0].printNumber();
            inPoints[1].printNumber();
	    inPoints[2].printNumber();
	    System.out.print("\n");
		
	    Complex temp1=new Complex();
            Complex temp2=new Complex();
				
	    Complex A=inPoints[0];
            Complex B=inPoints[1].subtract(A);
	    Complex C=inPoints[2].subtract(A);
             
	    double B2 = B.modSQR();
	    double C2 = C.modSQR();
	    
	    double D = 2.0*(B.real()*C.imaginary()-B.imaginary()*C.real());
	    
	    //The following part calculates
	    //cen = 1j*(B*C2-C*B2)/D + A 
	    //in a complicated way
	    temp1=B.times(C2);
	    temp2=C.times(B2);
	    temp1=temp1.subtract(temp2);

	    temp1=temp1.div(D).times(Complex.I);
	    Complex cen=temp1.add(A);

	    
	    Complex a = inPoints[0].subtract(cen);
	    Complex b = inPoints[1].subtract(cen);//first other point minima (H) or minima (L)
	    Complex c = inPoints[2].subtract(cen);//seccond other point minima (H) or minima (L)
	    
	    

	    temp1=b.div(a);
	    temp1=temp1.pow(1.5);
	    temp1=a.times(temp1);
	    b = temp1.add(cen);

    	    temp1=c.div(a);
	    temp1=temp1.pow(1.5);
	    temp1=a.times(temp1);
	    c = temp1.add(cen);
	    a = inPoints[0];
	        
	        ///*#create three "ovals" in the initially given place z
	        //self.pnt[0]=self.point(z[0])
	        //self.pnt[1]=self.point(z[1])
	        //self.pnt[2]=self.point(z[2])*/

         
	    temp1=a.subtract(cen);
	    double r = temp1.mod(); //some sort of radius??
	    temp2=b.subtract(a);
	    double bl = temp2.mod(); //an other radius??

	    Complex db = (b.subtract(cen)).times(0.25*bl).div(r);
	    Complex dzb = ((inPoints[1].subtract(cen)).times(0.5*bl)).div(r);
	    
	    temp1=c.subtract(a);
	    double cl = temp1.mod();

	    Complex dc = (c.subtract(cen)).times(0.25*cl).div(r);
	    Complex dzc = ((inPoints[2].subtract(cen)).times(cl).times(0.5)).div(r);
   
	    this.bezirLines0=CuveLines.bezier(a,inPoints[1].add(dzb),b.add(db),b); //draw Bezir curves
            drawLine(bezirLines0);
	    this.bezirLines1=CuveLines.bezier(a,inPoints[1].subtract(dzb),b.subtract(db),b);
            drawLine(bezirLines1);
	    this.bezirLines2=CuveLines.bezier(a,inPoints[2].add(dzc),c.add(dc),c);
            drawLine(bezirLines2);
	    this.bezirLines3=CuveLines.bezier(a,inPoints[2].subtract(dzc),c.subtract(dc),c);
            drawLine(bezirLines3);

            //draw Point the three points inPoints 0-2
            if(activeStat) g.setColor(Color.red);
            else g.setColor(Color.blue);
            point(inPoints[0]);	    
            point(inPoints[1]);
            point(inPoints[2]);
	}
	
	public static Vector<Complex> bezier(Complex p1, Complex p2, Complex p3, Complex p4)
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
	
	public void update(Complex event, Graphics g)
	{
		/*this.g = g;
		double ds=0;
		double dsmin=(event.subtract(inPoints[0])).modSQR();
		int q=0;
		for(int p=0;p<3;p++)
		{
			ds=(event.subtract(inPoints[p])).modSQR();
			if(p==0 || ds<dsmin)
			{
				dsmin=ds;
				q=p;
			}
		}*/
                this.g = g;
		double ds=0;
		double dsmin=(event.subtract(cuvePoints.get(0))).modSQR();
		int q=0;
		for(int p=0;p<cuvePoints.size();p++)
		{
			ds=(event.subtract(cuvePoints.get(p))).modSQR();
			if(p==0 || ds<dsmin)
			{
				dsmin=ds;
				q=p;
			}
		//inPoints[q]=event;
		//this.draw();
		}
		Complex temp=cuvePoints.get(q);
		temp.update(event);
		cuvePoints.set(q,temp);
		//Iterator itr = cuvePoints.iterator();
		/*if(q%3==0)
		{
			setPoints(q,q+3,temp);
			
		}
		else if(q%3==1)
		{
			setPoints(q-1,q+2,temp);
		}
		else if(q%3==2)
		{
			setPoints(q-2,q+1,temp)
		}*/

		int begin=q-q%3;
		int end =q+(3-q%3);
		int j=0;
		
		for(int i=begin;i<end;i++)
		{
			if(!(temp.checkFlag()))
			{
				inPoints[j]=cuvePoints.get(temp.getFlag());
			}
			else
			{	inPoints[j]=cuvePoints.get(i);}
			++j;
		}
		
		inPoints[q]=event;//there is a better way to do this look up overrite --> is set or something 
		//create an array with the points
		this.draw(inPoints);
		
	}
       
        public void update()
	{
		Complex[] inPointsT=new Complex[3];
		int numb=cuvePoints.size()/3;
		int i=0;
		while(i<cuvePoints.size())
		{
			inPointsT[i%3]=cuvePoints.get(i);
			if(i>0 && i%3==2)
			{
				this.draw(inPointsT);
			}
			i++;
		}		
		//extract the first tree points from the vector cuvePoints in to an array		
				
	}

	public void expandCuve(Complex exp)
	{		
		//expand the point in the vector
		//1)find the number which corresponds to exp
		//2a)update the flag of the found number
		//2b)expand the number exp into an array of 3 numbers where the first one is a saddel point
		//3)add the new numbers to the vector
		//  the flag should now hold the nuber which indicates the spot in the vector where the new complex is 
		//perhaps use iterator
		
		//Iterator iter=cuvePoints.iterator();
		Complex temp2=new Complex();
		//=cuvePoints.lastIndexOf(exp);
		
		for(ListIterator<Complex> iter=cuvePoints.listIterator(); iter.hasNext();)
		{
			temp2=iter.next();
			temp2=temp2.subtract(exp);
			int index=iter.nextIndex();
			if(Math.abs(temp2.real())<10 && Math.abs(temp2.imaginary())<10)
			{		
				Complex temp;				
				temp=cuvePoints.get(index);
				temp.updateFlag(cuvePoints.size());
				cuvePoints.set(index,temp);
		
				//expansion
				cuvePoints.add(exp);
				temp=exp.add(new Complex(10,10));
				cuvePoints.add(temp);
				temp=exp.add(new Complex(-10, -10));
				cuvePoints.add(temp);
				break;
				
			}

		}


		
	}

        public void point(Complex z)
        {
        //g.setColor(Color.red);
        int x = (int)(z.real());
        int y = (int)(z.imaginary());
        g.fillOval(x-5,y-5,10,10);
        }

        public void drawLine(Vector<Complex> vector)
        {
        g.setColor(Color.white);
        Complex pnt1,pnt2;
        for(int i=0; i<(vector.size()-1); i++)
          {
          pnt1 = vector.get(i);
          pnt2 = vector.get(i+1);
          g.drawLine((int)(pnt1.real()),(int)(pnt1.imaginary()),(int)(pnt2.real()),(int)(pnt2.imaginary()));
          }
        }
        
        boolean activeStat = true;
        public void setActive()
        {
        activeStat = true;
        }
    
        public void setInactive()
        {
        activeStat = false;
        }
	
}
