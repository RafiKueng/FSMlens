@* Synthetic image.

@(Synthimg.java@>=
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
  public class Synthimg extends Figure
    {
        @<Code to generate synth pic@>
        @<set somer picture@>
        @<Reset the panel@>
        @<Pix counter@>
        Graphics g;
        Unicorn unicorn;
        Monster home;
	Synth synth;
        int[] RGBin;
        int[][][] pixCount = new int[48][48][1];
    }

@ @<Code to generate synth pic@>=
public Synthimg(Monster home, Unicorn unicorn)
        { super(300,300);
          this.home = home;
          this.unicorn = unicorn;
          image = new BufferedImage(wd,ht,1);
          g = image.getGraphics();
	  drawAxes(1);
        }




@ @<set somer picture@>=
ArrayList<Image> imgArr;
ArrayList<Integer> coord;
ArrayList<int[]> allRGBout;
  public void setPixPic(ArrayList<int[]> allRGB)
    {    
        allRGBout = new ArrayList<int[]>();
        imgArr = new ArrayList<Image>();
        coord = new ArrayList<Integer>();
	allRGBout = allRGB;
        imgArr = unicorn.allImg();
        coord = unicorn.allCoord();
        for(int i=0; i < allRGBout.size();i++)
	  { 
	  int[] RGBout = new int[48*48];
	  RGBout = allRGBout.get(i);
	  int x = coord.get(2*i);
	  int y = coord.get(2*i+1);
          for(int j=0; j<48;j++)
 	    {
	    for(int k=0; k<48;k++)
	      {
	      image.setRGB(x+k,y+j,(int)(RGBout[48*j+k]/1.5));
              repaint();
  	      }
   	    }
          repaint();
	  }	
    }

@ @<Pix counter@>=
  private void pixCounter(int xp,int yp)
    { 
      pixCount[xp][yp][1] += 1;  
    }


@ @<Reset the panel@>=
  public void reset()
    {
    g.clearRect(0,0,300,300);
    unicorn.reset();
    repaint();
    }
