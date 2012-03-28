@* Synthetic image.

@(Synthimg.java@>=
  package fsmlens;
  import qgd.util.*;
 import qgd.util.*;
  import java.awt.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.awt.image.*;
  import java.awt.Graphics.*;
  import java.lang.Object.*;
  import java.util.*;
  public class Synthimg extends Figure
    {
        @<Code to generate synth pic@>
        @<set somer picture@>
        @<Reset the panel@>
        @<Reset the matrix@>
        @<Draw the source plane@>
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synth synth;
        int[] RGBin;
        int[][][] pixCount = new int[300][300][2];
        int[][][] rgbPix = new int[300][300][2];
    }

@ @<Code to generate synth pic@>=
public Synthimg(Monster home, Unicorn unicorn)
        { super(300,300);
          this.home = home;
          this.unicorn = unicorn;
          image = new BufferedImage(wd,ht,1);
          g = image.getGraphics();
	  drawAxes(1);
          resetMatrix();
        }


@ @<set somer picture@>=
  void print_src(double x, double y)
    { double[] xy = new double[3];
      xy[1] = x; xy[2] = y;
      xy = home.sourCoord(xy);
      System.out.println("source position "+xy[1]+" "+xy[2]);
      System.out.println("source pixel "+xpix(xy[1])+" "+ypix(xy[2]));
    }

@ @<set somer picture@>=
  public void setPixPic()
    {    
        rgbPix = unicorn.getrgbMatrix();
        double[] sourcCoo = new double[3];      
        for(int j=0; j<300;j++)
 	  {
	  for(int k=0; k<300;k++)
	    {
              if(rgbPix[j][k][0] != 0){
                sourcCoo[1] = x(j); // 2.25*((2.0*(j)/300.0)-1.0);
	        sourcCoo[2] = y(k); // 2.25*(1.0-(2.0*(k)/300.0));
		int xNew,yNew;
		try{
 	          sourcCoo = home.sourCoord(sourcCoo);
                  xNew = xpix(sourcCoo[1]); // (int)(((1.5+sourcCoo[1])*200.0/2.0)/2.25);
	          yNew = ypix(sourcCoo[2]); // (int)(((1.5-sourcCoo[2])*200.0/2.0)/2.25);
		}
		catch(Exception e) {
		  xNew = j;
	 	  yNew = k;
		}
	        if(xNew>=0 && xNew<300 && yNew>=0 && yNew<300)
		  {
		  pixCount[xNew][yNew][0] += 1;
                  pixCount[xNew][yNew][1] += rgbPix[j][k][0];
		  }
              }
   	    }
	  }
        drawPic();
        repaint();	
    }

@ @<Draw the source plane@>=
  private void drawPic()
    {
    for(int i=0; i<300; i++)
      for(int j=0; j<300; j++)
        { 
        if(pixCount[i][j][0] != 0)
          image.setRGB(i,j,(pixCount[i][j][1])/(pixCount[i][j][0]));
        }
    }

@ @<Reset the matrix@>=
  private void resetMatrix()
    {
    for(int i=0; i<300; i++) 
      {
        for(int j=0; j<300; j++)
    	  {
          rgbPix[i][j][0] = 0;
          rgbPix[i][j][1] = 0;
	  pixCount[i][j][0] = 0;
          pixCount[i][j][1] = 0;
 	  }
      }
    }

@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,300,300);
    unicorn.reset();
    resetMatrix();
    repaint();
    }
