set serveroutput on;
drop type t_table;
/
create or replace type t_obj as object (v_url varchar2(500),v_info1 varchar2(500), v_info2 varchar2(500),CONSTRUCTOR FUNCTION t_obj RETURN SELF AS RESULT);
/
create or replace type body t_obj as 
    CONSTRUCTOR FUNCTION t_obj RETURN SELF AS RESULT AS
    BEGIN
      RETURN;
    END;
end ;
/
create or replace type t_table as table of t_obj;
/
CREATE OR REPLACE PACKAGE p_gallery_info AS
    FUNCTION get_info(v_word VARCHAR2, v_column VARCHAR2) RETURN t_table ;
END p_gallery_info;
/

CREATE OR REPLACE PACKAGE BODY p_gallery_info IS
    nu_exista_date exception;
    PRAGMA EXCEPTION_INIT(nu_exista_date, -20001);
    FUNCTION get_info(v_word VARCHAR2, v_column VARCHAR2)
    RETURN t_table IS
    v_obj t_obj;  
    sel varchar2(200);
    type curs is ref cursor;
    c1 curs;
    v_url varchar2(100);
    v_da varchar2(200);
    v_ta varchar2(100);
    v_dm varchar2(200);
    counter integer :=0;
    all_url t_table := t_table();
    BEGIN
      sel := 'SELECT url_imagine, denumirea_ansamblului,tipul_ansamblului,denumirea_in_muzeu '||'FROM informatii ' ||'JOIN ansamblu ON ansamblu.id_ansamblu = informatii.id_ansamblu ' ||'WHERE '|| v_column || ' like''%' || v_word ||'%''';
      open c1 for sel;
      loop
      fetch c1 into v_url,v_da,v_ta,v_dm;
      EXIT WHEN c1%notfound;
      --DBMS_OUTPUT.PUT_LINE(v_url);
      v_obj := t_obj();
      v_obj.v_url := v_url;
      if(v_da is not null) then
        v_obj.v_info1:=v_da;
      else
        v_obj.v_info1:=v_ta;
      end if;
      v_obj.v_info2:=v_dm;
      counter:=counter+1;
      all_url.extend;
      all_url(counter):=v_obj;
      end loop;
      close c1;
      if(v_dm is null) then 
        raise nu_exista_date;
      else
        return all_url;
      end if;
      EXCEPTION
      WHEN nu_exista_date THEN
          raise_application_error (-20001,'Nu exista date care contin"'||v_word||'".');
    END get_info;
END p_gallery_info;
/
select distinct id_ansamblu, denumirea_ansamblului, denumirea_la_origine, denumirea_in_muzeu, url_imagine FROM ansamblu NATURAL JOIN informatii;
SELECT * FROM TABLE(p_gallery_info.get_info ( 'at','denumirea_in_muzeu')) ;