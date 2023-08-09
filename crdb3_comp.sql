
/* 
crdb3_comp.sql : install basic components before creating more pdbs

notes:
 - wasnt happy with the long commandlines, 
 - despite utlrp some invalids remain, seems due to pre- or beta- or dev-release  
*/ 

@accpws

-- Wanted shorter commands to Run CatCon.. Hence define rcc
DEFINE rcc="$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v "

prompt JServer

SET VERIFY OFF

connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool JServer.log append


--host &&rcc -b nothing1 -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/javavm/install/nothing1.sql;

--host &&rcc -b foobar1  -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/foobar1.sql;

--host &&rcc -b test_2   -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/test_2.sql;


host &&rcc -b initjvm    -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/javavm/install/initjvm.sql;

host &&rcc -b initxml    -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/initxml.sql;

host &&rcc -b xmlja      -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/xmlja.sql;

host &rcc -b catjava     -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catjava.sql;

spool off

prompt context

SET VERIFY OFF

-- keeping the connect, as each "script" originally did a fresh connection
connect "SYS"/"&&sysPassword" as SYSDBA

set echo on

spool context.log append

host &&rcc -b catctx   -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ctx/admin/catctx.sql 1Xbkfsdcdf1ggh_123 1SYSAUX 1TEMP 1LOCK;

host &&rcc -b dr0defin -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ctx/admin/defaults/dr0defin.sql 1\"AMERICAN\";

host &rcc  -b dbmsxdbt -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/dbmsxdbt.sql;

spool off

prompt cwmlite.sql

SET VERIFY OFF
set echo on

spool cwmlite.log append

connect "SYS"/"&&sysPassword" as SYSDBA

host &rcc   -b olap -c  'PDB$SEED CDB$ROOT'      -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/olap/admin/olap.sql 1SYSAUX 1TEMP;

spool off

prompt spatial.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool /spatial.log append

host &rcc -b mdinst -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/md/admin/mdinst.sql;

spool off


prompt CreateClustDBViews.sql


SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool CreateClustDBViews.log append

host &&rcc -b catclust  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catclust.sql;

host &rcc  -b catfinal  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catfinal.sql;

spool off

connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool postDBCreation.log append

prompt lockAccount.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA

set echo on

spool lockAccount.log append

alter session set "_oracle_script"=true;
alter pluggable database pdb$seed close;
alter pluggable database pdb$seed open;

BEGIN 
 FOR item IN ( SELECT USERNAME, AUTHENTICATION_TYPE FROM DBA_USERS WHERE ACCOUNT_STATUS IN ('OPEN', 'LOCKED', 'EXPIRED') AND USERNAME NOT IN ( 
'SYS','SYSTEM','SYSRAC','XS$NULL') ) 
 LOOP 
IF item.AUTHENTICATION_TYPE='PASSWORD' THEN
  dbms_output.put_line('Locking and Expiring: ' || item.USERNAME); 
  execute immediate 'alter user ' ||
 	 sys.dbms_assert.enquote_name(
 	 sys.dbms_assert.schema_name(
 	 item.USERNAME),false) || ' password expire account lock' ;
 ELSE 
  dbms_output.put_line('Locking: ' || item.USERNAME); 
  execute immediate 'alter user ' ||
 	 sys.dbms_assert.enquote_name(
 	 sys.dbms_assert.schema_name(
 	 item.USERNAME),false) || ' account lock' ;
 END IF;
 END LOOP;
END;
/

alter session set container=pdb$seed;

BEGIN 
 FOR item IN ( SELECT USERNAME, AUTHENTICATION_TYPE FROM DBA_USERS WHERE ACCOUNT_STATUS IN ('OPEN', 'LOCKED', 'EXPIRED') AND USERNAME NOT IN ( 
'SYS','SYSTEM','SYSRAC','XS$NULL') ) 
 LOOP 
IF item.AUTHENTICATION_TYPE='PASSWORD' THEN
  dbms_output.put_line('Locking and Expiring: ' || item.USERNAME); 
  execute immediate 'alter user ' ||
 	 sys.dbms_assert.enquote_name(
 	 sys.dbms_assert.schema_name(
 	 item.USERNAME),false) || ' password expire account lock' ;
 ELSE 
  dbms_output.put_line('Locking: ' || item.USERNAME); 
  execute immediate 'alter user ' ||
 	 sys.dbms_assert.enquote_name(
 	 sys.dbms_assert.schema_name(
 	 item.USERNAME),false) || ' account lock' ;
 END IF;
 END LOOP;
END;
/

alter session set container=cdb$root;

spool off
 

prompt postDBCreation.sql

SET VERIFY OFF

spool postDBCreation.log append

host $ORACLE_HOME/OPatch/datapatch -skip_upgrade_check -db free;

connect "SYS"/"&&sysPassword" as SYSDBA

set echo on

prompt I prefer to do my spfile manually, 
prompt and at the moment in dflt location
prompt I might  consider moving it out of OH later.
--  create spfile='/opt/oracle/dbs/spfilefree.ora' FROM pfile='/opt/oracle/admin/free/scripts/init.ora';

connect "SYS"/"&&sysPassword" as SYSDBA

host &rcc -b utlrp  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/utlrp.sql;

select comp_id, status from dba_registry;

shutdown immediate;

connect "SYS"/"&&sysPassword" as SYSDBA

startup ;

spool off

prompt Done crdb3_comp


