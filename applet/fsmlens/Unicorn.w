@* Unicorn.

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener, MouseListener, MouseMotionListener//, KeyListener
    { @<Code to read and show raw lenses@>
      @<Drawing curves with the mouse@>
      @<get the Picture out@>
      @<init rgb matrix@>
      @<Reset the array@>
      @<get the RGB matrix out@>
      @<Drawing the source@>
      @<check rgb@>
      @<get max Koordinate@>
      @<get choosen picture@>
      @<set points@>
      String quadrLine="Line"; 
      int x1N,y1N, picSize; 
      double x2N,y2N;
      int[][][] rgbPix;
      Complex complex;
      Complex complex1;
      Complex complex2;
      BufferedImage imgInt;
      BufferedImage imageOrg = null;
      Illus illus;
    }


@ @<Imports for |Unicorn|@>=
  import qgd.util.*;
  import java.awt.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.awt.image.*;
  import java.awt.Graphics.*;
  import java.lang.Object.*;
  import java.util.*;
  import java.io.*;
  import javax.imageio.*; 
  import javax.imageio.stream.*;
  import javax.imageio.metadata.*;




@ @<Init variables for |Unicorn|@>=
    String quadrLine="Line"; 
    int x1N,y1N, picSize; 
    double x2N,y2N;
    //double x1N,y1N;
    int[][][] rgbPix;
    Complex complex;
    Complex complex1;
    Complex complex2;

@ @<Code to read and show raw lenses@>=
  public Unicorn(Monster home, int picSize, Illus illus)
    { super(picSize,picSize);
      this.home = home;
      //this.cuveLines = cuveLines;
      this.picSize = picSize; 
      this.illus = illus;
      rgbPix = new int[picSize][picSize][2];
      choice = new JComboBox();
      rect = new JComboBox();
      choice.addActionListener(this);
      rect.addActionListener(this);
      hook.add(choice);
      hook.add(rect);
      hook.setBackground(Color.black);
      addMouseListener(this);
      addMouseMotionListener(this);
      rgbMatrix();
      @<Initialize fields in |Unicorn|@>
    }


@ @<Code to read and show raw lenses@>=
  JComboBox choice;
  JComboBox rect;
  public void actionPerformed(ActionEvent event)
    { showImage((String) choice.getSelectedItem());
      quadrLine = ((String) rect.getSelectedItem());
      repaint();
    }


@ @<Initialize fields in |Unicorn|@>=
  choice.addItem("PG1115V.gif");
  choice.addItem("Q0047V.gif");
  choice.addItem("PG1115V_gray.gif");
  choice.addItem("PG1115V_gray.jpg");
  choice.addItem("EinsteinCross.png");
  choice.addItem("pngTranspDemo.png");
  rect.addItem("Line");
  rect.addItem("Rectangle");


@ @<Code to read and show raw lenses@>=
  Monster home;
  Graphics g;
  CuveLines cuveLines; //Global cuveLine
  CuveLines cuveLines2;
  Image img;
  BufferedImage imgrect = null;
  BufferedImage intensity = null;
  
  void showImage(String str)
    { str = "images/" + str;
      JApplet app = new JApplet();
      Image img = app.getToolkit().getImage(getClass().getResource(str));
      image = toBufferedImage(img,wd,ht);
      @<check if there is alpha channel with intensity@>
      imageOrg = image;
      g = image.getGraphics();
      g.setColor(Color.blue);
      drawAxes(1);
    }

    
    
@ @<check if there is alpha channel with intensity@>=
      /* if this img has an alpha channel, extract it and save it under */
      /* author: rk */
      if (hasAlpha(img)) {
        intensity = extractAlpha(img,wd,ht);
        imgInt = toBufferedImage(intensity,picSize,picSize);
      }
      else imgInt = null;




@ @<Drawing curves with the mouse@>=
  public void mouseEntered(MouseEvent event) { }
  public void mouseExited(MouseEvent event) { }
  public void mouseReleased(MouseEvent event) { }
  public void mouseMoved(MouseEvent event) { }


@ @<Drawing curves with the mouse@>=
  public void mouseClicked(MouseEvent event)
    { System.out.println("click on "+x(event.getX())+" "+y(event.getY()));
    }


@ @<Drawing curves with the mouse@>=
  double x1,y1,x2,y2;
  boolean state=true;
  double oneortwo;
  int subimageSize;
  public void mousePressed(MouseEvent event)
    { 
      oneortwo = 1;
      subimageSize = 25;
      drawAxes(1);
      x1N = event.getX();
      y1N = event.getY();
      x1 = x(x1N);
      y1 = y(y1N);
      double[] maxVal2 = new double[2];
      if(quadrLine.equals("Rectangle")){
        if(event.getButton()==MouseEvent.BUTTON3){ g.setColor(Color.red); oneortwo=2;}
        else if(event.getButton()==MouseEvent.BUTTON2){ g.setColor(Color.green); oneortwo=3;}
        else{ g.setColor(Color.blue); oneortwo = 1;}
        g.drawRect((x1N-subimageSize/2),(y1N-subimageSize/2),subimageSize,subimageSize);
        if(imgInt != null) imgrect = imgInt.getSubimage((x1N-(subimageSize-2)/2),(y1N-(subimageSize-2)/2),subimageSize-2,subimageSize-2);
        else  imgrect = imageOrg.getSubimage((x1N-(subimageSize-2)/2),(y1N-(subimageSize-2)/2),subimageSize-2,subimageSize-2);
        BufferedImage img = toBufferedImage(imgrect,subimageSize-2,subimageSize-2);
        maxVal2 = checkRGB(img,x1N-subimageSize/2,y1N-subimageSize/2);
	for(int i=0; i<(subimageSize-2); i++)
 	  {
	    for(int j=0; j<(subimageSize-2); j++)
	      {
              //if(rgbPix[x1N+i][y1N+j][0] == 0 && (img.getRGB(i,j)>-10000000  || img.getRGB(i,j)<-12500000)) 
              //if(rgbPix[x1N+i][y1N+j][0] == 0 && (img.getRGB(i,j)>-1350000)) 
              //if(rgbPix[x1N+i][y1N+j][0] == 0)
       	        //rgbPix[x1N+i][y1N+j][0] = img.getRGB(i,j);      
                        
 	      }
 	  }
        repaint();
        }
// if mouse is clicke a new cuveLine is drawn
	if(quadrLine.equals("Line")){

		if(event.getButton()==MouseEvent.BUTTON3){
			System.out.println("in Mous Event Button 3 pressed");
			state=!state;
		}
		if(CuveLines.COUNT==0){
		complex1=new Complex(x2N,y2N);
		cuveLines=new CuveLines();  //***********************
		cuveLines.update(complex1,g);	
		}
		
		else if(CuveLines.COUNT==1 && event.getButton()==MouseEvent.BUTTON3 ){
		complex1=new Complex(x2N,y2N);
		cuveLines2=new CuveLines();  //***********************
		cuveLines2.update(complex1,g);}
                
                else if(CuveLines.COUNT==2){
                if(state) {cuveLines.setActive(); cuveLines2.setInactive();}
                else {cuveLines2.setActive(); cuveLines.setInactive();}
                cuveLines.update();	
                cuveLines2.update();
                }

      	repaint();
	}
    }

//@ @<Drawing curves with the mouse@>=
//
/*  public void keyTyped(KeyEvent e)
{
	System.out.println("in Key Event");

	if(e.getKeyChar()=='n')
	{
		System.out.println("in Key Event if");
		state=!state;	
	} 
}
  public void keyReleased(KeyEvent e)
{System.out.println("in Key Event Pressed");}
 public void keyPressed(KeyEvent e)
{System.out.println("in Key Event Pressed");}
*/

@ @<Drawing curves with the mouse@>=
  public void mouseDragged(MouseEvent event)
    { reset();
      erase();
      drawAxes(1);
      x2N = event.getX();
      y2N = event.getY();
      x2 = x(x2N);
      y2 = y(y2N);
      if(quadrLine.equals("Line"))
	if(state)
	{
        //drawLine(x1,y1,x2,y2);

		complex=new Complex(x2N,y2N);
		cuveLines.update(complex,g);
        	cuveLines2.update(complex1,g);
	}
	else
	{
		complex1=new Complex(x2N,y2N); //*******************************
		cuveLines.update(complex,g);
        	cuveLines2.update(complex1,g);

	}
      repaint();	
    }
//@ @<Creating a new instance of Cuve lines and draw new curves@>=
//  public void newDraw()
//  {
//	component.getAction
//  }

@ @<Drawing the source@>=
  public void drawSource(int xMax, int yMax)
    {
    g.setColor(Color.white);
    g.fillOval(xMax,yMax,10,10);
    repaint();
    }


@ @<Reset the array@>=
  public void reset()
    {
    showImage((String) choice.getSelectedItem());
    repaint();
    rgbMatrix();
    maxKoord.clear();
    //imageOrg = null;
    }

@ @<init rgb matrix@>=
  private void rgbMatrix()
    {
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          rgbPix[i][j][0] = 0;
 	  }
      }
    }

@ @<get the RGB matrix out@>=
  public int[][][] getrgbMatrix()
    {
      return(rgbPix);
    }


@ @<get the Picture out@>=
  public BufferedImage getImage()
    {
    return(image);
    }

@ @<check rgb@>=
  ArrayList<double[]> maxKoord = new ArrayList<double[]>();
  public double[] checkRGB(BufferedImage pixIm,int xPos,int yPos)
    { 
    int rgbMin=0; int rgbMax=-100000000;
    int xMax = 0; int yMax = 0;
    for(int i = 0; i<subimageSize-2 ; i++)
      for(int j = 0; j<subimageSize-2 ; j++)
      {
      if(pixIm.getRGB(i,j)<rgbMin) rgbMin = pixIm.getRGB(i,j);
      if(pixIm.getRGB(i,j)>rgbMax){ rgbMax = pixIm.getRGB(i,j); xMax = i; yMax = j; }
      }
    rgbPix[xMax+xPos][yMax+yPos][0] = pixIm.getRGB(xMax,yMax);
    double[] maxVal = new double[3];
    maxVal[0] = x((double)(xMax+xPos)); maxVal[1] = y((double)(yMax+yPos));
    maxVal[2] = oneortwo;
    maxKoord.add(maxVal);
    return maxVal;
    }

@ @<get max Koordinate@>=
  public ArrayList<double[]> getPointKoord()
    {
    return(maxKoord);
    }

@ @<get choosen picture@>=
  public String getChoose()
    {
    String choo = ((String) choice.getSelectedItem());
    return(choo);
    }

@ @<set points@>=
  public void setPoints()
    {
     illus.setKoord(maxKoord);
    }
    






