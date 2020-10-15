create table wykladowcy (
    id number(3) not null unique, 
    imie varchar2(20 char) not null, 
    nazwisko varchar2(20 char) not null, 
    pesel varchar2(11 char) unique constraint wykladowcy_pesel_CH check(length(pesel) = 11)
);
create table studenci (
    id number(4) not null unique, 
    imie varchar2(20 char) not null, 
    nazwisko varchar2(20 char) not null, 
    numer_leg varchar2(8 char) unique constraint studenci_leg_CH check(length(numer_leg) = 8)
);
create table adresy (
    id number(5) not null unique, 
    miejscowosc varchar2 (30 char) not null, 
    ulica varchar2(30 char), 
    kod_poczt varchar2(6 char) constraint adres_kod_CH check(length(kod_poczt) = 6), 
    numer_bud varchar2(7 char) not null, 
    numer_lok varchar2(6 char), 
    id_wykladowcy number(3) constraint adres_wykladowcy_FK REFERENCES wykladowcy(id), 
    id_studenta number(4) constraint adres_studenci_FK REFERENCES studenci(id), 
    constraint wykladowcy_studenenci_CH check ((id_wykladowcy IS NULL OR id_studenta IS NULL) AND (id_wykladowcy IS NOT NULL OR id_studenta IS NOT NULL))
);


insert into wykladowcy values (1, 'Marek', 'Nowak', '80105564098');
insert into wykladowcy values (2, 'Mateusz', 'Kowal', '84105265038');

insert into studenci values (1, 'Maciej', 'Maciejewski', '56493870');
insert into studenci values (2, 'Jakub', 'Jakubiak', '75847365');

insert into adresy values (1, 'Maciejewo', NULL, '54-400', '8',NULL, 1, NULL);
insert into adresy values (2, 'Kacperki', 'Maslana', '25-564', '46','3', NULL, 1);

select imie, nazwisko, a.miejscowosc, pesel, null as numer_leg from wykladowcy left join adresy a on a.id_wykladowcy = wykladowcy.id 
union 
select imie, nazwisko, a.miejscowosc, null as pesel, numer_leg from studenci left join adresy a on a.id_studenta = studenci.id order by nazwisko, imie; 

drop table wykladowcy cascade constraints;
drop table studenci cascade constraints;
drop table adresy;
