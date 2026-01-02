# crdb1_21

contents: Files blogs (4-part so far) to manually create CDB+PDBs v23c

This repo contains 2 sets:
 1. the crdb1/2/3/4 to create an RDBMS from scripts
 2. the mk_cont.sh and files to configure a container, initdb, startdb, then some..

todo: 
 - move irrelevant files away or to a subdir
 - alternative: create new git-repository with minimal files

More:
 - separate software from data..
 - next: try a read-only OHOME, and place all (ALL ! ) database files 
   on an externa -v volume.
 - then re-mount that volum on Diff containers, one at a time.. 
   The Ultimate Portability ?
