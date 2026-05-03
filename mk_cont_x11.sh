
# mk_cont_x1.sh: create and run a container from oracle image, and get X11 installed
#
# todo:
# - consider X11, test, keep script/notes 
# - define the program used for yum / dnf / microdnf (gvenzl)
#   gvenzl: microdnf
#   enterprise: yum or dnf
#

# define 1) where to get image, 2) a "hostname" and 3) how to run yum or mircodnf

SRC_IMAGE=container-registry.oracle.com/database/enterprise
CONT=o26x11
YUM=yum 

docker run -d       \
  --hostname $CONT  \
  --name     $CONT  \
  -p1525:1521       \
  $SRC_IMAGE

echo .
echo .
docker ps 
echo .
echo .
read -t 15 -p "container running... chck" abc

# exit   # (when dubugging)

#
# to run yum or dnf we need to zip ociregion (we back it up just in case)
#
docker exec -u root $CONT bash -c '        mv /etc/yum/vars/ociregion  /etc/yum/vars/bck_ociregion ' 
docker exec -u root $CONT bash -c ' echo "" > /etc/yum/vars/ociregion ' 

# now get X11, google told me we need two things..
# and note that the (first) yum-command(s) can be a bit slow.

docker exec -u root $CONT $YUM config-manager --enable ol8_codeready_builder
docker exec -u root $CONT $YUM install xorg-x11-apps

# will know if ...
docker exec $CONT xeyes -display host.docker.internal:0 -outline violet & 

echo .
read -t 10 -p "Did X11 install OK, violet?" abc
 
#
# further config, some personal preferences ..
#
docker exec -u root $CONT $YUM install sysstat
docker exec -u root $CONT $YUM install which
docker exec -u root $CONT $YUM install file
docker exec -u root $CONT $YUM install procps
docker exec -u root $CONT $YUM install git

# rlwrap needed epel...
docker exec -u root $CONT $YUM install oracle-epel-release-el8
docker exec -u root $CONT $YUM install rlwrap

# when all done: green eyes..
docker exec  $CONT  xeyes -display host.docker.internal:0 -outline green & 

echo .
docker ps 
echo .

echo container created ... $CONT 

