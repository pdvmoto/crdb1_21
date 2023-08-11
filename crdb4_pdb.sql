
/* -------------------------
 crdb4_pdb.sql: create the first PDB(s), with minimal code + config..

notes:
 - in future: define the pdb-name(s) once or pass as args. 
  --------------------------- 
*/

-- get the passwords 
@accpws

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool crdb4_pdb.log append

-- let's do multiple plugs straight away.
-- future: create 42 plugs in a pl/sql loop? would that work?

CREATE PLUGGABLE DATABASE FREEPDB1 ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword" ;
CREATE PLUGGABLE DATABASE FREEPDB2 ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword" ;
CREATE PLUGGABLE DATABASE ORCL     ADMIN USER PDBADMIN IDENTIFIED BY "&&pdbAdminPassword" ;

-- should only see 2 of the 3 new ones...
select name from v$containers where upper(name) like 'FREEPDB%';

alter pluggable database FREEPDB1 open;
alter pluggable database FREEPDB2 open;
alter pluggable database ORCL     open;

show pdbs                

alter system register;   

prompt ---- End of crdb4_pdbs. Please check, properties, files, listener etc... ----- 
spool off
