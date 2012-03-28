@* Unicorn.

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener, MouseListener, MouseMotionListener
    { @<Code to read and show raw lenses@>
      @<Drawing curves with the mouse@>
      @<get the Picture out@>
      @<get the x pos@>
      @<get the y pos@>
      @<get all the picture in a array@>
      @<return all the coord in a array@>
      @<init rgb matrix@>
      @<Reset the array@>
      @<get the RGB matrix out@>
      String quadrLine="Line"; 
      int x1N,y1N; 
      int[][][] rgbPix = new int[300][300][2];
      ArrayList<BufferedImage> imgArr = new ArrayList<BufferedImage>();
      ArrayList<Integer> coord = new ArrayList<Integer>();
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



@ @<Code to read and show raw lenses@>=
  public Unicorn(Monster home)
    { super(300,300);
      this.home = home;
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
  rect.addItem("Line");
  rect.addItem("Rectangle");


@ @<Code to read and show raw lenses@>=
  Monster home;
  Graphics g;
  Image img;
  BufferedImage imgrect = null;
  void showImage(String str)
    { str = "images/" + str;
      JApplet app = new JApplet();
      Image img = app.getToolkit().getImage(getClass().getResource(str));
      image = toBufferedImage(img,wd,ht);
      g = image.getGraphics();
      g.setColor(Color.blue);
      drawAxes(1);
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
  public void mousePressed(MouseEvent event)
    { 
      drawAxes(1);
      x1 = x(event.getX());
      y1 = y(event.getY());
      x1N = (int)(((1+x1)*300.0/2.0));
      y1N = (int)(((1-y1)*300.0/2.0));
      if(quadrLine.equals("Rectangle")){
        g.drawRect((x1N-25),(y1N-25),50,50);
        imgrect = image.getSubimage((x1N-24),(y1N-24),48,48);
        BufferedImage img = toBufferedImage(imgrect,48,48);
	for(int i=0; i<48; i++)
 	  {
	    for(int j=0; j<48; j++)
	      {
              if(rgbPix[x1N+i][y1N+j][0] == 0) 
	        rgbPix[x1N+i][y1N+j][0] = img.getRGB(i,j);
 	      }
 	  }
        repaint();
        }
    }

@ @<Drawing curves with the mouse@>=
  public void mouseDragged(MouseEvent event)
    { erase();
      drawAxes(1);
      x2 = x(event.getX());
      y2 = y(event.getY());
      if(quadrLine.equals("Line"))
        drawLine(x1,y1,x2,y2);
      repaint();
    }

@ @<Reset the array@>=
  public void reset()
    {
    imgArr.clear();
    coord.clear();
    showImage((String) choice.getSelectedItem());
    repaint();
    rgbMatrix();
    }

@ @<init rgb matrix@>=
  private void rgbMatrix()
    {
    for(int i=0; i<300; i++) 
      {
        for(int j=0; j<300; j++)
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
    return(imgrect);
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

@ @<get all the picture in a array@>=
  public ArrayList allImg()
    {
    return(imgArr);
    }

@ @<return all the coord in a array@>=
  public ArrayList allCoord()
    {
    return(coord);
    }






