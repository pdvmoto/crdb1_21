
column name     format A20
column con_id   format 999
column mb       format 9999

set echo on

select con_id, name, open_mode from v$pdbs ;

select con_id, file#, ts#, bytes/(1024*1024) mb
from v$datafile order by con_id, ts#; 

set echo off
prompt .
prompt But wait until you see the file names...
prompt .
set echo on

select name filename 
from v$datafile order by con_id, ts# ;

