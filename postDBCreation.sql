SET VERIFY OFF
spool /opt/oracle/admin/free/scripts/postDBCreation.log append
host /opt/oracle/product/21c/dbhome_1/OPatch/datapatch -skip_upgrade_check -db free;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/opt/oracle/dbs/spfilefree.ora' FROM pfile='/opt/oracle/admin/free/scripts/init.ora';
connect "SYS"/"&&sysPassword" as SYSDBA
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b utlrp  -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/rdbms/admin/utlrp.sql;
select comp_id, status from dba_registry;
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
spool off
