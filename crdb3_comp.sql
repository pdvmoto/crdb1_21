
/* 
crdb3_comp.sql : install basic components before creating more pdbs

notes:
 - not happy with the long commandlines, 
   try find simpler solution, use $VARS or call script?
 - despite utlrp some invalids remain, seems due to pre- or beta- or dev-release  

*/ 

@accpws


-- need shorter commands to Run CatCon..hence define rcc
DEFINE rcc="$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v "


prompt JServer

SET VERIFY OFF

connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/JServer.log append

-- consider script to run catcon.pl.. or ..
-- host $OPERL $OCATCON -n 1 -l $OLOG -v -b initjvm -c 'PDB$SEED CDB$ROOT'  


host &&rcc -b nothing1 -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/javavm/install/nothing1.sql;

host &&rcc -b foobar1  -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/foobar1.sql;

host &&rcc -b test_2   -c 'PDB$SEED CDB$ROOT' -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/test_2.sql;



host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b initjvm -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/javavm/install/initjvm.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b initxml -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/initxml.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b xmlja -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/xmlja.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catjava -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catjava.sql;

connect "SYS"/"&&sysPassword" as SYSDBA
spool off

prompt context

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

spool /opt/oracle/admin/free/scripts/context.log append

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catctx -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ctx/admin/catctx.sql 1Xbkfsdcdf1ggh_123 1SYSAUX 1TEMP 1LOCK;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b dr0defin -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ctx/admin/defaults/dr0defin.sql 1\"AMERICAN\";

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b dbmsxdbt -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/dbmsxdbt.sql;

spool off

prompt ordinst.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/ordinst.log append
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b ordinst  -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/ord/admin/ordinst.sql 1SYSAUX 1SYSAUX;
spool off

prompt interMedia.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/interMedia.log append
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b iminst -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/ord/im/admin/iminst.sql;
spool off

prompt cwmlite.sql

SET VERIFY OFF
set echo on
spool /opt/oracle/admin/free/scripts/cwmlite.log append
connect "SYS"/"&&sysPassword" as SYSDBA
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b olap -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/olap/admin/olap.sql 1SYSAUX 1TEMP;
spool off

prompt spatial.sql

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/spatial.log append
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b mdinst -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/md/admin/mdinst.sql;
spool off

prompt CreateClustDBViews.sql


SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/CreateClustDBViews.log append
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catclust  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catclust.sql;
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catfinal  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catfinal.sql;
spool off
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/postDBCreation.log append

prompt lockAccount.sql


SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/lockAccount.log append
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
spool /opt/oracle/admin/free/scripts/postDBCreation.log append
host $ORACLE_HOME/OPatch/datapatch -skip_upgrade_check -db free;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on

prompt I prefer to do my spfile manually, 
prompt and at the moment in dflt location
prompt I might  consider moving it out of OH later.
--  create spfile='/opt/oracle/dbs/spfilefree.ora' FROM pfile='/opt/oracle/admin/free/scripts/init.ora';

connect "SYS"/"&&sysPassword" as SYSDBA
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b utlrp  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/utlrp.sql;
select comp_id, status from dba_registry;
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
spool off

prompt Done crdb3_comp


