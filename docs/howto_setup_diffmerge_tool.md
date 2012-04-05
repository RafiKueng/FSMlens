How to get a nice GUI for diffs and merges
=========================================================
written for Ubuntu / LinuxMint

rafikueng
v1 2012-04-05 17:30

*   based on the following blog entries:
    *   <http://nathanhoad.net/how-to-meld-for-git-diffs-in-ubuntu-hardy>
    *   <http://blog.wuwon.id.au/2010/09/painless-merge-conflict-resolution-in.html>
*   and the prorgam:
    *   <http://meldmerge.org>
    

Set up the Diff tool
--------------------
(to be able to see differences in two versions of a file using `git diff`)
    
1.  get the tool: 
    `$ sudo apt-get install meld`
    
2.  create a starter script, name if `diffmeld.py` and save it somewhere the system finds it (eg. you local bin directory created for rambutan would be nice: `~/local/bin`)

    `#!/usr/bin/python`  
    `import sys`  
    `import os`  
    `os.system('meld "%s" "%s"' % (sys.argv[2], sys.argv[5]))`
    
3.  make it executable: 
    `chmod +x diffmeld.py`
    
4.  set up the diff tool in git:
    `git config --global diff.external diffmeld.py`
    
Set up the merge tools
----------------------
so once you merge two branches, and get conflicts, you'll have a nice view to everything that happend.

### Some theory: ###
(to get the full story go to <http://blog.wuwon.id.au/2010/09/painless-merge-conflict-resolution-in.html>)

There are 4 versions that are interesting:

*   your version (`[filename].LOCAL.[version].txt`, short `local`)
*   the other branch versions (`[filename].REMOTE.[version].txt`, short `remote`)
*   the latest common parent, root of the branch (`[filename].BASE.[version].txt`, short `base`)
*   the resulting, final merged file, with the file markers (`[filename]`, short `merge`)

With this setup you'll get a 5 way display, to compare `base` - `local` - `merge` - `remote` - `base` split up in 3 windows:

*   one showing the differences between `base` - `local` (just for you information)
*   one showing the differences between `remote` - `base` (just for you information)
*   one showing `local` - `merge` - `remote` to ACTUALLY DO the merge

(please note, if you don't want a 5 way merge with 3 windows, but only a 3 way merge in one window with `local` - `merge` - `remote`, just edit the script in point 2. should be obvious what to change..)

### Lets get started ###

1.  get the tool:  
    `$ sudo apt-get install meld` 

2.  create a starter script, name if `mergemeld` and save it somewhere the system finds it (eg. you local `bin` directory created for rambutan would be nice: `~/local/bin`)
    `#!/bin/sh` 
    `meld $2 $1 &` 
    `sleep 0.1` 
    `meld $1 $3 &` 
    `sleep 0.1` 
    `meld $2 $4 $3`
    
3.  make it executable: 
    `chmod +x mergemeld`
    
4.  set up the git config: (`gedit ~/.gitconfig`)
    
    [merge]
        tool = mymeld
    [mergetool "mymeld"]
        cmd = $HOME/local/bin/mergemeld $BASE $LOCAL $REMOTE $MERGED
        
5.  finished. the next time a merge fails, you can call the tool to resolve the conflicts in GUI using
    `git mergetool`