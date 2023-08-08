
spool crdb1.log

-- pwds get "accepted" in separate file, file and pwd are reused.

@accpws

-- we need the pw file, in the dflt location.
host $ORACLE_HOME/bin/orapwd file=$ORACLE_HOME/dbs/orapw$ORACLE_SID password=&&sysPassword force=y format=12

-- we need at least some directory to place the data.
host mkdir -p /opt/oracle/oradata/FREE

-- learned the hard way: Ensure Correct init-file.
host cp initFREE.ora $ORACLE_HOME/dbs/init$ORACLE_SID.ora

set echo on

connect / as sysdba 

-- there must be an init or spfile, but mine is minimal... 
startup nomount ;

-- minimal create stmnt 

CREATE DATABASE FREE
EXTENT MANAGEMENT LOCAL
DEFAULT TABLESPACE users
DEFAULT TEMPORARY TABLESPACE temp
UNDO TABLESPACE undotbs1
ENABLE PLUGGABLE DATABASE
   SEED
   SYSTEM DATAFILES SIZE 125M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
   SYSAUX DATAFILES SIZE 100M;

-- add a few checks..
select name, open_mode from v$database ;
show pdbs 

prompt Create Database Done. Please Verify.

