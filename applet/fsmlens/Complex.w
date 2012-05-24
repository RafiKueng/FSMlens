@* Complex.

@(Complex.java@>=
  package fsmlens;

public class Complex implements Cloneable{
	public static Complex I =new Complex(0,1);
	public static Complex R=new Complex(1,0);
	
	
	public double re=0;
	public double im=0;
	Complex()
	{
		//Complex number has real and imag part zero!!!
	}
	
	Complex(double re, double im)
	{
		this.re=re;
		this.im=im;
	}
	Complex(double [] z)
	{
		this.re=z[0];
		this.im=z[1];
	}
	
	public double imag()
	{
		return im;
	}
	public double real()
	{
		return re;
	}
	
	public Complex add(double x)
	{
		Complex zTot=new Complex(this.re+x,this.im);
		return zTot;
	}
	
	public Complex add(Complex z)
	{
		Complex zTot=new Complex(z.real()+this.re, z.imag()+this.im);
		return zTot;
		
	}

        public Complex substact(double x)
        {
           	Complex zTot = new Complex(this.re-x,this.im);
 		return zTot;
        }
	
	public Complex subtract(Complex z)
	{

		Complex zTot=new Complex(this.re-z.real(),this.im-z.imag());

		return zTot;
	}

	void set(Complex z)
	{
                re = z.real(); im = z.imag();
	}
	
	public Complex times(Complex w) {

        return new Complex(this.re*w.real()-this.im*w.imag(),this.re*w.imag()+this.im*w.real());
    }
	public Complex times(double a)
	{
		return new Complex(this.re*a,this.im*a);
	}
	public Complex div(double a)
	{
		assert(a!=0);
		return new Complex(this.re/a,this.im/a);
	}
	
	public Complex div(Complex w) {
        
        Complex z=this.times(w.conj());
        
        return z.div(w.modSQR());
    }
	
	public Complex conj() {
        return new Complex(this.re,-this.im);
    }
	public double modSQR()
	{
		return this.re * this.re+this.im*this.im;
	}
	public double mod()//or also the radius of the complex number
	{
		return Math.sqrt(this.modSQR());
	}
	public double arg()
	{
		return Math.atan2(this.im,this.re);
	}
	
	public Complex pow(double a)
	{
		double rb=Math.pow(this.mod(), a);
                double argb = a*this.arg();
                return new Complex(rb*Math.cos(argb),rb*Math.sin(argb)) ;
	}
	public void printNumber()
	{
		System.out.print("("+this.re+","+this.im+") ");
	}
	public Complex clone()
          {
          try
            {
             return (Complex) super.clone();
            }
          catch (CloneNotSupportedException e ) {
            throw new InternalError();
            }
          }
   
    
}

