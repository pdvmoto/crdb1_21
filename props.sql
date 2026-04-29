
set linesize 200
column property_name format A30
column property_value format A50
column description format A50

select * from database_properties
order by 1, 2, 3 ; 
