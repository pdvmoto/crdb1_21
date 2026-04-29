
-- use this to resize datafiles for CDB, 
-- prevent online-resizes in small increments

set feedb off
set heading off
set linesize 128

spool do_resize

select 'alter database datafile ''' || name || ''' resize 1000M ; '
from v$datafile
where name like '%system%'
and con_id = 1
;

select 'alter database datafile ''' || name || ''' resize 500M ; '
from v$datafile
where name like '%undo%'
and con_id = 1
;

select 'alter database datafile ''' || name || ''' resize 400M ; '
from v$datafile
where name like '%sysaux%'
and con_id = 1

;
spool off

@do_resize.lst

-- exit and re-connect to reset env.
exit


