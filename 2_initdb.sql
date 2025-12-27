
-- some attempts to create a pluggable..

host touch /tmp/pdb_start.log

CREATE PLUGGABLE DATABASE ORCL
  ADMIN USER pdbadmin IDENTIFIED BY oracle
  file_name_convert=('/opt/oracle/oradata/FREE/pdbseed', '/opt/oracle/oradata/FREE/orcl')
  STORAGE ( MAXSIZE UNLIMITED MAX_SHARED_TEMP_SIZE UNLIMITED);

CREATE PLUGGABLE DATABASE ORCL     ADMIN USER PDBADMIN IDENTIFIED BY oracle ;

alter pluggable database ORCL     open;

alter pluggable database ORCL     save state ;

host touch /tmp/pdb_done.log

