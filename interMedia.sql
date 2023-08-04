SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/interMedia.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b iminst -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/ord/im/admin/iminst.sql;
spool off
