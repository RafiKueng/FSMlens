@* Miscellanea.

@(Misc.java@>=
  package qgd.util;
  import javax.swing.*;
  import java.awt.BorderLayout;
  /** A place for miscellaneous methods. */
  public class Misc
    { @<Shortcuts for multi-row control panels@>
      @<Minor arithmetic@>
      @<Minor thread stuff@>
    }

@ @<Shortcuts for multi-row control panels@>=
  /** Takes an array of JPanel and stacks them vertically
      on a single JPanel which it returns. */
  public static JPanel stackPanels(JPanel[] panel)
    { JPanel stack = panel[0];
      for (int n=1; n<panel.length; n++)
        { JPanel tmp = new JPanel(); tmp.setLayout(new BorderLayout());
          tmp.add("North",stack); tmp.add("South",panel[n]);
          stack = tmp;
        }
      return stack;
    }

@ @<Minor arithmetic@>=
  /** Rounds to nearest integer. */
  public static int round (double x)
    { if (x >= 0) return ((int)(x+0.5));
      else return -((int)(-x+0.5));
    }

@ @<Minor thread stuff@>=
  /** This pauses the current thread for
      msec milliseconds.  */
  public static void sleep(int msec)
    { try
        { Thread.sleep(msec);
        }
      catch (InterruptedException ex) { }
    }

