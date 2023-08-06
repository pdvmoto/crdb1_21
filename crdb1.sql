
spool crdb1.log

-- pwds get "accepted" in separate file, file and pwd are reused.

@accpws

-- we need th pw file..
host $ORACLE_HOME/bin/orapwd file=$ORACLE_HOME/dbs/orapw$ORACLE_SID password=&&sysPassword force=y format=12

set echo on

connect / as sysdba 

-- there must be an init or spfile, but mine is minimal... 
startup nomount ;

-- minimal create stmnt 
-- use as much as possible from the ini/spfile

CREATE DATABASE FREE
EXTENT MANAGEMENT LOCAL
DEFAULT TABLESPACE users
DEFAULT TEMPORARY TABLESPACE temp
UNDO TABLESPACE undotbs1
ENABLE PLUGGABLE DATABASE
   SEED
   SYSTEM DATAFILES SIZE 125M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
   SYSAUX DATAFILES SIZE 100M;

select name, open_mode from v$database ;

show pdbs 

