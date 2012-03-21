@* Synthetic image.

@(Synth.java@>=
  package fsmlens;
  import qgd.util.*;
  import java.awt.*;
  import java.awt.image.*;
  public class Synth extends Figure
    { public Synth()
        { super(320,320);
          image = new BufferedImage(wd,ht,1);
        }
    }

