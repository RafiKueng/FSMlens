@* Synthetic image.

@(Synth.java@>=
  package fsmlens;
  import qgd.util.*;
  import javax.swing.*;
  import java.awt.*;
  import java.awt.image.*;
  import java.awt.Graphics.*;
  import java.lang.Object.*;
  public class Synth extends Figure
    {
        @<Code to generate synth pic@>
        @<set somer picture@>
        Graphics g;
    }

@ @<Code to generate synth pic@>=
public Synth()
        { super(280,280);
	  image = new BufferedImage(wd,ht,1);
	  g = image.getGraphics();	
        }

@ @<set somer picture@>=
  public void setPic(Image imag, int x1,int y1)
    {
	Image img = imag;
	g.drawImage(img,x1,y1,this);	
    }
