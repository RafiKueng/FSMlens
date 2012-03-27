PUB = ..
JAVAC="javac -source 1.5 -target 1.5 -classpath ..:../.."

TEXDIR = tex
DIRS := fsmlens qgd/util simplex
wfiles = $(wildcard $(dir)/*w)
files := $(foreach dir,$(DIRS),$(wfiles))
basefiles := $(basename $(files))
nodirfiles := $(notdir $(basefiles))
dirfiles := $(dir $(basefiles))


all: 
	make  PKG=qgd/util    JAR=Monster compile jarcf
	make  PKG=simplex  JAR=Monster compile jaruf
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
                 makefile README

tmpdoc3:
	make DIR=i
	cd DIR
	for file in $$(ls DIR/*w | cut -d / -f 2) ; \
	    do javaweave $$file ;\
	done

doc:
	# alternate way	
	echo bla $(TEXDIR)/_list.tex
	for file in $(basefiles); do \
	#for file in $$(ls $(DIRS)/*w | cut -d / -f 2); do \
	    echo $$file.w; \
	    #javaweave $$file.w; \
	    mv $$file.tex $(TEXDIR) ;\
	    echo \\include $$file.tex >> $(TEXDIR)/_list.tex ;\
	    #pdflatex ;\
    done
	

tmpdoc: $(TEXDIR)/fsmlens.tex $(TEXDIR)/qgd.tex $(TEXDIR)/simplex.tex
	#echo $$file | sed 's/.w/.tex/g' ;\
	    #textfile := $$file | sed 's/.w/.tex/g' ;\
	    #echo $$textfile ; \
	

clean:
	rm -f */*.class */*.java */*~ *~
	rm -f */*.log */*.dvi */*.toc */*.tex */*.pdf
	rm -f qgd/*/*.class qgd/*/*.java qgd/*/*~ qgd/*~
	rm -f qgd/*/*.log qgd/*/*.dvi qgd/*/*.toc qgd/*/*.tex qgd/*/*.pdf
