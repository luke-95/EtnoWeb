CREATE OR REPLACE PACKAGE count_results IS
     --proceduri
     FUNCTION countResultsByValueAndColumn (p_value IN varchar, p_column IN varchar2) RETURN integer;
     FUNCTION countResultsForAllInGallery RETURN integer;
     FUNCTION countAttractionsByPriceRange (p_type varchar, p_min_price integer, p_max_price integer) RETURN integer;
     FUNCTION countAttractionsByWordAndPrice (p_value IN varchar, p_column IN varchar2, p_min_price integer, p_max_price integer, p_price_category varchar)RETURN integer; 

END count_results;

CREATE OR REPLACE PACKAGE BODY count_results IS
     --proceduri
     FUNCTION countResultsByValueAndColumn (p_value IN varchar, p_column IN varchar2) RETURN integer AS
     v_count integer;
     v_select varchar2(2000) := 'SELECT  count(id_ansamblu) INTO :v_count ' || 
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) ' ||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) ' ||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) ' || 
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu) WHERE lower('|| p_column || ') like lower(''%' || p_value ||'%'')';
     BEGIN
        EXECUTE IMMEDIATE v_select INTO v_count;
        return v_count;
     END countResultsByValueAndColumn;
     
     FUNCTION countResultsForAllInGallery RETURN integer AS
     v_count integer;
     v_select varchar2(2000) := 'Select count (id_ansamblu) INTO :v_count from ansamblu';
     BEGIN
         EXECUTE IMMEDIATE v_select INTO v_count;
         return v_count;
     END countResultsForAllInGallery;
     
     FUNCTION countAttractionsByPriceRange (p_type varchar, p_min_price integer, p_max_price integer) RETURN integer AS
     v_count integer;
     v_select varchar2(2000) := 'SELECT count(ansamblu.id_ansamblu) INTO :v_count '|| 
                    'FROM ((ansamblu JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON muzeu.id_muzeu = preturi.id_muzeu) WHERE pret_' || p_type || ' > ' || p_min_price || ' AND pret_' || p_type || ' < ' || p_max_price;
    
     BEGIN
         EXECUTE IMMEDIATE v_select INTO v_count;
         return v_count;
     END countAttractionsByPriceRange;
     
     FUNCTION countAttractionsByWordAndPrice (p_value IN varchar, p_column IN varchar2, p_min_price integer, p_max_price integer, p_price_category varchar)RETURN integer AS
     v_count integer;
     v_select varchar2(2000) := 'SELECT count(ansamblu.id_ansamblu) INTO :v_count ' || 
                    'FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) ' ||
                                     'JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) ' ||
                                     'JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) ' || 
                                     'JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) ' ||
                                     'JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu) WHERE lower('|| p_column || ') like lower(''%' || p_value ||'%'') AND pret_' || p_price_category || ' < ' || p_max_price || ' AND pret_' || p_price_category || ' > ' || p_min_price;
      
     BEGIN
        EXECUTE IMMEDIATE v_select INTO v_count;
        return v_count;
     END countAttractionsByWordAndPrice;

END count_results;



declare
   v_a integer;
   v_b integer;
   v_c integer;
   v_d integer;
begin
   v_a := count_results.countResultsByValueAndColumn('Moara', 'denumirea_ansamblului');
   v_b := count_results.countResultsForAllInGallery();
   v_c := count_results.countAttractionsByPriceRange ('student', 0, 10);
   v_d := count_results.countAttractionsByWordAndPrice ('moara', 'denumirea_ansamblului', 0, 20, 'student'); 

  DBMS_OUTPUT.PUT_LINE(v_a);
  DBMS_OUTPUT.PUT_LINE(v_b);
  DBMS_OUTPUT.PUT_LINE(v_c);
  DBMS_OUTPUT.PUT_LINE(v_d);
end;