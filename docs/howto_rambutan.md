How to get Rambutan / Literate (Java) Programming running
=========================================================
written for Ubuntu / LinuxMint
                           
rafikueng
v1 2012-03-26 19:00

based on the readme file in the zip

Step by step installation
-------------------------

1. download rambutan:  
    http://www.qgd.uzh.ch/projects/rambutan/rambutan.zip
    
2. extract to some dir (`~/local/src/rambutan`)

3. open makefile, edit the paragrafs:  
    `BIN = $(HOME)/local/bin`  
    `TEXINPUTS = $(HOME)/local/tex/misc`  
    and create those folders (or use system folders)
    
    *    the folder ~/local is used to store local apps, that you compile for yourself and are only useable for the current user (so you don't need any root access, this works on the university machines too..)
    *    the folder ~/local/src contains all the source code for the projects, one subfolder per project
    *    the folder ~/local/bin conatins all executables you compiled (not sorted by projects) so you can later add this folder to path that you can execute those programms from everywhere, see next point
    
4. set path to BIN  
    add the following to your `~/.profile` (hidden) file if your using files within your local installation  
    `PATH="$HOME/local/bin:$PATH"`  
    `export TEXINPUTS="$HOME/local/tex:/usr/share/texmf/tex:/usr/share/texmf/pdftex"`   
    
    or `/etc/environment` if your planning to do a system wide installation,
    or any other file that loads env variables (depending on your linux distro)
    
    (see here: https://help.ubuntu.com/community/EnvironmentVariables#Persistent_environment_variables
    and here http://askubuntu.com/questions/4667/where-to-declare-environment-variables )

   
5. logout / login: so your new .profile file gets read

6. go to your src folder (in console) and compile  
    `~$ cd ~/local/src/rambutan`  
    `~/local/src/rambutan$ make install`  
    `~/local/src/rambutan$ make clean`  

    
(very) short how to use    
-----------------------
* conceptually / general use:
    * creating the sourcecode file: `$ javatangle some_w_file.w`
    * creating the manual / tex files: `$ javaweave some_w_file.w`

* for our project:
    * go to `FSMlens/applet` and type  
        `$ make`
    * (ATTENTION: don't never ever edit the `.java` files directly, those changes are ALWAYS lost..)
    * to cleanup your directory from automatically generated files use:  
        `$ make clean`


additional notes / links
------------------------
* homepage: http://www.qgd.uzh.ch/projects/rambutan/
* manual: http://www.qgd.uzh.ch/projects/rambutan/Manual.pdf
* article in TUGboat: http://www.tug.org/TUGboat/tb23-3-4/tb75saha.pdf

