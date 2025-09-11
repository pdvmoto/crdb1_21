# try generating scripts from dbca..
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

