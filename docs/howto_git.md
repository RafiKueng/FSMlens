Git Summary
===========

rafikueng
v1 2012-03-26 20:00


Comment
-------

Oke, finally, here the basic git steps summarsized:
(change [bla] with your own stuff: [myname] -> RafiKueng)

first, an overview:
http://osteele.com/images/2008/git-transport.png

and a handy cheatsheet
http://jan-krueger.net/wordpress/wp-content/uploads/2007/09/git-cheat-sheet-v2.zip
(from http://jan-krueger.net/development/git-cheat-sheet-extended-edition)


working with git, step by step
------------------------------

0.  get a complete copy:  
    `$ cd [basedir]` go to any directory 
    `$ git clone git@github.com:RafiKueng/FSMlens.git [dir]`
    this creates a copy of the files at github in `[basedir]/[dir]`


1. get the latest data from server  
    `$ git pull`
    note: this updates the master branch, if you want any other branch, use:  
    `$ git pull origin [branchname]`

    TODO: note to myself: some additional commands; look, which one makes a local branch tracked...  
    git pull = git fetch and git merge  
    `$ git checkout -b [localbranchname] [source]/[remotebranchname]`  
    `$ git checkout -b experimental origin/experimental`  
    `$ git checkout -t origin/experimental` //tracking  
    `$ git fetch [source] [remotebranchname]`  
    `$ git fetch origin experimental`  
    `$ git remote update`  
    `$ git pull --all`


2. if you're doing not minor changes, or want to try something out, make a branch LOCALLY:  
    `$ git branch [branchname]`  
    `$ git checkout [branchname]`

    or use to create a new branch and change to it in one step:  
    `$ git checkout -b [branchname]`

    notes:
    *   if you want to see what branches you have, use:  
        `$ git branch`  
    *   if you want to see all the branches on the server too, use  
        `$ git branch -a`
    *   to change to an existing branch, use  
        `$ git checkout [branchname]`  //files not commited will be deleted


3. (edit your files)


4. see what`s changed  
    `$ git status`


5. add new created files  
    `$ git add .`

    note: if you've got files that you want locally, but don't want them to be under version control (for example compiled files, large data files, etc..) create a file named ".gitignore" (note the leading dot) to your folder and add the files you don`t want in the repro to this file with a text editor. have a look to the .gitignore file already present in the root folder of the project.


6. add changes locally to your repro  
    `$ git commit -am "very short one line note what you did`  
    `[empty line]`  
    `some more detailed notes about your changes if necessary. but dont just write changed file xy. because users can see this anyways, write why you did it / what you did.`  
    `you can:`  
    `- even`  
    `- use`  
    `- bullets if you like"`

    note: you can type as long as you wish, and even press enter, as long as you dont close the `""`.


7. repeat 4-7 until finished working, commit often!!
    * don't never ever make backups like `file1.java.backup`
    * keep all your data in the repro folder and don't copy paste from other places...  
    thats why we use a version control system. use branches and commits instead!!
    


7. once finished with your changes, and everything compiles, runs correctly, put it back to the master branch. please keep the master branch clean, only finished / working / compiling stuff should be inside.  
    `$ git branch master` //switch to master branch  
    `$ git merge [branchname]` //apply the changes from `[branchname]` back to the master branch

    if your code is not yet compiling, but you want an backup on github, or want to show / share the code with others, skip this section, don`t merge back to master and push instead the working branch (see next sections)


8. try to upload your changes  
    `$ git push`  
    this uploads your master branch to github. if you want to backup another branch on github, use  
    `$ git push origin [branchname]`


9. if there were any changes made by others, this will fail.. so you first need to add those changes locally by  
    * `$ git pull`
    * resolve any conflicts (if exist)
    * `$ git push`



some additional notes
---------------------

###delete local branch:
* `$ git branch -d [branchname]` //fails if not merged into master
* `$ git branch -D [branchname]` //delete even if not merged, work is lost!!

###delete remote branch:
* `$ git push origin :[branchname]`

###add remote
* `$ git remote add origin git@github.com:RafiKueng/FSMlens.git`

###Set up git
* `$ git config --global user.name "Rafael Kueng"`
* `$ git config --global user.email rafi.kueng@gmx.ch`
