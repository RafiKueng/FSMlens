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
        @<get RGB of the pixels@>
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synthimg synthimg;
        int[] RGBin;
        int[][][] rgbPix;
        int picSize;
    }

@ @<Code to generate synth pic@>=
JButton copyButton;
JButton resetButton;
JButton reconstButton;
public Synth(Monster home, Unicorn unicorn, Synthimg synthimg, int picSize)
        { super(picSize,picSize);
          this.picSize = picSize;
          rgbPix = new int[picSize][picSize][2];
          this.home = home;
          this.unicorn = unicorn;
	  this.synthimg = synthimg;
          copyButton = new JButton("Copy"); 
          copyButton.addActionListener(this);
	  hook.add(copyButton);
          reconstButton = new JButton("Get Source");
          reconstButton.addActionListener(this);
          hook.add(reconstButton);
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
      if (str.equals("Get Source")) getSource();
 
    }

@ @<set somer picture@>=
  public void setPic()
    {
	rgbPix = unicorn.getrgbMatrix();
	Image img; 
         for(int i=0; i<picSize; i++) 
           {
            for(int j=0; j<picSize; j++)
    	      {
              image.setRGB(i,j,rgbPix[i][j][0]); 
 	      System.out.println("hallo, this is test");
 	      }
           }
        repaint();	
    }

@ @<get RGB of the pixels@>=
  private void getSource()
    {
    synthimg.setPixPic();
    }

@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,picSize,picSize);
    unicorn.reset();
    synthimg.reset();
    repaint();
    }
