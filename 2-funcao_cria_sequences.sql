-- FUNCAO PARA CRIAR SEQUENCES
create or replace function cria_sequence(tablename varchar, colname varchar, seq_name varchar) 
 returns int 
 language 'plpgsql'
 as 
 $$
 declare 
  maxno integer;
    
 begin 
  execute 'select  (CASE WHEN max('||colname|| ') IS NULL THEN 1 ELSE max('||colname|| ')+1 END) from ' || tablename  into  maxno ;   
  raise info  ' the val : % ', maxno || '-' || tablename;
  execute 'create sequence '|| seq_name ||' increment by 1 start with  ' || maxno; 
 return maxno;
 end;
 $$