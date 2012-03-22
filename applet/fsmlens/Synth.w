@* Synthetic image.

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
        Graphics g;
        Unicorn unicorn;
        Monster home;
    }

@ @<Code to generate synth pic@>=
JButton copyButton;
JButton resetButton;
public Synth(Monster home, Unicorn unicorn)
        { super(300,300);
          this.home = home;
          this.unicorn = unicorn;
          copyButton = new JButton("Copy"); 
          copyButton.addActionListener(this);
	  hook.add(copyButton);
          resetButton = new JButton("Reset");
          resetButton.addActionListener(this);
          hook.add(resetButton);
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
 
    }

@ @<set somer picture@>=
  public void setPic()
    {
	Image img = unicorn.getImage();
	g.drawImage(img,unicorn.getXpos(),unicorn.getYpos(),this);
        ArrayList<Image> imgArr = new ArrayList<Image>();
        ArrayList<Integer> coord = new ArrayList<Integer>();
        imgArr = unicorn.allImg();
        coord = unicorn.allCoord();
        for(int i=0; i < imgArr.size();i++)
	{ img = imgArr.get(i);
	  g.drawImage(img,coord.get(2*i),coord.get(2*i+1),this);
          repaint();
	}	
    }

@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,300,300);
    unicorn.reset();
    repaint();
    }
