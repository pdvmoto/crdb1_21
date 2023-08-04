SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/context.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catctx -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  /opt/oracle/product/21c/dbhome_1/ctx/admin/catctx.sql 1Xbkfsdcdf1ggh_123 1SYSAUX 1TEMP 1LOCK;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b dr0defin -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  /opt/oracle/product/21c/dbhome_1/ctx/admin/defaults/dr0defin.sql 1\"AMERICAN\";
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b dbmsxdbt -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/rdbms/admin/dbmsxdbt.sql;
spool off
