@* Unicorn.

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener, MouseListener, MouseMotionListener
    { @<Code to read and show raw lenses@>
      @<Drawing curves with the mouse@>
    }

@ @<Imports for |Unicorn|@>=
  import qgd.util.*;
  import java.awt.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.awt.image.*;


@ @<Code to read and show raw lenses@>=
  public Unicorn(Monster home)
    { super(320,320);
      this.home = home;
      choice = new JComboBox();
      choice.addActionListener(this);
      hook.add(choice);
      addMouseListener(this);
      addMouseMotionListener(this);
      @<Initialize fields in |Unicorn|@>
    }


@ @<Code to read and show raw lenses@>=
  JComboBox choice;
  public void actionPerformed(ActionEvent event)
    { showImage((String) choice.getSelectedItem());
      System.out.println(choice.getSelectedItem());
      repaint();
    }


@ @<Initialize fields in |Unicorn|@>=
  choice.addItem("PG1115V.gif");
  choice.addItem("Q0047V.gif");


@ @<Code to read and show raw lenses@>=
  Monster home;
  void showImage(String str)
    { str = "images/" + str;
      JApplet app = new JApplet();
      Image img = app.getToolkit().getImage(getClass().getResource(str));
      image = toBufferedImage(img,wd,ht);
      for (int nx=0; nx <50; nx++)
        for (int ny=0; ny <50; ny++)
          image.setRGB(nx,ny,Color.red.getRGB());
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
    { drawAxes(1);
      x1 = x(event.getX());
      y1 = y(event.getY());
    }

@ @<Drawing curves with the mouse@>=
  public void mouseDragged(MouseEvent event)
    { erase();
      setColor(Color.green.getRGB());
      x2 = x(event.getX());
      y2 = y(event.getY());
      drawLine(x1,y1,x2,y2);
      repaint();
    }


