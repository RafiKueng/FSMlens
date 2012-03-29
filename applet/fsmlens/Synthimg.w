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
  public void setPixPic()
    {    
        rgbPix = unicorn.getrgbMatrix();
        double[] sourcCoo = new double[3];      
        for(int j=0; j<picSize;j++)
 	  {
	  for(int k=0; k<picSize;k++)
	    {
              if(rgbPix[j][k][0] != 0){
                sourcCoo[1] = x(j); // 2.25*((2.0*(j)/(double)(picSize))-1.0);
	        sourcCoo[2] = y(k); // 2.25*(1.0-(2.0*(k)/(double)(picSize)));
		int xNew,yNew;
		try{
 	          sourcCoo = home.sourCoord(sourcCoo);
                  xNew = xpix(sourcCoo[1]); // (int)(((1.0+sourcCoo[1])*picSize/2.0)/2.25);
	          yNew = ypix(sourcCoo[2]); // (int)(((1.0-sourcCoo[2])*picSize/2.0)/2.25);
		}
		catch(Exception e) {
		  xNew = j;
	 	  yNew = k;
		}
	        if(xNew>=0 && xNew<picSize && yNew>=0 && yNew<picSize)
		  {
		  pixCount[xNew][yNew][0] += 1;
                  pixCount[xNew][yNew][1] += rgbPix[j][k][0];
		  }
              }
   	    }
	  }
        makeAverage();
        drawPic();
        repaint();	
    }

@ @<Draw the source plane@>=
  private void drawPic()
    {
    for(int i=0; i<picSize; i++)
      for(int j=0; j<picSize; j++)
        { 
        if(pixCount[i][j][0] != 0)
          image.setRGB(i,j,pixCount[i][j][1]);   
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
          if(pixCount[i][j][0]>max)
            {
            max = pixCount[i][j][0];
            xMax = i; yMax = j;
            }
 	  }
      }
    }

@ @<make a average over the pix@>=
  private void makeAverage()
    {
    int xAver = 0, yAver = 0, totalCount = 1;
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          if(pixCount[i][j][0]>0)
            {
            xAver += i * pixCount[i][j][0];
            yAver += j * pixCount[i][j][0];
            totalCount += pixCount[i][j][0];
            pixCount[i][j][1] = pixCount[i][j][1]/pixCount[i][j][0];
            }
 	  }
      }
    xAver = xAver/totalCount;
    yAver = yAver/totalCount;
    g.fillOval(xAver,yAver,10,10);
    unicorn.drawSource(xAver,yAver);
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
