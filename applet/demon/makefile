all: Daemon.class

#---------------compile the classes--------------------------------------

#Daemon.class: Daemon.java LensModel.java MPlot.java PPlot.class
#	$(JAVAC) Daemon.java

#PPlot.class: PPlot.java
#	$(JAVAC) PPlot.java

Daemon.class: Daemon.java LensModel.java MPlot.java PPlot.java
	$(JAVAC) Daemon.java


#---------------Tangle to get java files---------------------------------

Daemon.java: Daemon.w
	javatangle Daemon.w

LensModel.java: LensModel.w
	javatangle LensModel.w

MPlot.java: MPlot.w
	javatangle MPlot.w

PPlot.java: PPlot.w
	javatangle PPlot.w

#------------------------------------------------------------------------
clean:
	rm -f *.class *.log *.dvi *.toc *.tex *.java *~
