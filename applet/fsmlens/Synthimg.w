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
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synth synth;
        int[] RGBin;
        int[][][] pixCount = new int[300][300][1];
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
  public void setPixPic()
    {    
        rgbPix = unicorn.getrgbMatrix();
        double[] sourcCoo = new double[3];      
        for(int j=0; j<300;j++)
 	  {
	  for(int k=0; k<300;k++)
	    {
              if(rgbPix[j][k][0] != 0){
                sourcCoo[1] = (2.0*(j)/300.0)-1.0;
	        sourcCoo[2] = 1.0-(2.0*(k)/300.0);
		int xNew,yNew;
		try{
 	          sourcCoo = home.sourCoord(sourcCoo,1.0);
                  xNew = (int)((1.5+sourcCoo[1])*200.0/2.0);
	          yNew = (int)((1.5-sourcCoo[2])*200.0/2.0);
		}
		catch(Exception e) {
		  xNew = j;
	 	  yNew = k;
		}
	        if(xNew>=0 && xNew<300 && yNew>=0 && yNew<300)
		  { 
	          image.setRGB(xNew,yNew,rgbPix[j][k][0]);
		  pixCount[xNew][yNew][0] += 1;
		  }
              }
   	    }
	  }
          repaint();	
    }

@ @<Reset the matrix@>=
  private void resetMatrix()
    {
    for(int i=0; i<300; i++) 
      {
        for(int j=0; j<300; j++)
    	  {
          rgbPix[i][j][0] = 0;
	  pixCount[i][j][0] = 0;
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
