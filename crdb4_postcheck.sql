
/* ---------------  

  crdb4_postcheck.sql <pdb_name>: set user-ts, do OPatch and run some selects

    arg1 : PDBNAME to check, e.g. FREEPDB1 or ORCLPDB2
   
notes: 
  - adapted from postPDBCreate_freepdb1.sql, as genrated by dbca-v21c.

   -----------------
*/

-- pick arg from cmdline.
define targetPDB=&1;

-- get the pwds, we need m
@accpws

-- stmnt and their sequence-order copied from generated postPDBCreate

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA

spool crdb4_postchecks.log append

alter session set container="&&targetPDB";

prompt Adding + setting dflt tablespace USERS, If needed...

set echo on

CREATE SMALLFILE TABLESPACE USERS LOGGING  
DATAFILE  '/opt/oracle/oradata/FREE/freepdb1/users01.dbf' 
SIZE 25M REUSE AUTOEXTEND ON NEXT  20M MAXSIZE 1G   ;

ALTER DATABASE DEFAULT TABLESPACE USERS;

-- next, the call to OPatch, added OH and SID

host $ORACLE_HOME/OPatch/datapatch -skip_upgrade_check -db $ORACLE_SID -pdbs &&targetPDB 

-- queries, copied straight from genereated v21c original. 
-- not sure if essential

connect "SYS"/"&&sysPassword" as SYSDBA

-- expect TRUE
select property_value 
from database_properties 
where property_name='LOCAL_UNDO_ENABLED';

connect "SYS"/"&&sysPassword" as SYSDBA

alter session set container="&&targetPDB";

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

-- go back to root.. why?, does exit straight after.. 
alter session set container=CDB$ROOT;

exit;

