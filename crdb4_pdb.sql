
-- create the first PDB, with minimal code + config..

@accpws

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/plugDatabase.log append

-- why these selects ? 

select d.name||'|'||t.name from v$datafile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;
select d.name||'|'||t.name from v$tempfile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;

-- let's do TWO plugs straight away.

CREATE PLUGGABLE DATABASE FREEPDB1 ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminsysPassword" ;

CREATE PLUGGABLE DATABASE FREEPDB2 ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminsysPassword" ;

-- ROLES=(CONNECT)  file_name_convert=('/opt/oracle/oradata/FREE/pdbseed',
-- '/opt/oracle/oradata/FREE/freepdb1')  STORAGE ( MAXSIZE UNLIMITED MAX_SHARED_TEMP_SIZE UNLIMITED);

select name from v$containers where upper(name) = 'FREEPDB1';

alter pluggable database FREEPDB1 open;
alter pluggable database FREEPDB2 open;

show pdbs

alter system register;

ALTER SESSION SET CONTAINER = FREEPDB1 ;

select * from global_name ; 

ALTER SESSION SET CONTAINER = FREEPDB2 ;

select * from global_name ; 
