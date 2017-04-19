------------------------------------------------------ CONSTRAINTS ----------------------------------------------
ALTER TABLE locatii ADD CONSTRAINT pk_id_locatie PRIMARY KEY (id_locatie);
ALTER TABLE turisti ADD CONSTRAINT ck_nume_turist CHECK (nume = INITCAP (nume));
ALTER TABLE turisti ADD CONSTRAINT ck_prenume CHECK (prenume = INITCAP (prenume));
ALTER TABLE preturi MODIFY (pret_angajat CONSTRAINT nn_pret_angajat NOT NULL);
ALTER TABLE informatii ADD CONSTRAINT fk_informatii FOREIGN KEY (id_ansamblu) REFERENCES ansamblu (id_ansamblu);
ALTER TABLE locatie_ansamblu ADD CONSTRAINT fk_locatie_ans FOREIGN KEY (id_ansamblu) REFERENCES ansamblu (id_ansamblu);
ALTER TABLE locatie_ansamblu ADD CONSTRAINT fk_locatie_ans_id_loc FOREIGN KEY (id_locatie) REFERENCES locatii (id_locatie);
ALTER TABLE preturi ADD CONSTRAINT fk_preturi FOREIGN KEY (id_muzeu) REFERENCES muzeu (id_muzeu);


---------------------------------------------------- INDECSI --------------------------------------------
CREATE INDEX indx_nume_ansamblu ON ansamblu(denumirea_ansamblului);7
CREATE INDEX indx_datare ON ansamblu(datarea);
CREATE INDEX indx_etinie ON ansamblu(etnia);
CREATE INDEX unique_nume_muzeu ON muzeu(nume);
CREATE INDEX indx_localitate ON locatii(localitate_provenienta);
CREATE INDEX indx_zona ON locatii(zona_provenienta);
CREATE INDEX indx_pret_student ON preturi(pret_student);
CREATE INDEX indx_pret_angajat ON preturi(pret_angajat);
CREATE INDEX indx_pret_elev ON preturi(pret_elev);

------------------------------------------- TRIGGERE ----------------------------------------------------------------------------

--DROP TRIGGER StergeMuzeu;
/
CREATE OR REPLACE TRIGGER StergeMuzeu
BEFORE DELETE ON muzeu
FOR EACH ROW
BEGIN
	DELETE FROM ansamblu  where id_muzeu = :Old.id_muzeu;
  DELETE FROM preturi  where id_muzeu = :Old.id_muzeu;
END;
/

DELETE FROM muzeu WHERE id_muzeu = 2;

--DROP TRIGGER StergeAnsamblu;
/
CREATE OR REPLACE TRIGGER StergeAnsamblu
BEFORE DELETE ON ansamblu
FOR EACH ROW
BEGIN
	DELETE FROM informatii  where id_ansamblu = :Old.id_ansamblu;
  DELETE FROM locatie_ansamblu  where id_ansamblu = :Old.id_ansamblu;
END;

DELETE FROM ansamblu where id_ansamblu = 1;
/

----------------------------------------------------- SELECTURI SIMPLE --------------------------
--SELECT BY WORD AND PRICE

SELECT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_student , nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie 
                    FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) 
                                     JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie) 
                                     JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu)  
                                     JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu)
                                     JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu) WHERE lower(etnia) like lower('%romani%') AND pret_student < 10 AND pret_student > 1;
      
--SLEECT BY KEYWORD

SELECT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_angajat, nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie 
                    FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) 
                                     JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie)
                                     JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) 
                                     JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) 
                                     JOIN preturi ON preturi.id_muzeu = muzeu.id_muzeu) WHERE denumirea_ansamblului like '%Moara%' ORDER BY denumirea_ansamblului;
      
--SELECT DETAILS BY ID

SELECT DISTINCT ansamblu.id_ansamblu, denumirea_ansamblului, denumirea_in_muzeu, denumirea_la_origine, pret_angajat, nume, etnia, datarea, descriere, imprejmuiri, zona_provenienta, localitate_provenienta, bibliografie 
                    FROM (((((ansamblu JOIN locatie_ansamblu ON ansamblu.id_ansamblu = locatie_ansamblu.id_ansamblu) 
                                     JOIN locatii ON locatie_ansamblu.id_locatie = locatii.id_locatie)
                                     JOIN informatii ON ansamblu.id_ansamblu = informatii.id_ansamblu) 
                                     JOIN muzeu ON ansamblu.id_muzeu = muzeu.id_muzeu) 
                                     JOIN preturi ON muzeu.id_muzeu = preturi.id_muzeu) WHERE ansamblu.id_ansamblu = '1077';