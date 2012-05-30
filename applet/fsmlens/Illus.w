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
      @<Example inputs@>
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
              //else if (i == id.size()-1)
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
  void ghostWrite(Vector<CurveLine> scurves)
    { 
      /*StringBuffer strb = new StringBuffer("object UnicornInput \n");
      strb.append("pixrad 8 \n");
      strb.append("zlens 0.3 \n");
      strb.append("g 14 \n");

      @<Work out image order, and write into |strb|@>

      strb.append("models 20 \n"); 
      txt.setText(strb.toString()); */

    }

@ @<Work out image order, and write into |strb|@>=
  Complex cen;
  Complex[] p = scurves.get(0).inPoints;
  if (p[0].subtract(p[1]).mod() < p[0].subtract(p[2]).mod()) cen = p[1];
  cen = p[2];
  System.out.println("size "+scurves.size());
  if (scurves.size()==2)
    { strb.append("multi 4 1.5 \n");
      p = scurves.get(1).inPoints;
      if (p[1].subtract(p[0]).mod() < p[2].subtract(p[0]).mod())
        { writenum(p[2].subtract(cen),strb); strb.append(" 1\n");
          writenum(p[1].subtract(cen),strb); strb.append(" 1\n");
        }
      else
        { writenum(p[1].subtract(cen),strb); strb.append(" 1\n");
          writenum(p[2].subtract(cen),strb); strb.append(" 1\n");
        }
      writenum(p[0].subtract(cen),strb); strb.append(" 2\n");
      p = scurves.get(0).inPoints;
      writenum(p[0].subtract(cen),strb); strb.append(" 2\n");
    }
  System.out.println("Image data");
  for (int i=0; i<scurves.size(); i++)
    scurves.get(i).printCurves();

@ @<Unicorn inputs@>=
  void writenum(Complex z, StringBuffer strb)
    { strb.append(Double.toString(z.real())+" "+Double.toString(-z.imag()));
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
    strb.append("pixrad 8 \n");
    strb.append("zlens 0.311 \n");
    strb.append("g 14 \n");
    int size = maxKoord.size();
    strb.append("multi " + size + " 1.722  \n");
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

@ @<Example inputs@>=
  //str = new String("B1115+080");  @/
  //strb = new StringBuffer("object B1115+080 \n");  @/
  str = new String("PG1115V.gif");  @/
  strb = new StringBuffer("object PG1115V.gif \n");  @/
  strb.append("pixrad 8 \n");
  strb.append("zlens 0.311 \n");
  strb.append("g 14 \n");
  strb.append("multi 4 1.722 \n");
//  strb.append(" 0.3550 1.3220  1 \n");
//  strb.append("-0.9090 -0.7140 1 \n");
//  strb.append("-1.0930 -0.2600 2 \n");
//  strb.append(" 0.7170 -0.6270 2 \n\n");
  strb.append(" 0.221  0.507 1 \n");
  strb.append("-0.271 -0.236 1 \n");
  strb.append("-0.329 -0.071 2 \n");
  strb.append(" 0.342 -0.214 2 \n");
  strb.append("models 20 \n");
  choice.addItem(str); id.addElement(str); data.addElement(strb.toString());


@ @<Example inputs@>=
  str = new String("Einstein-Cross");  @/
  strb = new StringBuffer("object Einstein-Cross \n");  @/
  strb.append("pixrad 8 \n");
  strb.append("zlens 0.311 \n");
  strb.append("g 14 \n");
  strb.append("multi 4 1.722 \n");
  strb.append(" -0.2786 -0.0429  1 \n");
  strb.append("-0.0071 -0.1357 2 \n");
  strb.append("0.1714 0.0643 1 \n");
  strb.append(" -0.0999 0.2429 2 \n\n");
  strb.append("models 20 \n");
  choice.addItem(str); id.addElement(str); data.addElement(strb.toString());



@ @<Example inputs@>=
  str = new String("ACO 1703");  @/
  strb = new StringBuffer("object ACO-1703 \n");  @/
  strb.append("pixrad 10 \n");
  strb.append("minsteep 0 \n");
  strb.append("zlens 0.28 \n");
  strb.append("g 14 \n");
  strb.append("multi 5 0.888 \n");
  strb.append("   22.1  -14.9 1 \n");
  strb.append("  -11.7    6.8 1 \n");
  strb.append("   -6.3    8.4 2 \n");
  strb.append("  -10.5    0.8 2 \n");
  strb.append("   -4.8    2.6 3 \n");
  strb.append("multi 4 2.5 \n");
  strb.append("   -36.1   15.5  1 \n");
  strb.append("    20.3  -18.0  1 \n");
  strb.append("    -7.1  -21.3  2 \n");
  strb.append("    11.0   13.8  2 \n");
  strb.append("multi 2 2.3 \n");
  strb.append("   5.1  -20.2 1 \n");
  strb.append("   0.9  -20.6 2 \n");
  strb.append("multi 3 3.0 \n");
  strb.append("   29.6   38.5 1 \n");
  strb.append("    2.8   48.3 1 \n");
  strb.append("   13.0   45.5 2 \n");
  strb.append("multi 2 3.1 \n");
  strb.append("  -33.6  -11.6  1 \n");
  strb.append("  -25.7  -21.9  2 \n");
  strb.append("multi 3 2.25 \n");
  strb.append("  -10.4   37.8  1 \n");
  strb.append("   25.0   26.7  1 \n");
  strb.append("   14.1   32.7  2 \n");  @/
  choice.addItem(str); id.addElement(str); data.addElement(strb.toString());
