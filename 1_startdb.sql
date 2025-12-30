
spool 1_startdb

@where

host date

prompt 'inidb done..'

host touch /tmp/start_done

alter session set container=freepdb1 ;

-- alter system set sql_history_enabled=TRUE scope=both;
-- alter system set "_sql_history_buffers"=10000 scope=both;

host touch /tmp/sqlhist_done

spool off

