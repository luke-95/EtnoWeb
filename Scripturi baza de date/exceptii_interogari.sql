CREATE OR REPLACE PACKAGE p_interogari AS
  PROCEDURE interogare(interogare IN varchar2,rezultat OUT varchar2);
END p_interogari;
/
CREATE OR REPLACE PACKAGE BODY p_interogari IS
  PROCEDURE interogare(interogare IN varchar2,rezultat OUT varchar2) IS
    BEGIN
      EXECUTE IMMEDIATE interogare;
      rezultat:='Interogare executata cu succes.';
      --IF SQL%NOTFOUND THEN
       -- rezultat:='Nu au fost gasite date.';
      --END IF;
      EXCEPTION
      WHEN no_data_found THEN
        rezultat:='Nu au fost gasite date.';
      WHEN dup_val_on_index THEN
        rezultat:='Inregistrare duplicat detectata!';
      WHEN others THEN
        IF(SQLCODE=-904) THEN
          rezultat:='Camp inexistent.';
        END IF;
        IF(SQLCODE=-942) THEN
          rezultat:='Tabela nu exista.';
        END IF;
        IF(SQLCODE=-947) THEN
          rezultat:='Parametri insuficienti la inserare.';
        END IF;
        IF(SQLCODE=-926) THEN
          rezultat:='Interogare nefinalizata.';
        END IF;
        IF(SQLCODE=-925) THEN
          rezultat:='Interogare incorecta.'; 
        END IF;
        IF(SQLCODE=-984) THEN
          rezultat:='Interogare incorecta.'; 
        END IF;
        IF(SQLCODE=-1) THEN
          rezultat:='Valoare duplicat detectata!'; 
        END IF;      
        IF(SQLCODE=-1403) THEN
          rezultat:='Nicio inregistrare nu a fost gasita!'; 
        END IF; 
        IF(SQLCODE=-923) THEN
          rezultat:='From keyword not found where expected.'; 
        END IF; 
               
  
  END interogare;
END p_interogari;
/
DECLARE
rezultat varchar2(500);
BEGIN
  --p_interogari.interogare('select * from STUDENTI',rezultat);
  --p_interogari.interogare('INSERT INTO studenti VALUES (''116'', ''Bodnar'', ''Ioana'',2, ''A1'',NULL, TO_DATE(''26/08/1996'', ''dd/mm/yyyy''))',rezultat);
  p_interogari.interogare('delete from studenti where nume = ''cdcds''',rezultat);

  dbms_output.put_line(rezultat);
END;
/
--set serveroutput on;

ALTER TABLE studenti ADD CONSTRAINT pk_nrmat PRIMARY KEY (nr_matricol);
