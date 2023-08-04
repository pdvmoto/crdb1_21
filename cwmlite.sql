SET VERIFY OFF
set echo on
spool /opt/oracle/admin/free/scripts/cwmlite.log append
connect "SYS"/"&&sysPassword" as SYSDBA
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b olap -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" -a 1  /opt/oracle/product/21c/dbhome_1/olap/admin/olap.sql 1SYSAUX 1TEMP;
spool off
