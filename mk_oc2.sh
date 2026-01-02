#!/bin/sh
#
#
# mk_ooc2.sh : create a container running oracle (freepdb1), v2
#
# note: 
#   subdirs map_init and map_star 
#   may need "docker login" to pull images.
#   important: save command to logfile for later view/use
#
# later:
# - test mapping of oradata
#
# todo: include this trick to run startups:
#  - startdb only on 2nd start (not on init)
#  - volume must be known to docker (add to resources), hence using yb_data
#  - experiment with --mount type=bind
#
# docker run -d  --hostname o23t \
#  --name o23t -p1521:1521 \
#  -v /Users/pdvbv/yb_data/startdb:/container-entrypoint-startdb.d \
#  -e ORACLE_PASSWORD=oracle   \
#  gvenzl/oracle-free:23.9-full-faststart
# also can:
# -v /Users/pdvbv/yb_data/node2:/container-entrypoint-startdb.d \

# which one..
# IMAGE=gvenzl/oracle-free:slim
# IMAGE=gvenzl/oracle-free:full
  IMAGE=gvenzl/oracle-free:full

CONT=o26fa

LOGFILE=mk_oc2.log

# create+prepare map-volumes for binding..
mkdir ./map_initdb
mkdir ./map_startdb
mkdir ./map_diag

# explicitly distribute the (config) files to the mapped bind-volumes
#  the setenv.sh will put profile and env files in place
cp exrc_4_container     ./map_initdb/.exrc
cp bashrc_extra         ./map_initdb/
cp 1_setenv.sh          ./map_initdb/

# these SQL will set up scott and additional PDBs
cp 1_initdb.sql         ./map_initdb/
cp 2_initdb.sql         ./map_initdb/

# use this to set startup-stuff, for example history
cp 1_startdb.sql        ./map_startdb/

echo `date` $0 : working from `pwd`
echo `date` $0 : creating new container... >> $LOGFILE


# optional: separate net
# docker network rm ora_net
#  docker network create --subnet=172.22.0.0/16 --ip-range=172.22.0.0/24  ora_net
# echo .
# echo network ora_net created, next loop over nodes
# echo .
# sleep 2

# define all relevant pieces (no spaces!)
hname=$CONT
oraport=1521

# optinally: define volume or mapping.

# define the command
crenode=` \
echo docker run -d               \
--hostname $hname --name $hname  \
-e ORACLE_PASSWORD=oracle        \
-p${oraport}:1521                \
$IMAGE                           `

# if mount is needed:
# --mount type=bind,source=./map_initdb,target=/container-entrypoint-initdb.d \
# --mount type=bind,source=./map_startdb,target=/container-entrypoint-startdb.d \

# to map volume, add this line just above IMAGE..
#  -v /Users/pdvbv/oradata/$hname:/opt/oracle/oradata \

echo $hname ... creating container:
echo $crenode
echo $crenode >> $LOGFILE

# do it..
$crenode


# now add components.. : 
# git, jq, binsql, syssatat, procps, which, .bash_profile
# create scott..

echo $hname :  adding components.

cat <<EOF | docker exec -i -u root $hname sh
  microdnf install jq
  microdnf install procps
  microdnf install which
  microdnf install sysstat
  microdnf install vi
  microdnf install git
  cd /tmp
  git clone https://github.com/pdvmoto/uxutil
  cd uxutil
  chown root:root *
EOF

# some actions as oracle, also try create scott here..
cat <<EOF | docker exec -i $hname sh
  echo "alias ll='ls -la '"                         >> .bash_profile 
  echo "alias ltm='ls -lra '"                       >> .bash_profile 
  echo "alias dum='du -sm * | sort -ns '"           >> .bash_profile 
  echo "export SQLPATH=/opt/oracle/admin/binsql"    >> .bash_profile
  cd /opt/oracle/admin
  git clone https://github.com/pdvmoto/binsql
EOF

echo "."
echo Container $hname Created, check logfiles, and logon to verify
echo "."

