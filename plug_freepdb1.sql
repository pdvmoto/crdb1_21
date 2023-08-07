SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/plugDatabase.log append
spool /opt/oracle/admin/free/scripts/plugDatabase.log append

host mkdir -p /opt/oracle/oradata/FREE/freepdb1;

select d.name||'|'||t.name from v$datafile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;
select d.name||'|'||t.name from v$tempfile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;

CREATE PLUGGABLE DATABASE "freepdb1" ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbadminPassword" ROLES=(CONNECT)  file_name_convert=('/opt/oracle/oradata/FREE/pdbseed',
'/opt/oracle/oradata/FREE/freepdb1')  
STORAGE ( MAXSIZE UNLIMITED MAX_SHARED_TEMP_SIZE UNLIMITED);

select name from v$containers where upper(name) = 'FREEPDB1';
alter pluggable database "freepdb1" open;
alter system register;
ALTER SESSION SET CONTAINER = "freepdb1";
