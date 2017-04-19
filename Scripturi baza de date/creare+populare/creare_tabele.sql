DROP TABLE ansamblu;
DROP TABLE muzeu;
DROP TABLE locatii;

DROP TABLE informatii;
DROP TABLE turisti;
DROP TABLE preturi;
drop table locatie_ansamblu;

select * from locatii where zona_provenienta is null ;
select * from locatie where zona_provenienta is null ;

CREATE TABLE preturi(
  id_muzeu number(4) NOT NULL PRIMARY KEY,
  pret_student number (4,2),
  pret_elev number (4,2),
  pret_angajat number (4,2)
);

CREATE TABLE turisti(
  nume varchar2(15),
  prenume varchar2(15),
  ocupatie varchar2(15),
  varsta number(3)
);

CREATE TABLE muzeu(
  id_muzeu number(4) NOT NULL PRIMARY KEY,
  nume varchar2(90) NOT NULL
);

/

CREATE TABLE ansamblu (
  id_muzeu number(4) NOT NULL,
  id_ansamblu number(4) NOT NULL PRIMARY KEY,
  denumirea_ansamblului varchar(129) ,
  tipul_ansamblului varchar2(100),
  denumirea_in_muzeu varchar(129) NOT NULL,
  denumirea_la_origine varchar(60) ,
  etnia varchar(24) ,
  datarea varchar(193) ,
  descriere varchar(940) ,
  imprejmuiri varchar(960) ,
  FOREIGN KEY (id_muzeu) REFERENCES muzeu(id_muzeu)
);

/

CREATE TABLE locatii (
  id_locatie number(4) NOT NULL,
  zona_provenienta varchar(43) ,
  localitate_provenienta varchar(100) 
);

/

CREATE TABLE locatie_ansamblu (
  id_ansamblu number(4) NOT NULL,
  id_locatie number(4) NOT NULL 
);


CREATE TABLE informatii(
  id_ansamblu number(4) NOT NULL,
  bibliografie varchar(312) ,
  url_imagine varchar(86) 
);