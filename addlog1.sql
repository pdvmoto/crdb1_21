
-- alter logfile add member 'C:\ORACLE\PRODUCT\10.2.0\ORADATA\DB10\REDO01a.LOG' to group 1;

/*** 
-- keep this for demo of 16M files, same size as PG
alter database add logfile '/opt/oracle/oradata/ORCLCDB/redo01_16m.log' size 16M ; 
alter database add logfile '/opt/oracle/oradata/ORCLCDB/redo01_16m.log' size 16M ; 
alter database add logfile '/opt/oracle/oradata/ORCLCDB/redo02_16m.log' size 16M ; 
alter database add logfile '/opt/oracle/oradata/ORCLCDB/redo03_16m.log' size 16M ; 
***/

set echo on

alter database add logfile size 300M ; 
alter database add logfile size 300M ; 
alter database add logfile size 300M ; 

alter database drop logfile group 1 ;

set echo off

