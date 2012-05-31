@* Unicorn.

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener, MouseListener, MouseMotionListener//, KeyListener
    { @<Code to read and show raw lenses@>
      @<Drawing curves with the mouse@>
      @<get the Picture out@>
      @<init rgb matrix@>
      @<Reset the array@>
      @<get the RGB matrix out@>
      @<Drawing the source@>
      @<check rgb@>
      @<get max Koordinate@>
      @<get choosen picture@>
      @<set points@>
      @< Reset the curves@>
      @<sort maxKoord for illus@>
      String quadrLine="Line"; 
      int x1N,y1N, picSize; 
      double x2N,y2N;
      int[][][] rgbPix;
      Complex complex;
      Complex complex1;
      Complex complex2;
      BufferedImage imgInt;
      BufferedImage imageOrg = null;
      Illus illus;
      CurveBin curveBin;
    }



@ @<Imports for |Unicorn|@>=
import qgd.util.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
import java.awt.image.*;
import java.awt.Graphics.*;
import java.lang.Object.*;
import java.util.*;
import java.io.*;
import javax.imageio.*; 
import javax.imageio.stream.*;
import javax.imageio.metadata.*;




@ @<Init variables for |Unicorn|@>=
    String quadrLine="Line"; 
    int x1N,y1N, picSize; 
    double x2N,y2N;
    int[][][] rgbPix;
    Complex complex;
    Complex complex1;
    Complex complex2;
    //Vector<Complex> points = new Vector<Complex>();


@ @<Code to read and show raw lenses@>=
  public Unicorn(Monster home, int picSize, Illus illus)
    { super(picSize,picSize);
      this.home = home;
      //this.cuveLines = cuveLines;
      this.picSize = picSize; 
      this.illus = illus;
      rgbPix = new int[picSize][picSize][2];
      choice = new JComboBox();
      rect = new JComboBox();
      choice.addActionListener(this);
      rect.addActionListener(this);
      hook.add(choice);
      hook.add(rect);
      hook.setBackground(Color.black);
      addMouseListener(this);
      addMouseMotionListener(this);
      rgbMatrix();
      @<Initialize fields in |Unicorn|@>

    }

@ @<Code to read and show raw lenses@>=
  JComboBox choice;
  JComboBox rect;
  public void actionPerformed(ActionEvent event)
    { showImage((String) choice.getSelectedItem());
      quadrLine = ((String) rect.getSelectedItem());
      repaint();
    }    


    
@ @<Initialize fields in |Unicorn|@>=
        choice.addItem("PG1115V.gif");
        choice.addItem("Q0047V.gif");
        choice.addItem("PG1115V_gray.gif");
        choice.addItem("PG1115V_gray.jpg");
        choice.addItem("EinsteinCross.png");
        choice.addItem("pngTranspDemo.png");

        rect.addItem("Line");
        rect.addItem("Rectangle");
  


  
 
@ @<Code to read and show raw lenses@>=

  Monster home;
  Graphics g;
  //CuveLines cuveLines; //Global cuveLine
  //CuveLines cuveLines2;
  Image img;
  BufferedImage imgrect = null;
  BufferedImage intensity = null;
  
  void showImage(String str)
    { str = "images/" + str;
      JApplet app = new JApplet();
      Image img = app.getToolkit().getImage(getClass().getResource(str));
      image = toBufferedImage(img,wd,ht);
      @<check if there is alpha channel with intensity@>
      imageOrg = image;
      g = image.getGraphics();
      g.setColor(Color.blue);
      drawAxes(1);
    }

    
    
@ @<check if there is alpha channel with intensity@>=
      /* if this img has an alpha channel, extract it and save it under */
      /* author: rk */
      if (hasAlpha(img)) {
        intensity = extractAlpha(img,wd,ht);
        imgInt = toBufferedImage(intensity,picSize,picSize);
      }
      else imgInt = null;





@ @<Drawing curves with the mouse@>=
    public void mouseEntered(MouseEvent event) { }
    public void mouseExited(MouseEvent event) { }
    public void mouseReleased(MouseEvent event) { }
    public void mouseMoved(MouseEvent event) { }


@ @<Drawing curves with the mouse@>=
    public void mouseClicked(MouseEvent event)
    {
        //System.out.println("click on "+x(event.getX())+" "+y(event.getY()));
    }


@ @<Drawing curves with the mouse@>=
  double x1,y1,x2,y2;
  boolean state=true;
  double oneortwo;
  int subimageSize;
  public void mousePressed(MouseEvent event)
    { 
      oneortwo = 1;
      subimageSize = 25;
      drawAxes(1);
      x1N = event.getX();
      y1N = event.getY();
      x1 = x(x1N);
      y1 = y(y1N);

      int mouseModif = event.getModifiers();

      System.out.println("unic/mpressed " + x1N+" / " + y1N);

      double[] maxVal2 = new double[2];
      if(quadrLine.equals("Rectangle")){
        if(event.getButton()==MouseEvent.BUTTON3 || mouseModif==20)
          { g.setColor(Color.red); oneortwo=2;}
        else if(event.getButton()==MouseEvent.BUTTON2 || mouseModif==24)
          { g.setColor(Color.green); oneortwo=3;}
        else{ g.setColor(Color.blue); oneortwo = 1;}
        g.drawRect((x1N-subimageSize/2),(y1N-subimageSize/2),subimageSize,subimageSize);
        if(imgInt != null) imgrect = imgInt.getSubimage((x1N-(subimageSize-2)/2),(y1N-(subimageSize-2)/2),subimageSize-2,subimageSize-2);
        else  imgrect = imageOrg.getSubimage((x1N-(subimageSize-2)/2),(y1N-(subimageSize-2)/2),subimageSize-2,subimageSize-2);
        BufferedImage img = toBufferedImage(imgrect,subimageSize-2,subimageSize-2);
       // maxVal2 = checkRGB(img,x1N-subimageSize/2,y1N-subimageSize/2);
	for(int i=0; i<(subimageSize-2); i++)
 	  {
	    for(int j=0; j<(subimageSize-2); j++)
	      {
              //if(rgbPix[x1N+i][y1N+j][0] == 0 && (img.getRGB(i,j)>-10000000  || img.getRGB(i,j)<-12500000)) 
              //if(rgbPix[x1N+i][y1N+j][0] == 0 && (img.getRGB(i,j)>-1350000)) 
              //if(rgbPix[x1N+i][y1N+j][0] == 0)
       	        //rgbPix[x1N+i][y1N+j][0] = img.getRGB(i,j);      
                        
 	      }
 	  }
        repaint();
        }
        // if mouse is clicke a new cuveLine is drawn
        if(quadrLine.equals("Line"))
        {
            System.out.println("unic/mpres/line " + event.getButton());
            
            if(event.getButton()==MouseEvent.BUTTON3 || mouseModif==20)
            {
                System.out.println("in Mouse Event Button 3 pressed");
                //state=!state;
                
                /* TODO select the CurveBin whitch is selected and should be modified */
                
            }
            
            Complex mouseClickLocation = new Complex(x1N,y1N);
            
            if(curveBin == null)
            {
                System.out.println("unic/mpres/line/if1 ");
                
                curveBin = new CurveBin(mouseClickLocation,g);            

                /*TODO check if this g remains valid (or is a new one created every time on update...)*/
            }
            
            else if (event.getButton()==MouseEvent.BUTTON3 || mouseModif==20)
            {
                System.out.println("unic/mpres/line/if2 ");
                curveBin.expandCurve(mouseClickLocation);
            }
            
            else if (event.getButton()==MouseEvent.BUTTON1 || mouseModif==18)
            {
                System.out.println("unic/mpres/line/if3 ");
                curveBin.updatePoint(mouseClickLocation);
            }
            
            
            else 
            {
                System.out.println("!!!!!! Error, this else should never occur... in MousePressed");
            }

            repaint();
        }
        
        System.out.println("unic/mousepressed: printing points");
        curveBin.printPoints();
        
    }

//@ @<Drawing curves with the mouse@>=
//
/*
    public void keyTyped(KeyEvent e)
    {
        System.out.println("in Key Event");

        if(e.getKeyChar()=='n')
        {
            System.out.println("in Key Event if");
            state=!state;	
        } 
    }

    public void keyReleased(KeyEvent e)
    {
        System.out.println("in Key Event Pressed");
    }
    
    public void keyPressed(KeyEvent e)
    {
        System.out.println("in Key Event Pressed");
    }

*/


@ @<Drawing curves with the mouse@>=
    Complex mouseDraggedLocation;
    Vector<Complex> points = new Vector<Complex>();
    Vector<CurveLine> dataBase = new Vector<CurveLine>();
    ComplexExtend[] exPoints = new ComplexExtend[3];
    public void mouseDragged(MouseEvent event)
    {
        reset();
        //erase();
        drawAxes(1);
        x2N = event.getX();
        y2N = event.getY();
        //x2 = x(x2N);
        //y2 = y(y2N);
        
        //System.out.println("unic/drag: "+x2N + " / " + y2N);
        mouseDraggedLocation = new Complex(x2N,y2N);
        
        if(quadrLine.equals("Line"))
        {
            
            curveBin.updatePoint(mouseDraggedLocation,g);
            repaint();
            /*TODO expand this in case of multiple curveBin */
            
            /* erledigt
            if(state)
            {
                //drawLine(x1,y1,x2,y2);

                complex=new Complex(x2N,y2N);
                cuveLines.update(complex,g);
                cuveLines2.update(complex1,g);
            }
            else
            {
                complex1=new Complex(x2N,y2N); //*******************************
                cuveLines.update(complex,g);
                cuveLines2.update(complex1,g);
            }
            */
            
        }

        rgbMatrix();
        //points = curveBin.getPoints();
        dataBase = curveBin.getData();
        double[] maxVal2 = new double[2];
        Complex point;
        boolean equals = false;
        maxKoord.clear();
        for(int i = dataBase.size()-1; i>=0;i--){
          exPoints = dataBase.get(i).getExtendPoint();
          for( int j=0; j<3; j++){
            complex = exPoints[j].getPnt();
            if(exPoints[j].getExtrema() != "H"){
                x1N = (int)complex.real();
                y1N = (int)complex.imag();
                int kind;
                if(exPoints[j].getExtrema() != "L") kind = 1;
                else kind = 2;
                if(equals==false) maxVal2 = checkRGB(image,x1N-subimageSize/2,y1N-subimageSize/2,kind);
                System.out.println("das ist  ein punkt mit " + exPoints[j].getExtrema());
                System.out.println("Koord sind: " + complex.real() + " "  + complex.imag());
                }
            }
        } 
        

        illus.ghostWrite(curveBin.dataBase);
        //setPoints();
        repaint();
    }

    
@ @<Creating a new instance of Cuve lines and draw new curves@>=
/*
    public void newDraw()
    {
        component.getAction
    }
*/



@ @<Drawing the source@>=
    public void drawSource(int xMax, int yMax)
    {
        g.setColor(Color.white);
        g.fillOval(xMax,yMax,10,10);
        repaint();
    }


@ @<Reset the array@>=
    public void reset()
    {
    showImage((String) choice.getSelectedItem());
    repaint();
    rgbMatrix();
    maxKoord.clear();
    //imageOrg = null;
    }

@ @< Reset the curves@>=
    public void resetCurv(){
      curveBin.reset();
      curveBin = null;
     // points.clear();
    }


@ @<init rgb matrix@>=
    private void rgbMatrix()
    {
    for(int i=0; i<picSize; i++) 
      {
        for(int j=0; j<picSize; j++)
    	  {
          rgbPix[i][j][0] = 0;
          rgbPix[i][j][1] = 0;
 	  }
      }

    }

    

@ @<get the RGB matrix out@>=
    public int[][][] getrgbMatrix()
    {
        return(rgbPix);
    }

    
@ @<get the Picture out@>=
    public BufferedImage getImage()
    {
        return(image);
    }


@ @<check rgb@>=
  ArrayList<double[]> maxKoord = new ArrayList<double[]>();
  public double[] checkRGB(BufferedImage pixIm,int xPos,int yPos, int kind)
    { 
    int rgbMin=0; int rgbMax=-100000000;
    int xMax = 0; int yMax = 0;
    for(int i = 0; i<subimageSize-2 ; i++)
      for(int j = 0; j<subimageSize-2 ; j++)
      {
      if(pixIm.getRGB(i,j)<rgbMin) rgbMin = pixIm.getRGB(i,j);
      if(pixIm.getRGB(i,j)>rgbMax){ rgbMax = pixIm.getRGB(i,j); xMax = i; yMax = j; }
      }
    rgbPix[xMax+xPos][yMax+yPos][0] = pixIm.getRGB(xMax,yMax);
    double[] maxVal = new double[3];
    maxVal[0] = x((double)(xMax+xPos)); maxVal[1] = y((double)(yMax+yPos));
    maxVal[2] = kind;
    maxKoord.add(maxVal);
    return maxVal;
    }

@ @<sort maxKoord for illus@>=
   public void sort(){
   ArrayList<double[]> maxKoordProv = new ArrayList<double[]>();
   double[] sort = new  double[3];
     for(int i=0; i<maxKoord.size();i++){
       sort = maxKoord.get(i);
       if(sort[2]==1) maxKoordProv.add(sort);
     }
     for(int i=0; i<maxKoord.size();i++){
       sort = maxKoord.get(i);
       if(sort[2]==2) { 
         double[] sortEq = new  double[3];
           maxKoordProv.add(sort);
         }
       }
     
   maxKoord = maxKoordProv;
   }


@ @<get max Koordinate@>=
  public ArrayList<double[]> getPointKoord()
    {
    return(maxKoord);
    }

@ @<get choosen picture@>=
  public String getChoose()
    {
    String choo = ((String) choice.getSelectedItem());
    return(choo);
    }

@ @<set points@>=
  public void setPoints()
    {
     //sort();
     illus.setKoord(maxKoord);
    }
    
