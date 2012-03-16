@* .

@(Unicorn.java@>=
  package _42pixelens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener
    { @<Code to read and show raw lenses@>
      @<|Image| to |BufferedImage|@>
    }

@ @<Imports for |Unicorn|@>=
  import qgd.util.*;
  import java.awt.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.awt.image.*;


@ @<Code to read and show raw lenses@>=
  public Unicorn(JApplet home)
    { super(320,320);
      this.home = home;
      choice = new JComboBox();
      choice.addActionListener(this);
      hook.add(choice);
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
  JApplet home;
  void showImage(String str)
    { str = "images/" + str;
      Image img = home.getToolkit().getImage(getClass().getResource(str));
      image = toBufferedImage(img,wd,ht);
      for (int nx=0; nx <50; nx++)
        for (int ny=0; ny <50; ny++)
          image.setRGB(nx,ny,Color.red.getRGB());
    }

@ @<|Image| to |BufferedImage|@>=
  static BufferedImage toBufferedImage(Image image, int wd, int ht)
    { image = new ImageIcon(image).getImage();
      PixelGrabber pg = new PixelGrabber(image, 0, 0, 1, 1, false);
      try
        { pg.grabPixels();
        } 
      catch (InterruptedException e) {  }
      boolean hasAlpha = pg.getColorModel().hasAlpha();
      BufferedImage bimage = null;
      GraphicsEnvironment ge;
      ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
      try
        { int transparency = Transparency.OPAQUE;
          if (hasAlpha) transparency = Transparency.BITMASK;
          GraphicsDevice gs = ge.getDefaultScreenDevice();
          GraphicsConfiguration gc = gs.getDefaultConfiguration();
          bimage = gc.createCompatibleImage(wd,ht,transparency);
        }
      catch (HeadlessException e) { }
      if (bimage == null)
        { int type = BufferedImage.TYPE_INT_RGB;
          if (hasAlpha) type = BufferedImage.TYPE_INT_ARGB;
          bimage = new BufferedImage(wd, ht, type);
        }
      bimage.createGraphics().drawImage(image, 0, 0, wd, ht, null);
      return bimage;
    }


