# try generating scripts from dbca..
# results in /opt/oracle/cfgtoollogs/dbca/FREE/FREE.log"
# as of version 23.9: script are just recovery, not 'from scratch' 

dbca -silent \
  -generateScripts \
  -templateName FREE_Database.dbc \
  -gdbName FREE \
  -databaseConfigType SINGLE \
  -databaseType  OLTP	\
  -numberOfPDBs 1	\
  -pdbName ORCL		\
-sysPassword oracle	\
-systemPassword oracle	\

