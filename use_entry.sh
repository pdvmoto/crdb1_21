#!/bin/bash

nohup /opt/oracle/entry2.sh >> /tmp/entry2.out 2>&1 &

tail -f /dev/null

# copy the above into container-entry-points
# you need to 
# 1. copy entrypoint into entry2.sh, 
# 2. moodify the top of entrypoint to call entry2 and then start tail-forever
# 3. comment out two lines in entry2.sh, to prevent.. 

