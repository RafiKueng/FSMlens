@* ComplexExtend.

@(ComplexExtend.java@>=
package fsmlens;

public class ComplexExtend {
	private Complex pnt;
	private String extrema;
	
	public ComplexExtend(Complex pnt, String ext){
		this.pnt = pnt;
		this.extrema = ext;//
	}	
	
	public ComplexExtend(Complex pnt){
		this.pnt = pnt;
		this.extrema = null;//
	}

	public ComplexExtend()
	{
		this.pnt=null;
		this.extrema=null;
	}
	
	public void setExtrema(String ext)
	{
		ext=ext.toUpperCase();
		if(ext=="L"||ext=="H"||ext=="S")
		{
			this.extrema=ext;
		}
		else
		{
			System.out.print("String has to be L for minima; M for maxima; S for saddle point");
		}
	}
	
	public Complex  getPnt()
	{
		return pnt;
	}
	
	public String getExtrema()
	{
		return this.extrema;
	}
       
        public void setExt(Complex pnt)
        {
                this.pnt.set(pnt);
        }
}
