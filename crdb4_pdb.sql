
-- create the first PDB(s), with minimal code + config..

@accpws

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool crdb4_pdb.log append

-- why these selects ? 

select d.name||'|'||t.name from v$datafile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;
select d.name||'|'||t.name from v$tempfile d,V$TABLESPACE t where d.con_id=2 and d.ts#=t.ts# and d.con_id=t.con_id;

-- let's do TWO plugs straight away.
-- future: create 42 in a pl/sql loop? would that work?

CREATE PLUGGABLE DATABASE FREEPDB1 ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword" ;

CREATE PLUGGABLE DATABASE FREEPDB2 ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword" ;

select name from v$containers where upper(name) like 'FREEPDB%';

alter pluggable database FREEPDB1 open;
alter pluggable database FREEPDB2 open;

show pdbs

alter system register;

ALTER SESSION SET CONTAINER = FREEPDB1 ;

select * from global_name ; 

ALTER SESSION SET CONTAINER = FREEPDB2 ;

select * from global_name ; 

prompt ---- End of crdb4_pdbs. Please Verify. ----- 

spool off

