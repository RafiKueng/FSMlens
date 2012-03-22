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
      @<Reset the array@>
      String quadrLine="Line"; 
      double x1N,y1N; 
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
  public void mouseClicked(MouseEvent event) { }
  public void mouseReleased(MouseEvent event) { }
  public void mouseMoved(MouseEvent event) { }


@ @<Drawing curves with the mouse@>=
  double x1,y1,x2,y2;
  public void mousePressed(MouseEvent event)
    { 
      drawAxes(1);
      x1 = x(event.getX());
      y1 = y(event.getY());
      x1N = ((1+x1)*300/2);
      y1N = ((1-y1)*300/2);
      if(quadrLine.equals("Rectangle")){
        g.drawRect((int)(x1N-25),(int)(y1N-25),50,50);
        imgrect = image.getSubimage((int)(x1N-24),(int)(y1N-24),48,48);
        imgArr.add(toBufferedImage(imgrect,48,48));
        coord.add((int)x1N);
        coord.add((int)y1N);
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






