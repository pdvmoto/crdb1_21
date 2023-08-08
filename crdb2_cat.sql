-- in case we need m

echo Pre-Size the REDO and Datafiles if you can.. slightly faster..

@accpws

set echo on

SET VERIFY OFF

connect "SYS"/"&&sysPassword" as SYSDBA

set echo on

spool crdb2_cat.log append

alter session set "_oracle_script"=true;

alter pluggable database pdb$seed close;
alter pluggable database pdb$seed open;

-- why is oracle-home missing for catpcat?
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catctl.pl  -u "SYS"/"&&sysPassword" -n 2 -icatpcat -c 'CDB$ROOT PDB$SEED' -a  -d $ORACLE_HOME/rdbms/admin -l /tmp rdbms/admin/catpcat.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v  -b owminst  -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/owminst.plb;

-- make sure pwd is correct
alter user system identified by "&&systemPassword"  ;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v  -b pupbld -u SYSTEM/&&systemPassword  -U "SYS"/"&&sysPassword" $ORACLE_HOME/sqlplus/admin/pupbld.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v  -b pupdel -u SYS/&&sysPassword  -U "SYS"/"&&sysPassword" $ORACLE_HOME/sqlplus/admin/pupdel.sql;

-- again, make sure pwd is correct
alter user system identified by "&&systemPassword"  ;

connect "SYSTEM"/"&&systemPassword"

set echo on

spool /opt/oracle/admin/free/scripts/sqlPlusHelp.log append
host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /tmp -v  -b hlpbld -u SYSTEM/&&systemPassword  -U "SYS"/"&&sysPassword" -a 1  $ORACLE_HOME/sqlplus/admin/help/hlpbld.sql 1helpus.sql;
spool off
