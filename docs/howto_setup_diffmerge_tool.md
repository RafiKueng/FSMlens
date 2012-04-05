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
to be able to see differences in two versions of a file using `$ git diff`
    
1.  get the tool:  
    `$ sudo apt-get install meld`
    
2.  create a starter script, name if `diffmeld` and save it somewhere the system finds it (eg. you local bin directory created for rambutan would be nice: `~/local/bin`)
       
        #!/bin/bash
        # diff is called by git with 7 parameters:
        # path old-file old-hex old-mode new-file new-hex new-mode
        meld $2 $5
        
3.  make it executable:  
    `$ chmod +x diffmeld`
    
4.  set up the diff tool in git:  
    `$ git config --global diff.external diffmeld`  
    or change the config file directly:  
    `$ gedit ~/.gitconfig`
    
        ...
        [diff]
            external = $HOME/local/bin/diffmeld
        ...

5. use it with  
    `git diff`


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

(please note, if you don't want a 5 way merge with 3 windows, but only a 3 way merge in one window with `local` - `merge` - `remote`, just run `git config --global merge.tool meld`)

### Lets get started ###

1.  get the tool:  
    `$ sudo apt-get install meld` 

2.  create a starter script, name if `mergemeld` and save it somewhere the system finds it (eg. you local `bin` directory created for rambutan would be nice: `~/local/bin`)  
    `$ gedit merge_meld_5w`
        
        #!/bin/bash
        meld $1 $2 &
        sleep 0.1
        meld $3 $1 &
        sleep 0.1
        meld $2 $4 $3
    
3.  make it executable:  
    `$ chmod +x merge_meld_5w`
    
4.  set up the git config: 
    `$ gedit ~/.gitconfig`
        
        ...
        [merge]
            tool = meld5w
        [mergetool "meld5w"]
            cmd = $HOME/local/bin/merge_meld_5w $BASE $LOCAL $REMOTE $MERGED
            keepBackup = false
            trustExitCode = false
        ...
        
5.  finished. the next time a merge fails, you can call the tool to resolve the conflicts in GUI using 
    `$ git mergetool`
    
### other configurations / ideas, but UNTESTED###
note you can imho only have ONE tool in your config...

*   3 way merge with parent in the middle
    `$ gedit ~/.gitconfig`
        
        ...
        [merge]
            tool = meld3wP
        [mergetool "meld3wP"]
            cmd = meld $LOCAL $BASE $REMOTE -o $MERGED
            keepBackup = false
        ...

*   regular 5way merge
        
        [mergetool "meld5w"]
            cmd = $HOME/local/bin/merge_meld_5w $BASE $LOCAL $REMOTE $MERGED
            keepBackup = false
            trustExitCode = true

*   regular 3way merge, with base instead of merged in the middle
        
        [mergetool "meld3wB"]
            cmd = meld $LOCAL $BASE $REMOTE -o $MERGED
            keepBackup = false
            trustExitCode = true
            
*   the complicated way of just using meld...
        
        [mergetool "meld3w"]
            cmd = meld $LOCAL $MERGED $REMOTE -o $MERGED
            keepBackup = false
            trustExitCode = true
            
*   use a 5 way merge, but in one window, using tabs
        
        [mergetool "meld5wTab"]
            cmd = meld --diff $LOCAL $BASE --diff $LOCAL $MERGED $REMOTE -o $MERGED--diff $BASE $REMOTE
            keepBackup = false
            trustExitCode = true
            
*   use two  3 way merge windows, one with base, the other with merge in the middle, so you can choose
        
        [mergetool "meld2x3"]
            cmd = $HOME/local/bin/merge_meld_5w $BASE $LOCAL $REMOTE $MERGED
            keepBackup = false
            trustExitCode = true



        #!/bin/bash
        #not quite finished.. get exitcode of both and return OR'd to return correct exitcode to git
        meld $2 $1 $3 &
        sleep 0.1
        meld $2 $4 $3