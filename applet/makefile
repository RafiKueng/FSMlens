PUB = ..
JAVAC="javac -source 1.5 -target 1.5 -classpath ..:../.."

all: 
	make  PKG=qgd/util JAR=Daemon compile jarcf
	make  PKG=demon JAR=Daemon compile jarumf
	make  PKG=qgd/util JAR=Monster compile jarcf
	make  PKG=simplex JAR=Monster compile jaruf
	make  PKG=fsmlens JAR=Monster compile jarumf

compile:
	make JAVAC=$(JAVAC) -C $(PKG) 

jarcf:
	jar cMf  $(PUB)/$(JAR).jar \
                 $(PKG)/*.w $(PKG)/*.class \
                 $(PKG)/makefile

jaruf:
	jar uMf   $(PUB)/$(JAR).jar \
                  $(PKG)/*.w $(PKG)/*.ch $(PKG)/*.class \
                  $(PKG)/makefile

jarumf:
	jar umf  $(PKG)/manifest $(PUB)/$(JAR).jar \
                 $(PKG)/*.w $(PKG)/*.class \
                 $(PKG)/makefile $(PKG)/manifest \
                 $(PKG)/images/* \
                 makefile

clean:
	rm -f */*.class */*.java */*~ *~
	rm -f */*.log */*.dvi */*.toc */*.tex */*.pdf
	rm -f qgd/*/*.class qgd/*/*.java qgd/*/*~ qgd/*~
	rm -f qgd/*/*.log qgd/*/*.dvi qgd/*/*.toc qgd/*/*.tex qgd/*/*.pdf
