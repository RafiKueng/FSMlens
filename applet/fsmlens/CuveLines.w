@* CuveLines.

@(CuveLines.java@>=
  package fsmlens;

/**
 * 
 */
import java.util.Vector;
/**
 * @author marion
 *
 */
public class CuveLines{// extends Figure{
	private Complex[] inPoints={new Complex(154,69),new Complex(72,99),new Complex(115/*original 215*/,77)};
	private Vector<Complex> bezirLines0=new Vector<Complex>();
	private Vector<Complex> bezirLines1=new Vector<Complex>();
	private Vector<Complex> bezirLines2=new Vector<Complex>();
	private Vector<Complex> bezirLines3=new Vector<Complex>();
	
	
	CuveLines(Complex[] pnt)
	{
		this.inPoints=pnt;
	}
	CuveLines()
	{
		
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
	

	public void draw()
	{
		System.out.println("will use points:");
		inPoints[0].printNumber();
		System.out.print(" ");
		inPoints[1].printNumber();
		System.out.print(" ");
		inPoints[2].printNumber();
		System.out.println();
		
		Complex temp1=new Complex();
		Complex temp2=new Complex();
				
		Complex A=inPoints[0];
		Complex B=inPoints[1].subtract(A);
		Complex C=inPoints[2].subtract(A);
		
		double B2 = B.modSQR();
	    double C2 = C.modSQR();
	    
	    double D = 2*(B.real()*C.imaginary()-B.imaginary()*C.real());
	    
	    //The following part calculates
	    //cen = 1j*(B*C2-C*B2)/D + A 
	    //in a complicated way
	    temp1=B.times(C2);
	    temp2=C.times(B2);
	    temp1=temp1.subtract(temp2);
	    temp1=temp1.div(D).times(Complex.I);
	    temp1=temp1.add(A);
	    Complex cen=temp1;
	    
	    Complex a = inPoints[0].subtract(cen);
	    Complex b = inPoints[1].subtract(cen);//first other point minima (H) or minima (L)
	    Complex c = inPoints[2].subtract(cen);//seccond other point minima (H) or minima (L)
	    
	    
	    b = a.times(b.div(a).pow(1.5)).add(cen);
	    c = a.times(c.div(a).pow(1.5)).add(cen);
	    a = inPoints[0];
	        
	        /*#create three "ovals" in the initially given place z
	        self.pnt[0]=self.point(z[0])
	        self.pnt[1]=self.point(z[1])
	        self.pnt[2]=self.point(z[2])*/
	    
	    //draw Point the three points inPoints 0-2
	    
	    double r = (a.subtract(cen)).mod(); //some sort of radius??
	    double bl = (a.subtract(b)).mod(); //an other radius??
	    Complex db = (b.subtract(cen)).times(0.25*bl).div(r);
	    Complex dzb = (inPoints[1].subtract(cen)).times(0.5*bl).div(r);
	        
	    double cl = c.subtract(a).mod();
	    Complex dc = (c.subtract(cen)).times(0.25*cl).div(r);
	    Complex dzc = (inPoints[2].subtract(cen)).times(0.5*cl).div(r);
	        
	    this.bezirLines0=CuveLines.bezier(a,inPoints[1].add(dzb),b.add(db),b); //draw Bezir curves
	    this.bezirLines1=CuveLines.bezier(a,inPoints[1].subtract(dzb),b.subtract(db),b);
	    this.bezirLines2=CuveLines.bezier(a,inPoints[1].add(dzc),c.add(dc),c);
	    this.bezirLines3=CuveLines.bezier(a,inPoints[1].subtract(dzc),c.subtract(dc),c);
	}
	
	public static Vector<Complex> bezier(Complex p1, Complex p2, Complex p3, Complex p4)
	{
		Complex wNext;
		Complex temp1;
		
		//Complex wLast;
		Vector<Complex> Lines = new Vector<Complex>();
		double t;
		double scale=0.01;
		for(int n=0; n<101;n++)
		{
			 t = scale*n;
			 //w = pow(1-t,3)*p1 + 3*pow(1-t,2)*t*p2 + 3*(1-t)*pow(t,2)*p3
	         //   w += pow(t,3)*p4;
	         wNext = p1.times(Math.pow(1-t,3));
	         temp1=p2.times(3*Math.pow(1-t,2)*t);
	         wNext=wNext.add(temp1);
	         temp1=p3.times(3*Math.pow(t,2)*(1-t));
	         wNext=wNext.add(temp1);
	         temp1 = p4.times(Math.pow(t,3));
	         wNext=wNext.add(temp1);
	         //System.out.print(" "+n+" ");
	         //wNext.printNumber();
	         
	         Lines.add(wNext);
		}
		//System.out.println();
		return Lines;
	}
	
	public void update(Complex event)
	{
		
		double ds=0;
		double dsmin=0;
		int q=0;
		for(int p=0;p<3;p++)
		{
			ds=event.subtract(inPoints[p]).modSQR();
			System.out.print(" ");
			inPoints[p].printNumber();
			System.out.print(" ");
			
			
			if(p==0 || ds<dsmin)
			{
				dsmin=ds;
				q=p;
			}
		inPoints[q]=event;
		this.draw();
				
		}
		
	}
	
}
