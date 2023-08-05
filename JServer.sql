SET VERIFY OFF

connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /opt/oracle/admin/free/scripts/JServer.log append

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b initjvm -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/javavm/install/initjvm.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b initxml -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/initxml.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b xmlja -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/xdk/admin/xmlja.sql;

host $ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -l /opt/oracle/admin/free/scripts -v  -b catjava -c  'PDB$SEED CDB$ROOT'   -U "SYS"/"&&sysPassword" $ORACLE_HOME/rdbms/admin/catjava.sql;

connect "SYS"/"&&sysPassword" as SYSDBA
spool off
