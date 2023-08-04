SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/CreateDBCatalog.log append
alter session set "_oracle_script"=true;
alter pluggable database pdb$seed close;
alter pluggable database pdb$seed open;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catctl.pl  -u "SYS"/"&&sysPassword" -n 2 -icatpcat -c 'CDB$ROOT PDB$SEED' -a  -d /opt/oracle/product/21c/dbhome_1/rdbms/admin -l /opt/oracle/admin/free/scripts rdbms/admin/catpcat.sql;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b owminst  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/rdbms/admin/owminst.plb;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b pupbld -u SYSTEM/&&systemPassword  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/sqlplus/admin/pupbld.sql;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b pupdel -u SYS/&&sysPassword  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/sqlplus/admin/pupdel.sql;
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /opt/oracle/admin/free/scripts/sqlPlusHelp.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b hlpbld -u SYSTEM/&&systemPassword  -U "SYS"/"&&sysPassword" -a 1  /opt/oracle/product/21c/dbhome_1/sqlplus/admin/help/hlpbld.sql 1helpus.sql;
spool off
spool off
