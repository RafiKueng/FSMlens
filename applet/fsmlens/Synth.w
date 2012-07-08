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
        double[] masscent = new double[2];
        String choose;
        int surSize = 3;
    }

@ @<Code to generate synth pic@>=
JButton copyButton;
JButton resetButton;
JButton reconstButton;
JButton synthButton;
TextField sourcesize;
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
//	  hook.add(copyButton);
          reconstButton = new JButton("Source");
          reconstButton.addActionListener(this);
//          hook.add(reconstButton);
          resetButton = new JButton("Reset");
          resetButton.addActionListener(this);
          hook.add(resetButton);
          synthButton = new JButton("Synth");
          synthButton.addActionListener(this);
          hook.add(synthButton);
          sourcesize = new TextField("3",3);
          sourcesize.addActionListener(this);
          hook.add(sourcesize);
          //hook.setBackground(Color.black);
          rgbPix = new int[picSize][picSize][1];
          image = new BufferedImage(wd,ht,1);
          g = image.getGraphics();
	  drawAxes(1);
          String quadrLine2 = unicorn.quadrLine;
        }


@ @<Managing the button in |Synth|@>=
  public void actionPerformed(ActionEvent event)
    { 
      String str = event.getActionCommand();
      Object obj = event.getSource();
      if (str.equals("Copy")) setPic();
      if (str.equals("Reset")) reset();
      if (str.equals("Source")) getSource();
      if (str.equals("Synth")) getPixPic();
      if (obj instanceof TextField) {
        try{
          surSize = Integer.parseInt(str);
          synthimg.setsurSize(Integer.parseInt(str));
          }
        catch(Exception e) {
          surSize = 3;
          synthimg.setsurSize(3);
          }
        
        }
    }

@ @<set somer picture@>=
  public void setPic()
    {
        g.clearRect(0,0,picSize,picSize);
        choose = unicorn.quadrLine;
	rgbPix = unicorn.getrgbMatrix();
        drawPic();
        if(choose.equals("Rectangle")) unicorn.setPoints();
        repaint();
    }

@ @<reconstruct the image plane@>=
  public void getPixPic()
    {    
        choose = unicorn.quadrLine;
        setPic();
        pixCount = new int[picSize][picSize][2];
        int xNew=0,yNew=0;
        double[] sourcCoo = new double[3];     
        masscent = unicorn.masscenter;
        for(int j=0; j<picSize;j++)
 	  {
	  for(int k=0; k<picSize;k++)
	    {
              if(rgbPix[j][k][0] != 0){           
                sourcCoo[1] = x(j)-masscent[0];
	        sourcCoo[2] = y(k)-masscent[1];
                if(choose.equals("Rectangle")){
                  sourcCoo[1] = x(j);
	          sourcCoo[2] = y(k);
                  }
		try{
 	          sourcCoo = home.sourCoord(sourcCoo);                  
                  xNew = xpix(sourcCoo[1]+masscent[0]);
	          yNew = ypix(sourcCoo[2]+masscent[1]);
                  if(choose.equals("Rectangle")){
                    xNew = xpix(sourcCoo[1]);
	            yNew = ypix(sourcCoo[2]);
                    }
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
                    for(int m=0;m<surSize;m++)
                      for(int n=0;n<surSize;n++)
                        {
                        pixCount[xNew-m/2+m][yNew-n/2+n][0] = pixCount[xNew][yNew][0];
                        } 
		  }                
               } 
   	    }
	  }

        unicorn.drawSource(xNew,yNew);
        makeAverage(); 
        createMaxMin();
        for(int j=xMin; j<=xMax;j++)
 	  {
          for(int k=yMin; k<yMax;k++)
	    {
                sourcCoo[1] = x(j)-masscent[0]; 
	        sourcCoo[2] = y(k)-masscent[1]; 
                if(choose.equals("Rectangle")){
                  sourcCoo[1] = x(j);
	          sourcCoo[2] = y(k);
                  }
		try{
                  double[] sourcCooNew = new double[3]; 
 	          sourcCoo = home.sourCoord(sourcCoo);
                  xNew = xpix(sourcCoo[1]+masscent[0]); 
	          yNew = ypix(sourcCoo[2]+masscent[1]);   
                   if(choose.equals("Rectangle")){
                    xNew = xpix(sourcCoo[1]);
	            yNew = ypix(sourcCoo[2]);
                    }                
		}
		catch(Exception e) {
		  xNew = j;
	 	  yNew = k;
                  System.out.println("Exception, no coord transformation");
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
    }


@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,picSize,picSize);
    unicorn.reset();
    synthimg.reset();
    unicorn.resetCurv();
    repaint();
    }
