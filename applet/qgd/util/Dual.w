@* Dual-mode.  This is a base class for programs wanting to run both
as applications and applets.

@(Dual.java@>=
  package qgd.util;
  import java.awt.event.*;
  import javax.swing.*;
  import java.awt.BorderLayout;
  import java.awt.Color;
  public class Dual extends JApplet implements Runnable, ActionListener,
    WindowListener
    { private static final long serialVersionUID = 42;
      @<Choice of execution modes@>
      @<|Dual| constructor and basic GUI elements@>
      @<The program state@>
      @<Handling events in |Dual|@>
      @<Handling diagnostics@>
    }

@ @<Choice of execution modes@>=
  /** There are three possible running modes,
      and mode() says which is current:
      zero means running as an application without GUI,
      one means running as an application with a GUI,
      two means running as an applet. */
  public static int mode()
    { return mode;
    }
  private static int mode=0;

@ @<Handling diagnostics@>=
  public static void message(String arg)
    { if (mode==0) System.out.println(arg);
      else instance.printMessage(arg);
    }
  protected void printMessage(String arg) { }

@ @<|Dual| constructor and basic GUI elements@>=
  /** Attach all GUI elements,
      such as runButton and pauseButton when needed,
      to mainPane. */
  public JPanel mainPane;  @/
  JButton showButton; JFrame frame;

@ @<|Dual| constructor and basic GUI elements@>=
  /** Starts the run() thread. */
  public JButton runButton;

@ @<|Dual| constructor and basic GUI elements@>=
  /** Does not itself pause,
      only makes isRunning() false. */
  public JButton pauseButton;


@ @<|Dual| constructor and basic GUI elements@>=
  static Dual instance;
  public Dual()
    { mode = 1; instance = this;  @/
      mainPane = new JPanel(); mainPane.setLayout(new BorderLayout());  @/
      @<Initialize |runButton|, |pauseButton|@>
    }

@ @<Initialize |runButton|, |pauseButton|@>=
  runButton = new JButton("run");
  runButton.addActionListener(this);  @/
  pauseButton = new JButton("pause");
  pauseButton.addActionListener(this);
  pauseButton.setEnabled(false);

@ @<Choice of execution modes@>=
  public void init()
    { if (mode < 2)  // in case browser bug calls |init| twice
        { mode = 2;
          main();
        }
    }

@ @<Choice of execution modes@>=
  /** In applet mode main() is called automatically,
      but in standalone mode main(String) must call
      main() explicitly.  */
  public void main() { }

@ @<Choice of execution modes@>=
  /** Always called in the last line of main(). */
  public void show(String title, String label)
    { frame = new JFrame();  @/
      frame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
      frame.addWindowListener(this);
      frame.setTitle(title);  @/
      frame.getContentPane().add(mainPane); frame.pack();
      if (mode==2)
        { showButton = new JButton(label);
          showButton.addActionListener(this);  @/
          setBackground(new Color(255,255,240));
          showButton.setBackground(new Color(255,255,240));  @/
          getContentPane().add("Center",showButton);
        }
      else frame.setVisible(true);
    }


@ @<Handling events in |Dual|@>=
  public void actionPerformed(ActionEvent event)
    { if (mode==2 && event.getSource()==showButton) frame.setVisible(true);
      else if (event.getSource()==runButton) startRun();
      else if (event.getSource()==pauseButton) stopRun();
    }

@ @<Handling events in |Dual|@>=
  public void windowActivated(WindowEvent e)  { }
  public void windowClosed(WindowEvent e) { }
  public void windowClosing(WindowEvent e)
    { if (mode==1) quit();
      if (mode==2)
        { stopRun(); frame.setVisible(false);
        }
    }
  public void windowDeactivated(WindowEvent e)  { }
  public void windowDeiconified(WindowEvent e) { }
  public void windowIconified(WindowEvent e) { }
  public void windowOpened(WindowEvent e) { }

@ @<The program state@>=
  Thread thread;
  protected void startRun()
    { runButton.setEnabled(false);
      pauseButton.setEnabled(true);
      thread = new Thread(this); thread.start();
    }
  protected void stopRun()
    { if (Dual.isRunning())
        { pauseButton.setEnabled(false);
          try
            { thread.join();
            }
          catch (InterruptedException ex) { }
          runButton.setEnabled(true);
        }
    }
  protected void quit()
    { System.exit(0);
    }


@ @<The program state@>=
  /** A flag which run() should check regularly,
      and tidy up quickly and exit on a signal of false. */
  public static boolean isRunning()
    { if (mode()==0) return true;
      else return instance.pauseButton.isEnabled();
    }


@ @<The program state@>=
  /** A run() method should finish by calling
      finishRun() to tidy up the internal state. */
  public void finishRun()
    { pauseButton.setEnabled(false);
      runButton.setEnabled(true);
    }

@ @<The program state@>=
  /** Intensive work should be done from a
      run() method.  */
  public void run()
    { finishRun();
    }


