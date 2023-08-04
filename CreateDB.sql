SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/CreateDB.log append
startup nomount pfile="/opt/oracle/admin/free/scripts/init.ora";
CREATE DATABASE "FREE"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 1024
DATAFILE '/opt/oracle/oradata/FREE/system01.dbf' SIZE 700M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '/opt/oracle/oradata/FREE/sysaux01.dbf' SIZE 550M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/opt/oracle/oradata/FREE/temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE  '/opt/oracle/oradata/FREE/undotbs01.dbf' SIZE 200M REUSE AUTOEXTEND ON NEXT  5120K MAXSIZE UNLIMITED
CHARACTER SET AL32UTF8
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/opt/oracle/oradata/FREE/redo01.log') SIZE 200M,
GROUP 2 ('/opt/oracle/oradata/FREE/redo02.log') SIZE 200M,
GROUP 3 ('/opt/oracle/oradata/FREE/redo03.log') SIZE 200M
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword"
enable pluggable database
seed file_name_convert=('/opt/oracle/oradata/FREE/system01.dbf','/opt/oracle/oradata/FREE/pdbseed/system01.dbf','/opt/oracle/oradata/FREE/sysaux01.dbf','/opt/oracle/oradata/FREE/pdbseed/sysaux01.dbf','/opt/oracle/oradata/FREE/temp01.dbf','/opt/oracle/oradata/FREE/pdbseed/temp01.dbf','/opt/oracle/oradata/FREE/undotbs01.dbf','/opt/oracle/oradata/FREE/pdbseed/undotbs01.dbf') LOCAL UNDO ON;
spool off
