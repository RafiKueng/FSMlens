@* Unicorn.

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn
      extends Figure
      implements ActionListener, MouseListener, MouseMotionListener//, KeyListener
  { 
    @<Init variables for |Unicorn|@>
    @<Code to read and show raw lenses@>
    @<Drawing curves with the mouse@>
    @<get the Picture out@>
    @<get the x pos@>
    @<get the y pos@>
    @<init rgb matrix@>
    @<Reset the array@>
    @<get the RGB matrix out@>
    @<Drawing the source@>
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
  public Unicorn(Monster home, int picSize)
    { super(picSize,picSize);
      this.home = home;
      //this.cuveLines = cuveLines;
      this.picSize = picSize; 
      rgbPix = new int[picSize][picSize][2];
      choice = new JComboBox();
      rect = new JComboBox();
      choice.addActionListener(this);
      rect.addActionListener(this);
      hook.add(choice);
      hook.add(rect);
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
  BufferedImage imageOrg;
  BufferedImage intensity = null;
  
  void showImage(String str)
  {
    str = "images/" + str;
    JApplet app = new JApplet();
    Image img = app.getToolkit().getImage(getClass().getResource(str));
    image = toBufferedImageRGB(img,wd,ht);
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
        System.out.println("this has alpha channel");
        intensity = extractAlpha(img,wd,ht);
      }


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

  public void mousePressed(MouseEvent event)
    { 
      int subimageSize = 30;
      drawAxes(1);
      x1N = event.getX();
      y1N = event.getY();
      x1 = x(x1N);
      y1 = y(y1N);

      if(quadrLine.equals("Rectangle")){
        g.setColor(Color.blue);
        g.drawRect((x1N-subimageSize/2),(y1N-subimageSize/2),subimageSize,subimageSize);
        imgrect = imageOrg.getSubimage((x1N-(subimageSize-2)/2),(y1N-(subimageSize-2)/2),subimageSize-2,subimageSize-2);
        BufferedImage img = toBufferedImage(imgrect,subimageSize-2,subimageSize-2);
	for(int i=0; i<(subimageSize-2); i++)
 	  {
	    for(int j=0; j<(subimageSize-2); j++)
	      {
              //if(rgbPix[x1N+i][y1N+j][0] == 0 && (img.getRGB(i,j)>-10000000  || img.getRGB(i,j)<-12500000)) 
              if(rgbPix[x1N+i][y1N+j][0] == 0 && (img.getRGB(i,j)>-8000000)) 
       	        rgbPix[x1N+i][y1N+j][0] = img.getRGB(i,j);              
 	      }
 	  }
        repaint();
        }
// if mouse is clicke a new cuveLine is drawn
	else if(quadrLine.equals("Line")){

		if(event.getButton()==MouseEvent.BUTTON3){
			System.out.println("in Mous Event Button 3 pressed");
			state=!state;
		}
		if(CuveLines.COUNT==0){
		complex1=new Complex(x2N,y2N);
		cuveLines=new CuveLines(home);  //***********************
		cuveLines.update(complex1,g);	
		}
		
		else if(CuveLines.COUNT==1 && event.getButton()==MouseEvent.BUTTON3 ){
		complex1=new Complex(x2N,y2N);
		cuveLines2=new CuveLines(home);  //***********************
		cuveLines2.update(complex1,g);}

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
		if (cuveLines2 != null)
          	  cuveLines2.update(complex1,g);
	}
	else
	{
		complex1=new Complex(x2N,y2N); //*******************************
		cuveLines.update(complex,g);
		if (cuveLines2 != null)
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

@ @<get the x pos@>=
  public int getXpos()
    {
     return((int)x1N);
    }

@ @<get the y pos@>=
  public int getYpos()
    {
     return((int)y1N);
    }








