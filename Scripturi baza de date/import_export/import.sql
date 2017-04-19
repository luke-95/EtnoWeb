--set serveroutput on;
drop table aj;
/
drop table e_informatii;
/
CREATE TABLE e_informatii
(id_ansamblu number(4),
bibliografie varchar2(400),
url_imagine varchar2(200)
);
/
CREATE TABLE aj(id_ansamblu number(4),
bibliografie varchar2(400),
url_imagine varchar2(200)
)
ORGANIZATION EXTERNAL
    (DEFAULT DIRECTORY INFO 
    ACCESS PARAMETERS(RECORDS DELIMITED BY NEWLINE SKIP 1 FIELDS TERMINATED BY '|' )
LOCATION ('e_informatii.csv')   );
/
INSERT INTO e_informatii(select * from aj);

--select * from aj;
--select * from e_informatii;

