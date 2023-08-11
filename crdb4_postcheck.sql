
/* 
  crdb4_tsjeck.sql : set user-ts and runs selects
  arg1 : PDBNAME to check, e.g. FREEPDB1 or ORCLPDB2
   
notes: 
  - adapted from postPDBCreate_freepdb1.sql, as genrated by dbca-v21c.

*/

-- get pwds
@accpws

-- pick arg from cmdline.
define targetPDB=&1;

prompt showing arg1-pdb &1 

-- get the pwds, we need m
@accpws


SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA

-- info selects.. remove later
select '"&&1'          as arg1 from dual ; 
select '&&targetPDB'   as pdb  from dual ; 

spool crdb4_postchecks.log append

alter session set container="&&targetPDB";

set echo on

CREATE SMALLFILE TABLESPACE USERS LOGGING  
DATAFILE  '/opt/oracle/oradata/FREE/freepdb1/users01.dbf' 
SIZE 25M REUSE AUTOEXTEND ON NEXT  20M MAXSIZE 1G   ;

ALTER DATABASE DEFAULT TABLESPACE USERS;

-- I prefer to use OH, and why is there a semicolon?
host $ORACLE_HOME/OPatch/datapatch -skip_upgrade_check -db $ORACLE_SID -pdbs &&targetPDB ;


connect "SYS"/"&&sysPassword" as SYSDBA

select property_value 
from database_properties 
where property_name='LOCAL_UNDO_ENABLED';

connect "SYS"/"&&sysPassword" as SYSDBA

alter session set container="&&targetPDB";

set echo on

connect "SYS"/"&&sysPassword" as SYSDBA

alter session set container="&&targetPDB";

set echo on

select TABLESPACE_NAME 
from cdb_tablespaces a,dba_pdbs b 
where a.con_id=b.con_id and UPPER(b.pdb_name)=UPPER('&&targetPDB');

connect "SYS"/"&&sysPassword" as SYSDBA

alter session set container="&&targetPDB";

set echo on

Select count(*)  nr_valid_DV
from dba_registry 
where comp_id = 'DV' 
and status='VALID';

-- go back to root.. why..
alter session set container=CDB$ROOT;

exit;
