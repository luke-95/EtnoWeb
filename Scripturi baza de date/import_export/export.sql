CREATE OR REPLACE PROCEDURE csv_exp( p_tabel VARCHAR, p_director VARCHAR, p_fisier VARCHAR ) IS 
 sep varchar2(1);
 v_folder utl_file.FILE_TYPE;
 c2 SYS_REFCURSOR;
 curid NUMBER;
 colcnt NUMBER;
 desctab DBMS_SQL.desc_tab;
 numvar NUMBER;
 namevar VARCHAR2(4000);
 datevar DATE;
 insert_col varchar2(10000);
 insert_val varchar2(10000);
BEGIN
    v_folder:=UTL_FILE.FOPEN(p_director,p_fisier,'A');
      OPEN c2 FOR 'SELECT * FROM '||p_tabel;
      curid := DBMS_SQL.to_cursor_number(c2);
      DBMS_SQL.describe_columns(curid, colcnt, desctab);
      insert_col := '';
  
      FOR indx IN 1 .. colcnt LOOP
        insert_col := insert_col||'"'||desctab(indx).col_name||'"'||'|';
        IF desctab (indx).col_type = 2 THEN
          DBMS_SQL.define_column (curid, indx, numvar); 
          ELSE IF desctab (indx).col_type = 12 THEN
            DBMS_SQL.define_column (curid, indx, datevar); 
            ELSE
            DBMS_SQL.define_column (curid, indx, namevar, 4000); 
          END IF;--=12
        END IF;--=2
      END LOOP;-- for indx
      
      insert_col := rtrim(insert_col,'|');
      UTL_FILE.PUT_LINE(v_folder,insert_col);
      WHILE DBMS_SQL.fetch_rows (curid) > 0 LOOP
        insert_val := '';
        sep:='';
        FOR indx IN 1 .. colcnt LOOP
          IF (desctab (indx).col_type = 1)THEN
            DBMS_SQL.COLUMN_VALUE (curid, indx, namevar);
            insert_val := insert_val||sep||namevar;
            ELSE IF (desctab (indx).col_type = 2)THEN
              DBMS_SQL.COLUMN_VALUE (curid, indx, numvar);
              insert_val := insert_val||sep||numvar;
              ELSE IF (desctab (indx).col_type = 12)THEN
                DBMS_SQL.COLUMN_VALUE (curid, indx, datevar);
                insert_val := insert_val||sep||to_char(datevar,'DD.MM.YYYY');
                ELSE IF (desctab (indx).col_type = 96)THEN
                  DBMS_SQL.COLUMN_VALUE (curid, indx, namevar);
                  insert_val := insert_val||sep||namevar;
                END IF;--=96
              END IF;--=12
            END IF;--=2
          END IF;--=1
          sep:='|';
        END LOOP;
        UTL_FILE.PUT_LINE(v_folder,insert_val);
      END LOOP;--while 
      DBMS_SQL.close_cursor (curid);
UTL_FILE.FCLOSE(v_folder);
END;

/

begin
  csv_exp('INFORMATII','INFO','e_informatii.csv');
end;

/*
begin
  execute immediate 'create or replace directory INFO as ''C:\Users\Georgiana\Desktop\an II sem II\sgbd\PROIECT\csv''';
end;
GRANT READ, WRITE ON DIRECTORY INFO TO PUBLIC; 
DROP DIRECTORY CSVFILES;
GRANT execute on DBMS_SQL to STUDENT; 

*/
