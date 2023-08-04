SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/JServer.log append
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b initjvm -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/javavm/install/initjvm.sql;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b initxml -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/xdk/admin/initxml.sql;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b xmlja -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/xdk/admin/xmlja.sql;
host /opt/oracle/product/21c/dbhome_1/perl/bin/perl /opt/oracle/product/21c/dbhome_1/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catjava -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" /opt/oracle/product/21c/dbhome_1/rdbms/admin/catjava.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
spool off
