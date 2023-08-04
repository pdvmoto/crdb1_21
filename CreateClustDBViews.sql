SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/CreateClustDBViews.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catclust  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/rdbms/admin/catclust.sql;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catfinal  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/rdbms/admin/catfinal.sql;
spool off
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/postDBCreation.log append
