@* Console.

@(Console.java@>=
  package qgd.util;
  import javax.swing.*;
  /** A JTextArea with scroller attached. */
  public class Console extends JTextArea
    { private static final long serialVersionUID = 42;
      @<Fields and constructor for |Console|@>
      @<Adding text to |Console|@>
    }

@ @<Fields and constructor for |Console|@>=
  /** Use getPanel() to add a Console to a GUI,
      rather than adding directly. */
  public JPanel getPanel()
    { return panel;
    }
  JPanel panel;

@ @<Fields and constructor for |Console|@>=
  /** Give the size as rows and columns. */
  public Console (int rows, int cols)
   { super(rows,cols);  @/
     setLineWrap(true);  @/
     int vflag = JScrollPane.VERTICAL_SCROLLBAR_ALWAYS;
     int hflag = JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS;  @/
     panel = new JPanel();
     panel.add(new JScrollPane(this,vflag,hflag));  @/
   }

@ @<Adding text to |Console|@>=
  /** Add some text. */
  public void append(String str)
    { super.append(str);
      setCaretPosition(getDocument().getLength());
    }

@ @<Adding text to |Console|@>=
  /** Erase all the text. */
  public void erase()
    { setText("");
    }


