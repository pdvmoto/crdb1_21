#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /opt/oracle
mkdir -p /opt/oracle/admin/free/adump
mkdir -p /opt/oracle/admin/free/dpdump
mkdir -p /opt/oracle/admin/free/pfile
mkdir -p /opt/oracle/admin/free/scripts
mkdir -p /opt/oracle/audit
mkdir -p /opt/oracle/dbs
mkdir -p /opt/oracle/oradata/FREE
mkdir -p /opt/oracle/oradata/FREE/freepdb1
mkdir -p /opt/oracle/oradata/FREE/pdbseed
umask ${OLD_UMASK}
PERL5LIB=$ORACLE_HOME/rdbms/admin:$PERL5LIB; export PERL5LIB
ORACLE_SID=free; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$ORACLE_HOME/perl/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: free:/opt/oracle/product/21c/dbhome_1:Y
/opt/oracle/product/21c/dbhome_1/bin/sqlplus /nolog @/opt/oracle/admin/free/scripts/free.sql
