set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
ACCEPT pdbAdminPassword CHAR PROMPT 'Enter new password for PDBADMIN: ' HIDE
host /opt/oracle/product/21c/dbhome_1/bin/orapwd file=/opt/oracle/dbs/orapwfree force=y format=12
@/opt/oracle/admin/free/scripts/CreateDB.sql
@/opt/oracle/admin/free/scripts/CreateDBFiles.sql
@/opt/oracle/admin/free/scripts/CreateDBCatalog.sql
@/opt/oracle/admin/free/scripts/JServer.sql
@/opt/oracle/admin/free/scripts/context.sql
@/opt/oracle/admin/free/scripts/ordinst.sql
@/opt/oracle/admin/free/scripts/interMedia.sql
@/opt/oracle/admin/free/scripts/cwmlite.sql
@/opt/oracle/admin/free/scripts/spatial.sql
@/opt/oracle/admin/free/scripts/CreateClustDBViews.sql
@/opt/oracle/admin/free/scripts/lockAccount.sql
@/opt/oracle/admin/free/scripts/postDBCreation.sql
@/opt/oracle/admin/free/scripts/PDBCreation.sql
@/opt/oracle/admin/free/scripts/plug_freepdb1.sql
@/opt/oracle/admin/free/scripts/postPDBCreation_freepdb1.sql
