
/* 
crdb3_comp.sql : install basic components before creating more pdbs

notes:
 - wasnt happy with the long commandlines, still not happy
 - after utlrp: 0 invalids. Good Sign.
 - why repeated connect? to verify un/pw ?, or need for fresh session??
 - option -a is undocumented (Martin Berger/x traced: probly GUI/windows related)
*/ 

-- get passwords
@accpws

-- Wanted shorter commands to Run CatCon.. Hence define rcc
DEFINE rcc="$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v "

prompt first JServer

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

host &&rcc -b initjvm  -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/javavm/install/initjvm.sql;
host &&rcc -b initxml  -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/initxml.sql;
host &&rcc -b xmlja    -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/xmlja.sql;
host &rcc  -b catjava  -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catjava.sql;

prompt next is context

-- keeping the connect, as each "script" originally did a fresh connection
connect "SYS"/"&&sysPassword" as SYSDBA

set echo on

host &&rcc -b catctx   -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ctx/admin/catctx.sql 1Xbkfsdcdf1ggh_123 1SYSAUX 1TEMP 1LOCK;
host &&rcc -b dr0defin -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ctx/admin/defaults/dr0defin.sql 1\"AMERICAN\";
host &rcc  -b dbmsxdbt -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/dbmsxdbt.sql;

prompt ordinst and interMedia: stubbs removed, product no longer avaiable.
prompt next is cwmlite.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

host &rcc   -b olap -c  'PDB$SEED CDB$ROOT'      -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/olap/admin/olap.sql 1SYSAUX 1TEMP;

prompt next is spatial.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

host &rcc -b mdinst -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/md/admin/mdinst.sql;

prompt next is CreateClustDBViews.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

host &&rcc -b catclust  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catclust.sql;
host &rcc  -b catfinal  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catfinal.sql;

connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

prompt next is lockAccount.sql

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

prompt next is postDBCreation.sql

SET VERIFY OFF

host $ORACLE_HOME/OPatch/datapatch -skip_upgrade_check -db free;

connect "SYS"/"&&sysPassword" as SYSDBA

prompt note on spfile: I prefer to do my spfile manually, 
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

prompt Done crdb3_comp. Please Verify: errors, invalids objs etc...

