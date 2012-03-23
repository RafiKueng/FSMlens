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
        @<get the Array with the RGB@>
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synthimg synthimg;
        int[] RGBin;
    }

@ @<Code to generate synth pic@>=
JButton copyButton;
JButton resetButton;
JButton reconstButton;
public Synth(Monster home, Unicorn unicorn, Synthimg synthimg)
        { super(300,300);
          this.home = home;
          this.unicorn = unicorn;
	  this.synthimg = synthimg;
          copyButton = new JButton("Copy"); 
          copyButton.addActionListener(this);
	  hook.add(copyButton);
          reconstButton = new JButton("Reconstr");
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
      if (str.equals("Reconstr")) igetRGB();
 
    }

@ @<set somer picture@>=
ArrayList<Image> imgArr;
ArrayList<Integer> coord;
  public void setPic()
    {
	Image img; 
        imgArr = new ArrayList<Image>();
        coord = new ArrayList<Integer>();
        imgArr = unicorn.allImg();
        coord = unicorn.allCoord();
        for(int i=0; i < imgArr.size();i++)
	{ img = imgArr.get(i);
	  g.drawImage(img,coord.get(2*i),coord.get(2*i+1),this);
          repaint();
	}

	
    }

@ @<get RGB of the pixels@>=
ArrayList<int[]> allRGB;
  private void igetRGB()
    {
    allRGB = new ArrayList<int[]>();
    for(int i=0; i < imgArr.size();i++)
      {
      Image img = imgArr.get(i);
      BufferedImage imag = toBufferedImage(img,48,48);
      int w = imag.getWidth();
      int h = imag.getHeight();
      RGBin = new int[w*h];
      imag.getRGB(imag.getMinX(),imag.getMinY(),w,h,RGBin,0,w);
      allRGB.add(RGBin);
      }
    synthimg.setPixPic(allRGB);
    }

@ @<get the Array with the RGB@>=
  public ArrayList getRGBarray()
    {
    return(allRGB);
    }

@ @<Reset the panel@>=
  public void reset()
    {
    allRGB.clear();
    g.clearRect(0,0,300,300);
    unicorn.reset();
    synthimg.reset();
    repaint();
    }
