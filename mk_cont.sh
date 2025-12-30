
# mk_cont.sh: create a container with oracle database in it..
#
# note: -v mapping required dirs to be known by docker. Dont map if volumes not know..
#
# note: initdb and startdb contain various tricks.. if exit non-zero, container will FAIL
#       may needd to create subdirs and put files in them
#
# note: when mapping oradata, database will (can) persist, but versions upgrades ??
#
# 

# SRC_IMAGE=gvenzl/oracle-free:slim
# SRC_IMAGE=gvenzl/oracle-free:full-faststart
  SRC_IMAGE=gvenzl/oracle-free:full

CONT=o26fa

# create+prepare map-volumes
mkdir ./map_initdb
mkdir ./map_startdb
mkdir ./map_diag

cp exrc_4_container     ./map_initdb/.exrc
cp bash_profile_extra   ./map_initdb/bash_profile_extra
cp 1_setenv.sh          ./map_initdb/
cp 1_initdb.sql         ./map_initdb/
cp 2_initdb.sql         ./map_initdb/

cp 1_startdb.sql        ./map_startdb/

docker run -d  \
  --hostname $CONT \
  --name     $CONT -p1521:1521 \
  -v        ./map_startdb:/container-entrypoint-startdb.d \
  -v         ./map_initdb:/container-entrypoint-initdb.d  \
  -v           ./map_diag:/opt/oracle/diag  \
  -v /Users/pdvbv/oradata:/opt/oracle/oradata  \
  -e ORACLE_PASSWORD=oracle   \
  $SRC_IMAGE 

# also can:
# -v /Users/pdvbv/yb_data/node2:/container-entrypoint-startdb.d \
# -v /Users/pdvbv/yb_data/oradata:/opt/oracle/oradata \
# -v /Users/pdvbv/yb_data/oradata:/opt/oracle/oradata \

#  gvenzl/oracle-free:full-faststart
#  gvenzl/oracle-free:full


#
# further config..
#
docker exec -u root $CONT microdnf install sysstat
docker exec -u root $CONT microdnf install which
docker exec -u root $CONT microdnf install file
docker exec -u root $CONT microdnf install procps
docker exec -u root $CONT microdnf install git

echo "dont forget git-clone... " 
docker exec         $CONT git clone https://github.com/pdvmoto/binsql   /opt/oracle/admin/binsql
docker exec         $CONT git clone https://github.com/pdvmoto/crdb1_21 /opt/oracle/admin/crdb1_21
docker exec         $CONT rm                                            /opt/oracle/admin/crdb1_21/*.png

echo .
docker ps 
echo .

echo container created ... $CONT 

