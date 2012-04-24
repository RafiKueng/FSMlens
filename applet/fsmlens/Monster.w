@* Monster.

@(Monster.java@>=
  package fsmlens;
  @<Imports for |Monster|@>
  public class Monster extends Dual
    { @<Layout for the |Monster| GUI@>
      @<Managing the text and plots in |Monster|@>
      @<Managing the buttons in |Monster|@>
      @<The numerical thread@>
      @<Setting GUI states@>
      @<get the source coord@>
    }


@ @<Imports for |Monster|@>=
  import qgd.util.*;
  import javax.swing.*;
  import java.awt.event.*;
  import java.awt.BorderLayout;
  import java.io.*;
  import java.text.*;
  import java.awt.*;
  import java.util.*;
  import java.awt.Dimension;
  import java.awt.Graphics;
  import java.awt.Image;
  
  import javax.swing.ImageIcon;
  import javax.swing.JFrame;
  import javax.swing.JPanel;

@ @<Layout for the |Monster| GUI@>=
  int threads=8;
  static boolean quiet = false;

@ @<Layout for the |Monster| GUI@>=
  public static void main(String[] args)
    { Monster wyn = new Monster();
      wyn.main();
    }

@ @<Layout for the |Monster| GUI@>=
  public void main()
    { lenses = new Lenses(threads);
      @<Put control buttons to North@>
      @<Put text panels to West@>
      @<Put plots to East@>
      @<Put raw image in the middle@>
      setWaiting();
      show("Lens model applet version 0.1", "Show window");
    }

@ @<Print startup information@>=
  message("Using " + threads + " thread(s)");
  String tag = "B";
  double mem = (double)Runtime.getRuntime().maxMemory();
  if (mem / 1024 >= 1) { mem /= 1024; tag = "KB"; }
  if (mem / 1024 >= 1) { mem /= 1024; tag = "MB"; }
  if (mem / 1024 >= 1) { mem /= 1024; tag = "GB"; }
  message("Java VM has " 
    + (new DecimalFormat("###0.00").format(mem))
    + tag + " of memory available.");

@ Now for the many elements in the GUI.
@<Managing the text and plots in |Monster|@>=
  Illus inp; qgd.util.Console err;  @/

@ @<Managing the buttons in |Monster|@>=
  boolean completed;
  JButton bresume;
  CuveLines cuveLines;
  Unicorn unicorn;
  Synth synth;
  Synthimg synthimg;

@ @<Put control buttons to North@>=
  bresume = new JButton("resume");  bresume.addActionListener(this);
  JPanel cp = new JPanel();  @/
  cp.setBackground(Color.black);
  cp.add(runButton);
  cp.add(pauseButton); cp.add(bresume);
  cp.setBackground(Color.black);
  mainPane.add("North",cp);

@ @<Put text panels to West@>=
  inp = new Illus(12,30);  @/
  err = new qgd.util.Console(16,30);  err.setEditable(false);  @/
  JPanel txt = new JPanel();  txt.setLayout(new BorderLayout());  @/
  txt.setBackground(Color.black);
  txt.add("North",inp);  @/
  txt.add("South",err.getPanel());  @/
  mainPane.add("West",txt);


@ @<Put plots to East@>=
  int picSize = 400;
  //cuveLines = new CuveLines();
  unicorn = new Unicorn(this,picSize,inp);
  synthimg = new Synthimg(this,unicorn,picSize);
  synth = new Synth(this,unicorn,synthimg,picSize);
  FigDeck pd = new FigDeck(); 
  pd.setBackground(Color.black);
  //pd.addFigure("pixellation",lenses.plotPix);
  //pd.addFigure("mass",lenses.plotMass);
  //pd.addFigure("potential",lenses.plotPoten);
  //pd.addFigure("arrival time",lenses.plotArriv);
  //pd.add("North",synthimg.getPanel()); 
  pd.add("North",synth.getPanel()); 
  mainPane.add("East",pd);

@ @<Put raw image in the middle@>=
  JPanel ip = new JPanel();  ip.setLayout(new BorderLayout());
    ip.setBackground(Color.black);
  ip.add("North",unicorn.getPanel());
  //ip.add("South",synth.getPanel());
  mainPane.add("Center",ip);
  unicorn.repaint();


@ @<Managing the text and plots in |Monster|@>=
  protected void printMessage(String str)
    { if (quiet) return;
      synchronized(err)
            { if (str.length()==0) err.setText(new String());
              else
                { err.append(str+"\n");
                  err.setCaretPosition(err.getDocument().getLength());
                }
            }
    }


@ @<Managing the buttons in |Monster|@>=
  public void actionPerformed(ActionEvent event)
    { super.actionPerformed(event);
      unicorn.repaint();
      String str = event.getActionCommand();
      if (str.equals("resume")) resumeRun();
    }

@ @<Managing the buttons in |Monster|@>=
  protected void quit()
    { Object[] options = {"quit","cancel"};
      int resp = Dialogs.getUserChoice(this,
             "Are you sure?","Really quit?",options);
      System.out.println("resp = "+(resp));
      if (resp==0) System.exit(0);
    }



@ The main numerical work happens from |Lenses|.
@<The numerical thread@>=
  Lenses lenses=null;  @/

@ @<The numerical thread@>=
  protected void startRun()
    { if (completed)
        { Object[] options = {"new run","no"};
          int resp = Dialogs.getUserChoice(this,
                     "Are you sure?","Really new run?",options);
          if (resp!=0) return;
        }
      err.setText(new String());
      try
        { lenses.setup(inp.getText()); inp.save();
          setGUI(false,false,false);
          super.startRun();
        }
      catch (ErrorMsg ex)
        { message(ex.getMessage());
          setWaiting();
        }
    }


@ @<The numerical thread@>=
  protected void stopRun()
    { super.stopRun();
      setGUI(true,true,true);
    }

@ @<The numerical thread@>=
  void resumeRun()
    { inp.restore();  @/
      setGUI(false,false,false);
      super.startRun();
    }

@ @<The numerical thread@>=
  protected void setWaiting()
    { super.run();
      setGUI(false,true,false);
    }
  protected void setCompleted()
    { super.run();
      setGUI(false,true,true);
    }


@ @<The numerical thread@>=
  public void run()
    { try
        { lenses.find_model();
          setCompleted();
        }
      catch (InterruptedException erm)
        { message(erm.getMessage());
          setWaiting();
        }
      catch (ErrorMsg erm)
        { message(erm.getMessage());
          setWaiting();
        }
      super.run();
    }


@ @<Setting GUI states@>=
  void setGUI(boolean resumef, boolean readf, boolean compf)
    { bresume.setEnabled(resumef);
      inp.setEnabled(readf);
      completed = compf;
    }

@ @<get the source coord@>=
  public double[] sourCoord(double[] coordS)
    {
    double[] soCo = new double[3];
    soCo = lenses.sourceCoord(coordS);
    return(soCo);
    }

