
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

-- if needed, add  bigfile as line 3: -- SET DEFAULT BIGFILE TABLESPACE
-- added: char-set utf8, nchar automatically becomes AL16UTF16 (check!)

CREATE DATABASE FREE
EXTENT MANAGEMENT LOCAL
DEFAULT TABLESPACE users
DEFAULT TEMPORARY TABLESPACE temp
UNDO TABLESPACE undotbs1
  CHARACTER SET AL32UTF8
ENABLE PLUGGABLE DATABASE
   SEED
   SYSTEM DATAFILES SIZE 40M AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED
   SYSAUX DATAFILES SIZE 40M;

-- show some result
@chk_crdb1 

-- add a few checks..
select name, open_mode from v$database ;
show pdbs 

prompt .
prompt Create Database Done. Please Verify.
prompt .
promp Optional: use reszie_after1.sql to pre-resize datafiles
prompt . 

