SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/ordinst.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b ordinst  -U "SYS"/"&&sysPassword" -a 1  /opt/oracle/product/21c/dbhome_1/ord/admin/ordinst.sql 1SYSAUX 1SYSAUX;
spool off
