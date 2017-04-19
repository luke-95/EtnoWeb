/*
-headerul pachetului continand declaratiile
*/
CREATE OR REPLACE PACKAGE full_info IS
     --proceduri
     -- (***) vezi final script!
     FUNCTION getFullInfoByValueAndColumn (p_value IN varchar, p_column IN varchar2, p_min integer, p_max integer) RETURN full_info_object_array;
     FUNCTION getGalleryInfoByOffset (p_min integer, p_max integer)RETURN gallery_info_object_array;
     FUNCTION getDetailsById (p_id varchar) return full_info_object_array;
END full_info;
/ 

/*
-body-ul pachetului cotinand impementarile obiectelor declarate in header
*/
CREATE OR REPLACE PACKAGE BODY full_info IS  
    FUNCTION getFullInfoByValueAndColumn (p_value IN varchar, p_column IN varchar2, p_min integer, p_max integer)RETURN full_info_object_array AS 
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
      v_select := 'SELECT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_angajat, nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie, url_imagine ' || 
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) ' ||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) ' ||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) ' || 
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu) WHERE lower('|| p_column || ') like lower(''%' || p_value ||'%'')';
      
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
          
          /*DBMS_OUTPUT.PUT_LINE(RPAD(v_id, 20, ' ')  || RPAD(p_nume, 20, ' ') || 
                    RPAD(v_denumire_in_muzeu, 20, ' ') || RPAD(v_denumire_la_origine, 20, ' ') || 
                    RPAD(v_etnia, 20, ' ') || RPAD(v_datarea, 20, ' ')||
                    RPAD(v_descriere, 20, ' ') || RPAD(v_imprejmuiri, 20, ' ')||
                    RPAD(v_zona_prov, 20, ' ') || RPAD(v_localitate_prov, 20, ' ') ||
                    RPAD('bbl'||v_bibliografie, 20, ' '));*/
          
      END LOOP;
      CLOSE fullinfo;
      
      /*EXCEPTION
        WHEN null_bibliografie THEN 
          v_bibliografie := 'Nu exista bibliografie de afisat';*/
      --returnam informatiile despre toate ansamblurile
      return all_records;    
    END getFullInfoByValueAndColumn;      
    
    FUNCTION getGalleryInfoByOffset (p_min integer, p_max integer)RETURN gallery_info_object_array AS 
    --variabile
    v_id number(4);                       --campurile din obiect ce vor fi returnate
    v_denumire_ansamblu varchar(129);
    v_denumire_in_muzeu varchar(129);
    v_denumire_la_origine varchar(60);
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
    one_record gallery_info_object := gallery_info_object();              --obiect de tip info_object (structura ce contine toate campurile returnate pentru un singur ansamblu)
    all_records gallery_info_object_array :=  new gallery_info_object_array();      --array de obiecte care contine informatiile pentru TOATE ansamblurile care corespund cautarii
    counter integer :=0;
    
    BEGIN
      v_select := 'SELECT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, url_imagine ' || 
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) ' ||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) ' ||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) ' || 
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu)';
      
      v_pagination_s := 'select * from  (select rownum rown, a.* from ( ' || v_select || ' ) a where rownum <= :p_max ) where rown >= :p_min ';
      OPEN fullinfo FOR v_pagination_s USING p_max, p_min;
      LOOP
        FETCH fullinfo INTO v_rown, v_id, v_denumire_ansamblu, v_denumire_in_muzeu, v_denumire_la_origine, v_url;
        EXIT WHEN fullinfo%notfound;
          
          --populam obiectul corespunzator ansamblului curent
          one_record.denumire_ansamblu := v_denumire_ansamblu;
          one_record.id_ansamblu := v_id;
          one_record.denumire_in_muzeu := v_denumire_in_muzeu;
          one_record.denumire_la_origine := v_denumire_la_origine;
          one_record.url := v_url;
          
          --il adaugam in lista de obiecte
          counter := counter + 1;
          all_records.extend;
          all_records(counter)  := one_record;
          
          /*DBMS_OUTPUT.PUT_LINE(RPAD(v_id, 20, ' ')  || RPAD(p_nume, 20, ' ') || 
                    RPAD(v_denumire_in_muzeu, 20, ' ') || RPAD(v_denumire_la_origine, 20, ' ') || 
                    RPAD(v_etnia, 20, ' ') || RPAD(v_datarea, 20, ' ')||
                    RPAD(v_descriere, 20, ' ') || RPAD(v_imprejmuiri, 20, ' ')||
                    RPAD(v_zona_prov, 20, ' ') || RPAD(v_localitate_prov, 20, ' ') ||
                    RPAD('bbl'||v_bibliografie, 20, ' '));*/
          
      END LOOP;
      CLOSE fullinfo;
      
      /*EXCEPTION
        WHEN null_bibliografie THEN 
          v_bibliografie := 'Nu exista bibliografie de afisat';*/
      --returnam informatiile despre toate ansamblurile
      return all_records;    
    END getGalleryInfoByOffset;   
    
    FUNCTION getDetailsById (p_id varchar)RETURN full_info_object_array AS 
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
    
    v_select varchar2(1000);            --selectul folosit pentru popularea cursorului
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
     --DBMS_OUTPUT.PUT_LINE('dfvfvfvvfdvfd');
      v_select := 'SELECT DISTINCT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_angajat, nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie, url_imagine ' || 
                    'INTO :id_a, :denum, :den_muz, :den_org, :pret, :nume, :etnie, :datare, :descr, :impr, :zona_prv, :loc_prv, :bibl ' ||
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) ' ||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie)' ||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) ' || 
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) '||
                                     'JOIN preturi ON muzeu.id_muzeu = preturi.id_muzeu) WHERE ansamblu.id_ansamblu = '|| p_id;
      EXECUTE IMMEDIATE v_select INTO v_id, v_denumire_ansamblu, v_denumire_in_muzeu, v_denumire_la_origine, v_pret_bilet, v_nume_muzeu, v_etnia, v_datarea, v_descriere, v_imprejmuiri, v_zona_prov, v_localitate_prov, v_bibliografie, v_url;      
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
    
      /*EXCEPTION
        WHEN null_bibliografie THEN 
          v_bibliografie := 'Nu exista blibiografie de afisat';*/
      --returnam informatiile despre toate ansamblurile
      return all_records;    
    END getDetailsById;      
  
  END full_info;  
/

set serveroutput on;
/

/*
(***) Functia getFullInfoByValueAndColumn primeste ca parametri valoarea si coloana dupa care se face cautarea.
            column - orice coloana din tabelele ansamblu, locatie, informatii si muzeu
            value - orice cuvant cheie dupa care se va efectua cautarea
      In cadrul functiei am ales sa folosim sql dinamic pentru a evita functiile redundante care ar fi efectuat cautarea 
            dupa campuri diferite ale tabelelor (ex: getFullInfoByName, getFullInfoByZona etc). Astfel, construim un select
            care va verifica ce rezultate corespund cautarii folosind numele coloanei dupa care se face cautarea si valoarea
            cautata. Rezultatele sunt retinute intr-un cursor care este mai apoi parcurs, iar datele din el sunt retunute in
            structurile de date folosite.
      Pentru ca select-ul foloseste in clauza where operatorul 'like' (si nu '='), cautarea se face dupa cuvinte cheie
            si nu dupa valori exacte ale inregistrarilor din tabele
      TODO: de tratat exceptii pentru valori invalide ale parametrilor (Ex: coloana nu exista in tabele, niciun rezultat nu 
            a fost gasit in urma cautarii, etc)
*/

select * from TABLE(full_info.getFullInfoByValueAndColumn('Moara', 'denumirea_ansamblului', 10, 200)); --cauta cuvantul 'moara' in demunirile ansamblurilor si retuneaza rezulatatele de la 10 la 200
select * from TABLE(full_info.getFullInfoByValueAndColumn('Maramures', 'zona_provenienta', 10, 200));
select * from TABLE(full_info.getFullInfoByValueAndColumn('Ocna', 'localitate_provenienta', 20, 30));

select * from TABLE(full_info.getGalleryInfoByOffset(20,40)); --returneaza detaliile ansamblului cu id-ul '1077'

select * from TABLE(full_info.getDetailsById('1077')); --returneaza detaliile ansamblului cu id-ul '1077'
