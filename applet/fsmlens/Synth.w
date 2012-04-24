@* Synthetic image.

This file is not doing anything.

@(Synth.java@>=
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
  public class Synth extends Figure implements ActionListener
    {
        @<Code to generate synth pic@>
        @<set somer picture@>
        @<Managing the button in |Synth|@>
        @<Reset the panel@>
        @<get RGB of the pixels@>
        @<reconstruct the image plane@>   
        @<Draw the reconstruction plane@>
        @<make a average over the pix@>
        @<Reset the matrix@>
        @<create max and min value of the coordinate@>
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synthimg synthimg;
        int[] RGBin;
        int[][][] rgbPix;
        int[][][] pixCount;
        int picSize;
    }

@ @<Code to generate synth pic@>=
JButton copyButton;
JButton resetButton;
JButton reconstButton;
JButton synthButton;
public Synth(Monster home, Unicorn unicorn, Synthimg synthimg, int picSize)
        { super(picSize,picSize);
          this.picSize = picSize;
          rgbPix = new int[picSize][picSize][2];
          //pixCount = new int[picSize][picSize][2];
          this.home = home;
          this.unicorn = unicorn;
	  this.synthimg = synthimg;
          copyButton = new JButton("Copy"); 
          copyButton.addActionListener(this);
	  hook.add(copyButton);
          reconstButton = new JButton("Source");
          reconstButton.addActionListener(this);
          hook.add(reconstButton);
          resetButton = new JButton("Reset");
          resetButton.addActionListener(this);
          hook.add(resetButton);
          synthButton = new JButton("Synth");
          synthButton.addActionListener(this);
          hook.add(synthButton);
          hook.setBackground(Color.black);
          rgbPix = new int[picSize][picSize][1];
          image = new BufferedImage(wd,ht,1);
          g = image.getGraphics();
	  drawAxes(1);
        }


@ @<Managing the button in |Synth|@>=
  public void actionPerformed(ActionEvent event)
    { 
      String str = event.getActionCommand();
      if (str.equals("Copy")) setPic();
      if (str.equals("Reset")) reset();
      if (str.equals("Source")) getSource();
      if (str.equals("Synth")) getPixPic();
 
    }

@ @<set somer picture@>=
  public void setPic()
    {
	rgbPix = unicorn.getrgbMatrix();
         for(int i=0; i<picSize; i++) 
           {
            for(int j=0; j<picSize; j++)
    	      {
              image.setRGB(i,j,rgbPix[i][j][0]); 
 	      }
           }
        unicorn.setPoints();
        repaint();
    }

@ @<reconstruct the image plane@>=
  public void getPixPic()
    {    
        createMaxMin();
        int xNew=0,yNew=0;
        pixCount = synthimg.getAveragePix();
        double[] sourcCoo = new double[3];      
        //for(int j=0; j<picSize;j++)
        for(int j=xMin; j<xMax;j++)
 	  {
	  //for(int k=0; k<picSize;k++)
          for(int k=yMin; k<yMax;k++)
	    {
                sourcCoo[1] = x(j); 
	        sourcCoo[2] = y(k); 
		try{
 	          sourcCoo = home.sourCoord(sourcCoo);
                  xNew = xpix(sourcCoo[1]); 
	          yNew = ypix(sourcCoo[2]); 
                  if(pixCount[xNew][yNew][0]!=0){
                    System.out.println(xNew + " " + sourcCoo[1] +  "      " + yNew + " " + sourcCoo[2]);
                    System.out.println(j + "  " + k); 
                    }
                    
		}
		catch(Exception e) {
		  xNew = j;
	 	  yNew = k;
		}
	        if(xNew>=0 && xNew<picSize && yNew>=0 && yNew<picSize)
		  {
                  rgbPix[j][k][0] = pixCount[xNew][yNew][0];
		  }
   	    }
	  }
        drawPic();
        repaint();	
    }


@ @<get RGB of the pixels@>=
  private void getSource()
    {
    rgbPix = synthimg.setPixPic();
    drawPic();
    repaint();
    }

@ @<make a average over the pix@>=
  private void makeAverage()
    {
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          if(rgbPix[i][j][1]>0)
            {       
            rgbPix[i][j][0] = rgbPix[i][j][0]/rgbPix[i][j][1];           
            }
 	  }
      }
    }




@ @<Draw the reconstruction plane@>=
  private void drawPic()
    {
    g.clearRect(0,0,picSize,picSize);
    for(int i=0; i<picSize; i++)
      for(int j=0; j<picSize; j++)
        { 
          image.setRGB(i,j,rgbPix[i][j][0]); 
        }
    }

@ @<Reset the matrix@>=
  public void resetMatrix()
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

@ @<create max and min value of the coordinate@>=
  int xMax=0,yMax=0,xMin=0,yMin=0;
  public void createMaxMin()
    {
    double nxmax=0,nymax=0,nxmin=0,nymin=0;
    double xmax=x(picSize),ymax=y(0),xmin=x(0),ymin=y(picSize);
    double[] koord = new double[3];
    ArrayList<double[]> maxKoord = new ArrayList<double[]>();
    maxKoord = unicorn.getPointKoord();
    for(int i=0 ; i<maxKoord.size() ; i++)
      {
      koord = maxKoord.get(i);
      nxmax = koord[0]; nxmin = koord[0]; nymax = koord[1]; nymin = koord[1];
      if(nxmax>=xmin) xmin = nxmax;
      if(nxmin<=xmax) xmax = nxmin;
      if(nymax>=ymin) ymin = nymax;
      if(nymin<=ymax) ymax = nymin;      
      }
    int outcast = 10;
    xMax = xpix(xmin)+outcast; xMin = xpix(xmax)-outcast; yMax = ypix(ymin)+outcast; yMin = ypix(ymax)-outcast;
    //System.out.println("xmax: " + xmax + "  xmin: " + xmin + "      ymax: " + ymax + "   ymin: " + ymin);
    //System.out.println("xmax: " + xMax + "  xmin: " + xMin + "      ymax: " + yMax + "   ymin: " + yMin);
    }



@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,picSize,picSize);
    //resetMatrix();
    unicorn.reset();
    synthimg.reset();
    repaint();
    }
