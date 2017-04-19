CREATE OR REPLACE PROCEDURE csv_exp( p_tabel VARCHAR, p_director VARCHAR, p_fisier VARCHAR ) IS 
c1 SYS_REFCURSOR;
curs NUMBER;
sel varchar(1000) ; 
colNr number ;
desctab DBMS_SQL.desc_tab;
comma varchar2(1) ;
insert_col varchar2(10000);
insert_val varchar2(10000);
output_file utl_file.file_type;
v_col varchar(4000);
namevar VARCHAR2(4000);
fileHandler  utl_file.FILE_TYPE;
l_status      INTEGER;
BEGIN
  fileHandler :=UTL_FILE.FOPEN(p_director,p_fisier,'W'); 
  open c1 for 'select * from ' || p_tabel;
  curid := DBMS_SQL.to_cursor_number(c1);
  DBMS_SQL.describe_columns(curs, colNr, desctab);
  comma:='';
  for indx in 1 .. colNr loop
    insert_col:=insert_col||comma||desctab(indx).col_name;
    comma:=',';
  end loop;
  UTL_FILE.PUT_LINE(fileHandler,insert_col);
    l_status                                := dbms_sql.execute(curs);

  
  WHILE DBMS_SQL.fetch_rows (curs) > 0 LOOP
    insert_val:='';
    comma:='';
    FOR indx IN 1 .. colNr LOOP
      DBMS_SQL.column_value(curs,indx, namevar);
      insert_val := insert_val||comma||namevar;
      comma:='';
    end loop;
    UTL_FILE.PUT_LINE(fileHandler,insert_val);
  end loop;
  DBMS_SQL.close_cursor (curs);
  UTL_FILE.FCLOSE(fileHandler);
  EXCEPTION
  WHEN utl_file.invalid_path THEN
     raise_application_error(-20000, 'ERROR: Invalid PATH FOR file.');
END;
/

begin
  csv_exp('informatii','INFO','informatii.txt');
end;

/*
begin
  execute immediate 'create or replace directory INFO as ''C:\Users\Georgiana\Desktop\an II sem II\sgbd\PROIECT\csv''';
end;
GRANT READ, WRITE ON DIRECTORY INFO TO PUBLIC; 
DROP DIRECTORY CSVFILES;
GRANT execute on DBMS_SQL to STUDENT; 

*/


