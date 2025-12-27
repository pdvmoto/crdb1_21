#!/usr/bin/bash

SEMFILE=/tmp/$0.semaphore

touch $SEMFILE

# extra commands on initiating..

#
# bash_profile, extra cmds 
# if not found, add call to /container-entrypoint-initdb.d/bash_profile_extra
#

cat /container-entrypoint-initdb.d/bash_profile_extra >> ~/.bashrc

# put down .exrc

cp /container-entrypoint-initdb.d/.exrc ~/.exrc

echo `date +%Y-%M-%DT%H:%M:%S` setenv_done  >> $SEMFILE

# clone scripts, this had to wait for git-install, is now included in mk_cont.sh
# git clone https://github.com/pdvmoto/binsql

exit 0
