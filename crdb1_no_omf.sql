
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
-- experiment with explicit placement, no OMF ? 

CREATE DATABASE FREE
EXTENT MANAGEMENT LOCAL
  DATAFILE '/opt/oracle/oradata/FREE/CDB/system01.dbf' size 100m autoextend on next 100m
  SYSAUX
  DATAFILE '/opt/oracle/oradata/FREE/CDB/sysaux01.dbf' size 100m autoextend on next 100m
DEFAULT TABLESPACE USERS
  DATAFILE  '/opt/oracle/oradata/FREE/CDB/users01.dbf'  size  10m autoextend on next 50m
DEFAULT TEMPORARY TABLESPACE TEMP
  TEMPFILE  '/opt/oracle/oradata/FREE/CDB/temp01.dbf'   size 100m autoextend on next 100m
UNDO TABLESPACE UNDOTBS1
  DATAFILE  '/opt/oracle/oradata/FREE/CDB/undo01.dbf'   size 100m autoextend on next 100m
  CHARACTER SET AL32UTF8
ENABLE PLUGGABLE DATABASE
  SEED
    FILE_NAME_CONVERT = ('/opt/oracle/oradata/FREE/CDB/',
                         '/opt/oracle/oradata/FREE/PDBSEED/')
    SYSTEM DATAFILES SIZE 105M AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED
    SYSAUX DATAFILES SIZE 105M ;


-- these create-pluggable should come later, in crdb4, but to test...

-- simple as possible...
-- if no CONVERT is specifie, and db_file_create is defined,
-- this will create very long file-paths..
CREATE PLUGGABLE DATABASE FREEPDB1
  ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword" ;

-- convert filenames, specify minimal.. no tablespace-names
-- this seems to only work even if db_file_dest is defined
-- this would by my Pref!
CREATE PLUGGABLE DATABASE
  FREEPDB2
    ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword"
    FILE_NAME_CONVERT = ('/opt/oracle/oradata/FREE/PDBSEED/',
                         '/opt/oracle/oradata/FREE/FREEPDB2/') ;

-- original stmnt, generates error if DB alrady exist...
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

prompt Create Database Done. Please Verify.

