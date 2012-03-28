@* The lens model.

@(LensModel.java@>=
  package demon;
  import qgd.util.*;
  import java.awt.event.*;
  import javax.swing.*;
  import java.awt.BorderLayout;
  public class LensModel extends JPanel implements ActionListener
    { @<Lens parameters, potential, and derivatives@>
      @<GUI for lens parameters@>
      @<Example models@>
    }

@ This is an elliptical potential with external shear.
@<Lens parameters, potential, and derivatives@>=
  double a=1, b=1, h=0, n=0.5, g1=0.2, g2=0, eps=0.01;
  double r1 = 0, x1 = 0, y1 = 0;
  int fl=0;

@ @<Lens parameters, potential, and derivatives@>=
    double poten (double x, double y)
      { double rs = a*x*x + b*y*y + 2*h*x*y + eps;
        double psi = Math.pow(rs,n) + g1*(x*x-y*y)/2 + g2*x*y;
        rs = (x-x1)*(x-x1)+(y-y1)*(y-y1) + eps;
        psi += r1*Math.sqrt(rs);  @/
        return psi;
      }

@ This computes the source position from the lens equation.
@<Lens parameters, potential, and derivatives@>=
    double[] sour(double x, double y)
      { double rs = a*x*x + b*y*y + 2*h*x*y + eps;
        double alfx = n*Math.pow(rs,n-1) * 2*(a*x+h*y) + g1*x + g2*y;
        double alfy = n*Math.pow(rs,n-1) * 2*(h*x+b*y) - g1*y + g2*x;  @/
        rs = (x-x1)*(x-x1)+(y-y1)*(y-y1) + eps;
        alfx += r1*(x-x1)/Math.sqrt(rs);  alfy += r1*(y-y1)/Math.sqrt(rs);  @/
        double[] sxy = new double[2];
        sxy[0] = x - alfx;  sxy[1] = y - alfy;
        return sxy;
      }

@ @<Lens parameters, potential, and derivatives@>=
    double maginv(double x, double y)
      { double rs = a*x*x + b*y*y + 2*h*x*y + eps;
        double xx,yy,xy;
        xx = n*(n-1)*Math.pow(rs,n-2) * 4*(a*x+h*y)*(a*x+h*y)
           + n*Math.pow(rs,n-1) * 2*a + g1;
        yy = n*(n-1)*Math.pow(rs,n-2) * 4*(h*x+b*y)*(h*x+b*y)
           + n*Math.pow(rs,n-1) * 2*b - g1;
        xy = n*(n-1)*Math.pow(rs,n-2) * 4*(a*x+h*y)*(h*x+b*y)
           + n*Math.pow(rs,n-1) * 2*h + g2;
        rs = (x-x1)*(x-x1)+(y-y1)*(y-y1) + eps;
        xx += r1/Math.sqrt(rs) * (1-(x-x1)*(x-x1)/rs);
        yy += r1/Math.sqrt(rs) * (1-(y-y1)*(y-y1)/rs);
        xy -= r1/Math.sqrt(rs) * (x-x1)*(y-y1)/rs;  @/
        return (1-xx)*(1-yy)-xy*xy;
      }

@ @<Lens parameters, potential, and derivatives@>=
    double kappa(double x, double y)
      { double rs = a*x*x + b*y*y + 2*h*x*y + eps;
        double xx,yy;
        xx = n*(n-1)*Math.pow(rs,n-2) * 4*(a*x+h*y)*(a*x+h*y)
           + n*Math.pow(rs,n-1) * 2*a + g1;
        yy = n*(n-1)*Math.pow(rs,n-2) * 4*(h*x+b*y)*(h*x+b*y)
           + n*Math.pow(rs,n-1) * 2*b - g1;   @/
        rs = (x-x1)*(x-x1)+(y-y1)*(y-y1) + eps;
        xx += r1/Math.sqrt(rs) * (1-(x-x1)*(x-x1)/rs);
        yy += r1/Math.sqrt(rs) * (1-(y-y1)*(y-y1)/rs);  @/
        return (xx+yy)/2;
      }


@ Now we have to code to take parameter values interactively.
@<GUI for lens parameters@>=
  InputField a_tf,b_tf,h_tf,n_tf,g1_tf,g2_tf,eps_tf;  @/
  InputField r_tf,x_tf,y_tf;  @/
  Daemon wyn;
  JPanel[] panel;
  JComboBox choice;
  public LensModel(Daemon wyn)
    { this.wyn = wyn;  @/
      panel = new JPanel[3];
      for (int n=0; n<3; n++) panel[n] = new JPanel();  @/
      a_tf = newInputField("a",4,"1.0",panel[0]);
      b_tf = newInputField("b",4,"1.0",panel[0]);
      h_tf = newInputField("h",4,"0.0",panel[0]);
      n_tf = newInputField("n",4,"0.5",panel[1]);
      g1_tf = newInputField("g1",4,"0.1",panel[0]);
      g2_tf = newInputField("g1",4,"0.0",panel[0]);
      eps_tf = newInputField("eps",4,"0.01",panel[1]);
      r_tf = newInputField("r",3,"0.0",panel[1]);
      x_tf = newInputField("x",4,"0.0",panel[1]);
      y_tf = newInputField("y",4,"0.0",panel[1]);
      @<Set up the choices@>
      add(Misc.stackPanels(panel));
    }

@ @<GUI for lens parameters@>=
  InputField newInputField(String l, int n, String val, JPanel p)
    { InputField tf = new InputField(l,n,val,p);
      tf.addActionListener(this);  @/
      return tf;
    }

@ @<GUI for lens parameters@>=
  public void actionPerformed(ActionEvent event)
    { Object src = event.getSource();
      if (src instanceof JComboBox)
        { String str = (String) choice.getSelectedItem();
          if (str.compareTo("vanilla")==0)  model_vanilla();
          if (str.compareTo("B1115 model")==0)  model_1115();
          if (str.compareTo("shear")==0)  model_1115_shear();
          if (str.compareTo("more shear")==0) model_1115_moreshear();
          if (str.compareTo("steeper")==0) model_1115_steep();
          if (str.compareTo("shallower")==0) model_1115_shallow();
          if (str.compareTo("B1422 model")==0) model_1422();
        }
      @<Read lens parameters@>
      wyn.source();
    }

@ @<Read lens parameters@>=
  a = a_tf.readDouble(0.1,3);
  b = b_tf.readDouble(0.1,3);
  h = h_tf.readDouble(0,3);
  n = n_tf.readDouble(0.1,3);
  g1 = g1_tf.readDouble(-1,1);
  g2 = g2_tf.readDouble(-1,1);
  eps = eps_tf.readDouble(1e-6,1);
  r1 = r_tf.readDouble(0,3);
  x1 = x_tf.readDouble(-10,10);
  y1 = y_tf.readDouble(-10,10);

@ @<GUI for lens parameters@>=
  void refresh()
    { a_tf.set(a); b_tf.set(b); h_tf.set(h);
      g1_tf.set(g1); g2_tf.set(g2);  @/
      n_tf.set(n); eps_tf.set(eps);  @/
      r1 = x1 = y1 = 0;
      r_tf.set(r1); x_tf.set(x1); y_tf.set(y1);
    }

@ @<Set up the choices@>=
  choice = new JComboBox();
  choice.addItem("vanilla");
  choice.addItem("B1115 model");
  choice.addItem("shear");
  choice.addItem("more shear");
  choice.addItem("steeper");
  choice.addItem("shallower");
  choice.addItem("B1422 model");
  panel[2].add(choice);
  choice.addActionListener(this);


@ @<Example models@>=
  void model_vanilla()
    { a = 1; b = 1; h=0; n=0.5; g1=0.2; g2=0; eps=0.01;  @/
      refresh();  wyn.source(-0.0211,0.1303);
    }
  void model_1115()
    { a = 1.2; b = 1.4; h=0.004; n=0.5; g1=-0.01; g2=0.08; eps=0.01;  @/
      refresh();  wyn.source(-0.0211,0.1303);
    }
  void model_1115_shear()
    { a = 1.2; b = 1.4; h=0.004; n=0.5; g1=-0.015; g2=0.12; eps=0.01; @/
      refresh();  wyn.source(-0.0211,0.1303);
    }
  void model_1115_moreshear()
    { a = 1.2; b = 1.4; h=0.004; n=0.5; g1=-0.02; g2=0.16; eps=0.01;
      refresh();  wyn.source(-0.0211,0.1303);
    }
  void model_1115_steep()
    { a = 2.4000; b = 2.8000; h = 0.0077; n = 0.4;
      g1 = -0.0200; g2 = 0.1000; eps = 0.01;  @/
      refresh();  wyn.source(-0.0238,0.1557);
    }
  void model_1115_shallow()
    { a = 0.6500; b = 0.7500; h = 0.0018; n = 0.7;
      g1 = 0.0200; g2 = 0.0500; eps = 0.01;  @/
      refresh();  wyn.source(-0.0103,0.0795);
    }
  void model_1422()
    { a = 0.6; b = 0.6; h = 0; n = 0.5; g1 = -0.04; g2=-0.21; eps=0.01;  @/
      refresh();  wyn.source(0.2490,0.1913);
    }

