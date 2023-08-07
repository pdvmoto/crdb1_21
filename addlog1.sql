
set echo on

alter database add logfile size 300M ; 
alter database add logfile size 300M ; 
alter database add logfile size 300M ; 

alter system switch logfile ;
alter system checkpoint ; 
alter system switch logfile ;
alter system checkpoint ; 

alter database drop logfile group 1 ;
alter database drop logfile group 2 ;

set echo off

