/*
-structura care retine campurile returnate de cautare 
  adica toate informatiile disponibile despre ansamblul care
  corespunde cautarii
-retine informatii despre un singur ansamblu
-de tip object (echivalentul unei structuri in C
*/
--select * from TABLE(price_filter.getAttractionsByWordAndPrice('wasd', 'denumirea_ansamblului',111,222,'angajat', 1, 200))

CREATE OR REPLACE TYPE info_object AS OBJECT(
        id_ansamblu  number(4),
        denumire_ansamblu varchar(129),
        denumire_in_muzeu  varchar(129),
        denumire_la_origine varchar(60),
        nume_muzeu  varchar2(90),
        pret_bilet number(4,2),
        etnia varchar(24),
        datarea varchar(193),
        descriere varchar(940),
        imprejmuiri varchar(960),
        zona_prov varchar(43),
        localitate_prov varchar(100),
        bibliografie varchar(312),
        url varchar(86),
        CONSTRUCTOR FUNCTION info_object RETURN SELF AS RESULT
        );

CREATE OR REPLACE TYPE gallery_info_object AS OBJECT(
        id_ansamblu  number(4),
        denumire_ansamblu varchar(129),
        denumire_in_muzeu  varchar(129),
        denumire_la_origine varchar(60),
        url varchar(86),
        CONSTRUCTOR FUNCTION gallery_info_object RETURN SELF AS RESULT
        );
        
CREATE OR REPLACE TYPE BODY gallery_info_object
AS
   CONSTRUCTOR FUNCTION gallery_info_object RETURN SELF AS RESULT
   AS
   BEGIN
      RETURN;
   END;
END;
/*
-body-ul typului info_object in care definim constructorul propriu
    pentru a permite initializarea obiectelor in cadrul functiei
    (nu putem folosi obiecte neinstantiate)
*/
CREATE OR REPLACE TYPE BODY info_object
AS
   CONSTRUCTOR FUNCTION info_object RETURN SELF AS RESULT
   AS
   BEGIN
      RETURN;
   END;
END;

/*
-'array-ul' de obiecte de tip info_object returnat de functie
-declarat sub forma de table of, pentru a facilita parcurgerea rezultatelor 
-retine informatii despre TOATE ansamblurile care corespund cautarii
*/
CREATE OR REPLACE type full_info_object_array is table of info_object;
CREATE OR REPLACE type gallery_info_object_array is table of gallery_info_object;

