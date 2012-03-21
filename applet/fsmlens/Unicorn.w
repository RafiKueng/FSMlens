@* .

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener
    { @<Code to read and show raw lenses@>
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

