/* 
-header pachet de filtrare dupa pret
*/
CREATE OR REPLACE PACKAGE price_filter IS
     FUNCTION getAttractionsByPriceRange (p_type varchar, p_min_price integer, p_max_price integer, p_min_rownum integer, p_max_rownum integer) RETURN full_info_object_array;
     FUNCTION getAttractionsByWordAndPrice (p_value IN varchar, p_column IN varchar2, p_min_price integer, p_max_price integer, p_price_category varchar, p_min integer, p_max integer)RETURN full_info_object_array;
END price_filter;
/

/*
-body pachet filtrare dupa pret.
-functia getAttactionByPriceRange primeste ca parametri:
                -tipul de pret dupa care se face cautarea: 'student', 'elev' sau 'angajat'
                -intervalul in care se face cautarea (min si max) in functie de optiunea bifata de user.

*/
CREATE OR REPLACE PACKAGE BODY price_filter IS  
  FUNCTION getAttractionsByPriceRange (p_type varchar, p_min_price integer, p_max_price integer, p_min_rownum integer, p_max_rownum integer) RETURN full_info_object_array AS
    v_id number(4);                       --campurile din obiect ce vor fi returnate
    v_denumire_ansamblu varchar(129);
    v_denumire_in_muzeu varchar(129);
    v_denumire_la_origine varchar(60);
    v_pret_bilet number(4,2);
    v_nume_muzeu  varchar2(90);
    v_etnia varchar(24);
    v_datarea varchar(193);
    v_descriere varchar(940);
    v_imprejmuiri varchar(960);
    v_zona_prov varchar(43);
    v_localitate_prov varchar(100);
    v_bibliografie varchar(312);
    v_url varchar(86);
    v_rown integer;
  
    TYPE cursor_type IS REF CURSOR;
    ansambluri cursor_type;
    
    one_record info_object := info_object();              --obiect de tip info_object (structura ce contine toate campurile returnate pentru un singur ansamblu)
    all_records full_info_object_array :=  new full_info_object_array();      --array de obiecte care contine informatiile pentru TOATE ansamblurile care corespund cautarii
    counter integer :=0;
    
    v_select varchar2(2000);
    v_pagination_s varchar2(3000);
  BEGIN
     v_select := 'SELECT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_' || p_type || ' , nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie, url_imagine ' || 
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) '||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) '||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) '||
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON muzeu.id_muzeu = preturi.id_muzeu) WHERE pret_' || p_type || ' > ' || p_min_price || ' AND pret_' || p_type || ' < ' || p_max_price;
    
     v_pagination_s := 'select * from  (select rownum rown, a.* from ( ' || v_select || ' ) a where rownum <= :p_max ) where rown >= :p_min ';
     DBMS_OUTPUT.PUT_LINE(v_pagination_s);
     OPEN ansambluri for v_pagination_s using p_max_rownum, p_min_rownum;
      LOOP
        FETCH ansambluri INTO v_rown, v_id, v_denumire_ansamblu, v_denumire_in_muzeu, v_denumire_la_origine, v_pret_bilet, v_nume_muzeu, v_etnia, v_datarea, v_descriere, v_imprejmuiri, v_zona_prov, v_localitate_prov, v_bibliografie, v_url;
        EXIT WHEN ansambluri%notfound;
          one_record.denumire_ansamblu := v_denumire_ansamblu;
          one_record.id_ansamblu := v_id;
          one_record.denumire_in_muzeu := v_denumire_in_muzeu;
          one_record.denumire_la_origine := v_denumire_la_origine;
          one_record.pret_bilet := v_pret_bilet;
          one_record.nume_muzeu := v_nume_muzeu;
          one_record.etnia := v_etnia;
          one_record.datarea := v_datarea;
          one_record.descriere := v_descriere;
          one_record.imprejmuiri := v_imprejmuiri;
          one_record.zona_prov := v_zona_prov;
          one_record.localitate_prov := v_localitate_prov;
          one_record.bibliografie := v_bibliografie;
          one_record.url := v_url;

  
       --il adaugam in lista de obiecte
          counter := counter + 1;
          all_records.extend;
          all_records(counter)  := one_record;
      END LOOP;
      CLOSE ansambluri;
      
      return all_records;
  END getAttractionsByPriceRange;
  
  FUNCTION getAttractionsByWordAndPrice (p_value IN varchar, p_column IN varchar2, p_min_price integer, p_max_price integer, p_price_category varchar, p_min integer, p_max integer)RETURN full_info_object_array AS 
    --variabile
    v_id number(4);                       --campurile din obiect ce vor fi returnate
    v_denumire_ansamblu varchar(129);
    v_denumire_in_muzeu varchar(129);
    v_denumire_la_origine varchar(60);
    v_pret_bilet number(4,2);
    v_nume_muzeu  varchar2(90);
    v_etnia varchar(24);
    v_datarea varchar(193);
    v_descriere varchar(940);
    v_imprejmuiri varchar(960);
    v_zona_prov varchar(43);
    v_localitate_prov varchar(100);
    v_bibliografie varchar(312);
    v_url varchar(86);
    v_rown integer;
    
    v_select varchar2(1000);            --selectul folosit pentru popularea cursorului
    v_pagination_s varchar2(2000);
    --cursori    
    TYPE cursor_type IS REF CURSOR;
    fullinfo cursor_type;
    --exceptii
    --null_bibliografie EXCEPTION;
    --PRAGMA EXCEPTION_INIT(null_bibliografie, -20003);
    --varray + record
    one_record info_object := info_object();              --obiect de tip info_object (structura ce contine toate campurile returnate pentru un singur ansamblu)
    all_records full_info_object_array :=  new full_info_object_array();      --array de obiecte care contine informatiile pentru TOATE ansamblurile care corespund cautarii
    counter integer :=0;
    
    BEGIN
      v_select := 'SELECT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_' || p_price_category || ' , nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie, url_imagine ' || 
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) ' ||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) ' ||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) ' || 
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu) WHERE lower('|| p_column || ') like lower(''%' || p_value ||'%'') AND pret_' || p_price_category || ' < ' || p_max_price || ' AND pret_' || p_price_category || ' > ' || p_min_price;
      
      v_pagination_s := 'select * from  (select rownum rown, a.* from ( ' || v_select || ' ) a where rownum <= :p_max ) where rown >= :p_min ';
      OPEN fullinfo FOR v_pagination_s USING p_max, p_min;
      LOOP
        FETCH fullinfo INTO v_rown, v_id, v_denumire_ansamblu, v_denumire_in_muzeu, v_denumire_la_origine, v_pret_bilet, v_nume_muzeu, v_etnia, v_datarea, v_descriere, v_imprejmuiri, v_zona_prov, v_localitate_prov, v_bibliografie, v_url;
        EXIT WHEN fullinfo%notfound;
        
          IF(v_bibliografie is null) THEN 
            DBMS_OUTPUT.PUT_LINE('null');
            v_bibliografie := 'Nu exista blibiografie de afisat';
            --RAISE null_bibliografie;
          END IF;
          
          --populam obiectul corespunzator ansamblului curent
          one_record.denumire_ansamblu := v_denumire_ansamblu;
          one_record.id_ansamblu := v_id;
          one_record.denumire_in_muzeu := v_denumire_in_muzeu;
          one_record.denumire_la_origine := v_denumire_la_origine;
          one_record.pret_bilet := v_pret_bilet;
          one_record.nume_muzeu := v_nume_muzeu;
          one_record.etnia := v_etnia;
          one_record.datarea := v_datarea;
          one_record.descriere := v_descriere;
          one_record.imprejmuiri := v_imprejmuiri;
          one_record.zona_prov := v_zona_prov;
          one_record.localitate_prov := v_localitate_prov;
          one_record.bibliografie := v_bibliografie;
          one_record.url := v_url;

          --il adaugam in lista de obiecte
          counter := counter + 1;
          all_records.extend;
          all_records(counter)  := one_record;
          
      END LOOP;
      CLOSE fullinfo;

      return all_records;    
    END getAttractionsByWordAndPrice;      
    
  
END price_filter;
/


select * from TABLE(price_filter.getAttractionsByPriceRange('student', 0, 10, 1, 2000)); --cauta ansamblurile al caror bilet are pretul intre 0 si 5 RON pentru categoria 'student'

select * from TABLE(price_filter.getAttractionsByWordAndPrice('moara', 'denumirea_ansamblului', 0, 20, 'student', 1, 200));

