@* MPlot. This is an extension of |Plot| with clickable coordinates.

@(MPlot.java@>=
  package demon;
  import qgd.util.*;
  import java.awt.event.*;
  public class MPlot extends Figure implements MouseListener
    { @<Constructor for MPlot@>
      @<Mouse methods@>
    }

@ @<Constructor for MPlot@>=
  Daemon wyn;
  public MPlot(Daemon wyn, int ht, int wd)
    { super(ht,wd); this.wyn = wyn; addMouseListener(this);
    }

@ @<Mouse methods@>=
  public void mouseEntered(MouseEvent event) { }
  public void mouseExited(MouseEvent event) { }
  public void mousePressed(MouseEvent event) { }
  public void mouseReleased(MouseEvent event) { }
  public void mouseClicked(MouseEvent event)
    { wyn.source(x(event.getX()),y(event.getY()));
    }
