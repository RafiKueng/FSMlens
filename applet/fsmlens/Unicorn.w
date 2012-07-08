@* Unicorn.

@(Unicorn.java@>=
  package fsmlens;
  @<Imports for |Unicorn|@>
  public class Unicorn extends Figure implements ActionListener, MouseListener, MouseMotionListener
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
      @<full check of rgb@>
      String quadrLine="Line"; 
      int x1N,y1N, picSize; 
      double x2N,y2N;
      int[][][] rgbPix;
      Complex complex;
      Complex complex1;
      Complex complex2;
      BufferedImage imgInt = null;
      BufferedImage imageOrg = null;
      Illus illus;
      CurveBin curveBin;
      double[] masscenter = new double[2];
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
import static java.lang.Math.*;




@ @<Code to read and show raw lenses@>=
  public Unicorn(Monster home, int picSize, Illus illus)
    { super(picSize,picSize);
      this.home = home;
      this.picSize = picSize; 
      this.illus = illus;
      rgbPix = new int[picSize][picSize][2];
      choice = new JComboBox();
      choice.addActionListener(this);
      hook.add(choice);
      addMouseListener(this);
      addMouseMotionListener(this);
      rgbMatrix();
      @<Initialize fields in |Unicorn|@>

    }

@ @<Code to read and show raw lenses@>=
  JComboBox choice;
  public void actionPerformed(ActionEvent event)
    { if (event.getSource() == choice)
        { showImage((String) choice.getSelectedItem());
          repaint();
        }
    }    


    
@ @<Initialize fields in |Unicorn|@>=
        choice.addItem("PG1115V.gif");
        choice.addItem("Q0047V.gif");
        choice.addItem("PG1115V_gray.gif");
        choice.addItem("PG1115V_gray.jpg");
        choice.addItem("EinsteinCross.png");
        choice.addItem("pngTranspDemo.png");



  
 
@ @<Code to read and show raw lenses@>=

  Monster home;
  Graphics g;
  Image img;
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

    
    
@ If this img has an alpha channel, extract it and save it under
(author: rk)
@<check if there is alpha channel with intensity@>=
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
    public void mouseClicked(MouseEvent event) { }


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

      double[] maxVal2 = new double[3];

      if(quadrLine.equals("Line")){
            
            if(event.getButton()==MouseEvent.BUTTON3 || mouseModif==20)
            {
                
                // TODO select the CurveBin whitch is selected and should be modified
                
            }
            
            Complex mouseClickLocation = new Complex(x1N,y1N);
            
            if(curveBin == null)
            {
                
                curveBin = new CurveBin(mouseClickLocation,g);            

                // TODO check if this g remains valid (or is a new one created every time on update...)
            }
            
            else if (event.getButton()==MouseEvent.BUTTON3 || mouseModif==20)
            {
                curveBin.expandCurve(mouseClickLocation);
            }
            
            else if (event.getButton()==MouseEvent.BUTTON1 || mouseModif==18)
            {
            }
            
            
            else 
            {
                System.out.println("!!!!!! Error, this else should never occur... in MousePressed");
            }

            repaint();
        }
        
    }



@ @<Drawing curves with the mouse@>=
    Complex mouseDraggedLocation;
    Vector<Complex> points = new Vector<Complex>();
    Vector<CurveLine> dataBase = new Vector<CurveLine>();
    ComplexExtend[] exPoints = new ComplexExtend[3];

    public void mouseDragged(MouseEvent event)
    { mouseDragCalc(event);
      repaint();
    }


    synchronized void mouseDragCalc(MouseEvent event)
    {
        reset();
        drawAxes(1);
        x2N = event.getX();
        y2N = event.getY();
       
       
        mouseDraggedLocation = new Complex(x2N,y2N);
        
        if(quadrLine.equals("Line"))
    
        {
            
         
            curveBin.updatePoint(mouseDraggedLocation,g);
            repaint();
            // TODO expand this in case of multiple curveBin
            
        }

        rgbMatrix();
        dataBase = curveBin.getData();
        double[] maxVal2 = new double[3];
        Complex point;
        boolean high = false;
        maxKoord.clear();
        for(int i = dataBase.size()-1; i>=0;i--){
          exPoints = dataBase.get(i).points;
          for( int j=0; j<3; j++){
            complex = exPoints[j].getPnt();
            if(exPoints[j].getExtrema() == "H"){
                masscenter[0] = x(complex.real());
                masscenter[1] = y(complex.imag());
                }
            if(exPoints[j].getExtrema() != "H"){
                x1N = (int)complex.real();
                y1N = (int)complex.imag();
                int kind;
                if(exPoints[j].getExtrema() == "S") kind = 2;
                else kind = 1;
                if(imgInt != null){ 
                  BufferedImage img = null;
                  img = toBufferedImage(imgInt,picSize,picSize);
                  maxVal2 = checkRGBfull(imgInt,x1N-subimageSize/2,y1N-subimageSize/2,kind);
                  }
                else{
                  maxVal2 = checkRGBfull(image,x1N-subimageSize/2,y1N-subimageSize/2,kind);                  
                  }              
                }
            }
        } 
        sort();
        setPoints();
    }

    

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
    }

@ @< Reset the curves@>=
    public void resetCurv(){
      if(curveBin!=null){
        curveBin.reset();
        curveBin = null;
        points.clear();
        }
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
        return rgbPix;
    }

    
@ @<get the Picture out@>=
    public BufferedImage getImage()
    {
        return image ;
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
    if(pixIm.getRGB(xMax,yMax)<-1000) rgbPix[xMax+xPos][yMax+yPos][0] = -1;
    double[] maxVal = new double[3];
    maxVal[0] = x((double)(xMax+xPos)); maxVal[1] = y((double)(yMax+yPos));
    maxVal[2] = kind;
    maxKoord.add(maxVal);
    return maxVal;
    }


@ @<full check of rgb@>=
  public double[] checkRGBfull(BufferedImage pixIm,int xPos,int yPos, int kind)
    { 
    int rgbMin=0; int rgbMax=-100000000;
    int xMax = 0; int yMax = 0;
    for(int i = 0; i<subimageSize ; i++)
      for(int j = 0; j<subimageSize ; j++)
      {
      if(pixIm.getRGB(xPos+i,yPos+j)<rgbMin) rgbMin = pixIm.getRGB(xPos+i,yPos+j);
      if(pixIm.getRGB(xPos+i,yPos+j)>rgbMax){ rgbMax = pixIm.getRGB(xPos+i,yPos+j); xMax = i; yMax = j; }
      }
    rgbPix[xMax+xPos][yMax+yPos][0] = pixIm.getRGB(xPos+xMax,yPos+yMax);
    if(pixIm.getRGB(xPos+xMax,yPos+yMax)<-1000) rgbPix[xMax+xPos][yMax+yPos][0] = -1;
    double[] maxVal = new double[3];
    maxVal[0] = x((double)(xMax+xPos)); maxVal[1] = y((double)(yMax+yPos));
    maxVal[2] = kind;
    maxKoord.add(maxVal);
    return maxVal;
    }


@ @<sort maxKoord for illus@>=
   public void sort(){
   double[] masscent = new double[2];
   ArrayList<double[]> maxKoordProv = new ArrayList<double[]>();
   double[] sort = new  double[3];
   Vector<Integer> length = new Vector<Integer>();
   for(int i=0; i<maxKoord.size();i++){
     sort = maxKoord.get(i);
     sort[0] = sort[0]-masscenter[0];
     sort[1] = sort[1]-masscenter[1]; 
     maxKoord.set(i,sort);
     }
   for(int i=0; i<maxKoord.size();i++){
       sort = maxKoord.get(i);
       double sxy = sqrt(xpix(sort[0])*xpix(sort[0])+
                    ypix(sort[1])*ypix(sort[1]));
       int leng = (int) sxy;
       if(length.contains(leng)==false){
         if(sort[2]==1) maxKoordProv.add(sort);
         length.add(leng);
         }
     }
   Vector<Integer> length2 = new Vector<Integer>();
   for(int i=0; i<maxKoord.size();i++){
       sort = maxKoord.get(i);
       double sxy = sqrt(xpix(sort[0])*xpix(sort[0])+
                         ypix(sort[1])*ypix(sort[1]));
       int leng = (int) sxy;
       if(length2.contains(leng)==false){
         if(sort[2]==2) maxKoordProv.add(sort);
         length2.add(leng);
         }
       }     
   maxKoord = maxKoordProv;
   }


@ @<get max Koordinate@>=
  ArrayList<double[]> getPointKoord()
    {
    return maxKoord;
    }

@ @<get choosen picture@>=
  public String getChoose()
    {
    String choo = ((String) choice.getSelectedItem());
    return choo;
    }

@ @<set points@>=
  public void setPoints()
    {
     illus.setKoord(maxKoord);
    }
    
