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
        @<find maximum in the pix@>
        @<make a average over the pix@>
        @<get the average pixel@>
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synth synth;
        int[] RGBin;
        int[][][] pixCount;
        int[][][] rgbPix;
        double[][][] rgbDouble;
        int picSize;
        int max,xMax,yMax;
    }

@ @<Code to generate synth pic@>=
public Synthimg(Monster home, Unicorn unicorn, int picSize)
        { super(picSize,picSize);
          this.picSize = picSize;
          rgbPix = new int[picSize][picSize][2];
          pixCount = new int[picSize][picSize][2];
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
  public int[][][] setPixPic()
    {    
        int xNew=0,yNew=0;
        rgbPix = unicorn.getrgbMatrix();
        double[] sourcCoo = new double[3];     
        for(int j=0; j<picSize;j++)
 	  {
	  for(int k=0; k<picSize;k++)
	    {
              if(rgbPix[j][k][0] != 0){             
                //sourcCoo[1] = x(j);
	        //sourcCoo[2] = y(k);
                sourcCoo[1] = (j-(picSize)/2.0)*2.0/((double)(picSize-20));
	        sourcCoo[2] = ((picSize)/2.0-k)*2.0/((double)(picSize-20)); 
		try{
 	          sourcCoo = home.sourCoord(sourcCoo);                  
                  //xNew = xpix(sourcCoo[1]);
	          //yNew = ypix(sourcCoo[2]);
                  xNew = (int)((picSize+(picSize-20)*sourcCoo[1])/2.0);
                  yNew = (int)((picSize-(picSize-20)*sourcCoo[2])/2.0); 
		}
		catch(Exception e) {
		  xNew = j;
	 	  yNew = k;
		}
	        if(xNew>=0 && xNew<picSize && yNew>=0 && yNew<picSize)
		  {
      		    pixCount[xNew][yNew][1] += 1;
                    System.out.println(xNew + " " + yNew + " \n");
                    pixCount[xNew][yNew][0] += rgbPix[j][k][0];
		  }                
               } 
   	    }
	  }
        for(int m=0;m<25;m++)
          for(int n=0;n<25;n++)
            {
            pixCount[xNew-1+m][yNew-1+n][0] = pixCount[xNew][yNew][0];
            }
        unicorn.drawSource(xNew,yNew);
        makeAverage();
        //drawPic();
        //repaint();
        return(pixCount);	
    }

@ @<Draw the source plane@>=
  private void drawPic()
    {
    for(int i=0; i<picSize; i++)
      for(int j=0; j<picSize; j++)
        { 
        if(pixCount[i][j][0] != 0)
          image.setRGB(i,j,pixCount[i][j][0]);  
        }
    }

@ @<Reset the matrix@>=
  private void resetMatrix()
    {
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          rgbPix[i][j][0] = 0;
          rgbPix[i][j][1] = 0;
	  pixCount[i][j][0] = 0;
          pixCount[i][j][1] = 0;
 	  }
      }
    }

@ @<find maximum in the pix@>=
  private void getMax()
    {
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          if(pixCount[i][j][1]>max)
            {
            max = pixCount[i][j][1];
            xMax = i; yMax = j;
            }
 	  }
      }
    }

@ @<make a average over the pix@>=
  private void makeAverage()
    {
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          if(pixCount[i][j][1]>0)
            {       
            pixCount[i][j][0] = pixCount[i][j][0]/pixCount[i][j][1];           
            }
 	  }
      }
    }

@ @<get the average pixel@>=
  public int[][][] getAveragePix()
    {
    return(pixCount);
    }


@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,picSize,picSize);
    unicorn.reset();
    resetMatrix();
    max = 0;
    repaint();
    }
