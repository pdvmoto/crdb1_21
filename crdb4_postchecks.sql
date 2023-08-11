SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
alter session set container="freepdb1";
set echo on
spool /opt/oracle/admin/free/scripts/postPDBCreation.log append
CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/FREE/freepdb1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO;
ALTER DATABASE DEFAULT TABLESPACE "USERS";
host /opt/oracle/product/21c/dbhome_1/OPatch/datapatch -skip_upgrade_check -db free -pdbs freepdb1;
connect "SYS"/"&&sysPassword" as SYSDBA
select property_value from database_properties where property_name='LOCAL_UNDO_ENABLED';
connect "SYS"/"&&sysPassword" as SYSDBA
alter session set container="freepdb1";
set echo on
spool /opt/oracle/admin/free/scripts/postPDBCreation.log append
connect "SYS"/"&&sysPassword" as SYSDBA
alter session set container="freepdb1";
set echo on
spool /opt/oracle/admin/free/scripts/postPDBCreation.log append
select TABLESPACE_NAME from cdb_tablespaces a,dba_pdbs b where a.con_id=b.con_id and UPPER(b.pdb_name)=UPPER('freepdb1');
connect "SYS"/"&&sysPassword" as SYSDBA
alter session set container="freepdb1";
set echo on
spool /opt/oracle/admin/free/scripts/postPDBCreation.log append
Select count(*) from dba_registry where comp_id = 'DV' and status='VALID';
alter session set container=CDB$ROOT;
exit;
