CREATE TABLE panstwa (
    id number(3) CONSTRAINT panstwa_PK PRIMARY KEY,
    nazwa varchar2(35 char) NOT NULL CONSTRAINT nazwa_panstwa_UN UNIQUE,
    liczba_mieszkancow number(10) NOT NULL CONSTRAINT libacz_mieszkancow_dodatnia_CHK check(liczba_mieszkancow>=0)
);
CREATE TABLE morza (
    id number(3) CONSTRAINT morza_PK PRIMARY KEY,
    nazwa varchar2(40) NOT NULL,
    powierzchnia number(7) NOT NULL,
    typ varchar2(20)
);
CREATE TABLE panstwa_morza (
    id integer CONSTRAINT panstwa_morza_PK PRIMARY KEY,
    id_panstwa number(3) NOT NULL CONSTRAINT id_panstwa_FK REFERENCES panstwa(id),
    id_morza number(3) NOT NULL CONSTRAINT id_morza_FK REFERENCES morza(id),
    linia_brzegowa number(10)
);
INSERT INTO panstwa VALUES (1, 'Polska', 312696);
INSERT INTO panstwa VALUES(2, 'Niemcy', 357578);
INSERT INTO panstwa VALUES(3, 'Mongolia', 1564116);

INSERT INTO morza VALUES (1, 'Baltyckie', 377000, 'przybrzezne');
INSERT INTO morza VALUES(2, 'Polnocne', 575000, 'otwarte');
INSERT INTO morza VALUES(3, 'Karaibskie', 2754000, NULL);

INSERT INTO panstwa_morza VALUES(1, 1, 1, 10000);
INSERT INTO panstwa_morza VALUES(2, 2, 1, 13000);
INSERT INTO panstwa_morza VALUES(3, 2, 2, 20000);
INSERT INTO panstwa_morza VALUES(4, 1, 3, 20000);


SELECT panstwa.nazwa AS panstwa, morza.nazwa AS morza, panstwa_morza.linia_brzegowa FROM panstwa
LEFT JOIN panstwa_morza ON panstwa.id = panstwa_morza.id_panstwa
LEFT JOIN morza ON panstwa_morza.id_morza = morza.id  WHERE panstwa.nazwa LIKE '%a' ORDER BY panstwa.nazwa, morza.nazwa;

DROP TABLE panstwa_morza;
DROP TABLE panstwa;
DROP TABLE morza;