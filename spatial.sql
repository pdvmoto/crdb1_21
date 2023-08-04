SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/spatial.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b mdinst -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/md/admin/mdinst.sql;
spool off
