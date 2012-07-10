@* Examples.

@(Illus.java@>=
  package fsmlens;
  import qgd.util.*;
  import java.util.Vector;
  import javax.swing.*;
  import java.awt.BorderLayout;
  import java.awt.event.*;
  import java.awt.*;
  import java.lang.Object.*;
  import java.util.*;

  public class Illus extends JPanel implements ActionListener
    { @<Constructor for |Illus|, including data@>
      @<Setting read-only flags in |Illus|@>
      @<Event handler for |Illus|@>
      @<Unicorn inputs@>
    }

@ @<Constructor for |Illus|, including data@>=
  Console txt; JComboBox choice;
  Vector<String> id,data; boolean efl;
  public Illus(int wd, int ht)
    { txt = new Console(wd,ht);  @/
      choice = new JComboBox();
      @<Edit-input mode@>
      @<Clear input@>
      choice.addActionListener(this);
      JPanel p = new JPanel();  p.add(choice);  @/
      setLayout(new BorderLayout());
      add("South",txt.getPanel());  
      add("North",p);
    }

@ @<Setting read-only flags in |Illus|@>=
  public String getText()
    { return txt.getText();
    }
  public void setEnabled(boolean fl)
    { choice.setEnabled(fl);
      if (fl && efl) txt.setEditable(true);
      else txt.setEditable(false);
    }

@ @<Setting read-only flags in |Illus|@>=
  String sav;
  void save()
    { sav = new String(txt.getText());
    }
  void restore()
    { txt.setText(sav);
      choice.setSelectedIndex(0);
    }
  

@ @<Event handler for |Illus|@>=
  public void actionPerformed(ActionEvent event)
    { String str = (String) choice.getSelectedItem();
      System.out.println(str);
      for (int i=0; i<id.size(); i++)
        { if (str.compareTo(id.get(i))==0)
            { efl = false;
              if (i == 0)
                { txt.setEditable(true); efl = true;
                }
              else if(str.compareTo("clear")==1)
                { txt.setText(""); txt.setEditable(false);
                }
              else
                { txt.setText(data.get(i));
                  System.out.println(data.get(i));
                  txt.setEditable(false);
                }
            }
        }
    }

@ @<Edit-input mode@>=
  id = new Vector<String>(); data = new Vector<String>(); efl = true;  @/
  String str;  StringBuffer strb;  @/
  str = new String("edit"); strb = new StringBuffer();  @/
  choice.addItem(str); id.add(str); data.add(strb.toString());

@ @<Clear input@>=
  str = new String("clear"); strb = new StringBuffer();
  choice.addItem(str); id.add(str); data.add(strb.toString());

@ @<Unicorn inputs@>=
  double picsize;
  void ghostWrite(Vector<CurveLine> scurves, int picsize)
    { 
      this.picsize = picsize/2.0;
      StringBuffer strb = new StringBuffer("object UnicornInput \n");
      strb.append("symm pixrad 8 \n");
      strb.append("zlens 0.3 \n");
      strb.append("g 14 \n");

      @<Work out image order, and write into |strb|@>

      strb.append("models 20 \n"); 
      txt.setText(strb.toString()); 

    }

@ @<Work out image order, and write into |strb|@>=
  Complex cen;
  Complex[] p = scurves.get(0).getPoints();
  if (p[0].subtract(p[1]).mod() < p[0].subtract(p[2]).mod()) cen = p[1];
  else cen = p[2];
  System.out.print("center at ");
  cen.printNumber();
  if (scurves.size()==2)
    { strb.append("multi 4 1.5 \n");
      p = scurves.get(1).getPoints();
      if (p[1].subtract(p[0]).mod() < p[2].subtract(p[0]).mod())
        { writenum(p[2].subtract(cen),strb); strb.append(" 1\n");
          writenum(p[1].subtract(cen),strb); strb.append(" 1\n");
        }
      else
        { writenum(p[1].subtract(cen),strb); strb.append(" 1\n");
          writenum(p[2].subtract(cen),strb); strb.append(" 1\n");
        }
      writenum(p[0].subtract(cen),strb); strb.append(" 2\n");
      p = scurves.get(0).getPoints();
      writenum(p[0].subtract(cen),strb); strb.append(" 2\n");
    }
  System.out.println("Image data");
  for (int i=0; i<scurves.size(); i++)
    scurves.get(i).printCurves();

@ @<Unicorn inputs@>=
  void writenum(Complex z, StringBuffer strb)
    { strb.append(Double.toString(z.real()/picsize)+" "+ Double.toString(-z.imag()/picsize));
    }

 
@ @<Unicorn inputs@>=
  ArrayList<double[]> maxKoord = new ArrayList<double[]>();
  public void setKoord(ArrayList<double[]> maxKoord)
    {
    String str;  StringBuffer strb;
    this.maxKoord = maxKoord;
    double[] maxVal = new double[3];
    str = new String("Unicorn Input");
    strb = new StringBuffer("object UnicornInput \n");
    strb.append("symm pixrad 8 \n");
    strb.append("zlens 0.5 \n");
    strb.append("g 14 \n");
    int size = maxKoord.size();
    strb.append("multi " + size + " 1.0  \n");
    for(int i=0;i<size;i++)
      {
      maxVal = maxKoord.get(i);
      strb.append(" " + maxVal[0] + " " + maxVal[1] + " " + (int)maxVal[2] + " \n");
      } 
    strb.append("models 20 \n"); 
    int sizeId = id.size()-1;
    String check = id.get(sizeId);
    txt.setText(strb.toString());
    System.out.println(strb);
    }

