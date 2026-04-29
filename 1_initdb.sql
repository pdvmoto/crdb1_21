
spool 1_initdb

host touch /tmp/initdb_start

alter session set container=freepdb1 ;

-- leftover from testing history
-- alter system set sql_history_enabled=true ;
-- alter system set "_sql_history_buffers"=10000 ; 

create user scott identified by tiger ;

grant connect, resource, dba to scott ; 

grant advisor to scott ;
grant oem_advisor to scott ; 

grant execute on dbms_lock  to scott ;
grant execute on dbms_session to scott ;
grant execute on dbms_workload_repository to scott ;

host touch /tmp/initdb_done

spool off
