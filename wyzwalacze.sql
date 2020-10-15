-- Zadanie 7
drop table odwrocone_slowa; 
/
create table odwrocone_slowa(nazwa varchar2(25), odwrocona_nazwa varchar2(25));
/ 

create or replace trigger dodaj_slowo before insert on odwrocone_slowa for each row 
declare
len int;
begin   
     len := Length(:new.nazwa); 
    FOR i IN REVERSE 1.. len LOOP 
        :new.odwrocona_nazwa:= :new.odwrocona_nazwa
                || Substr(:new.nazwa, i, 1); 
    END LOOP; 
end;
/ 
insert into odwrocone_slowa(nazwa) values ('koparka');   
insert into odwrocone_slowa(nazwa) values ('rzeka');   
insert into odwrocone_slowa(nazwa) values ('kajak');   
insert into odwrocone_slowa(nazwa) values ('komputer');   
select * from odwrocone_slowa; 

/ 

-- Zadanie 8
drop table menu; 
/
create table menu(dzien_tygodnia varchar2(25), potrawa varchar2(25), ilosc_zmian int);
/ 
insert into menu(dzien_tygodnia, potrawa, ilosc_zmian) values('poniedzialek','schabowe',0);
insert into menu(dzien_tygodnia, potrawa, ilosc_zmian) values('wtorek','mielone',0);
insert into menu(dzien_tygodnia, potrawa) values('sroda','pizza');
insert into menu(dzien_tygodnia, potrawa) values('czwartek','spaghetti');
insert into menu(dzien_tygodnia, potrawa) values('piatek','sushi');
/
create or replace trigger policz_zmiany before update on menu for each row 

begin
    if :new.ilosc_zmian is null then :new.ilosc_zmian:= 1;
    else :new.ilosc_zmian:=:new.ilosc_zmian+1;
    end if;
end;
/ 
UPDATE menu SET potrawa = 'makaron' WHERE dzien_tygodnia = 'wtorek';
UPDATE menu SET potrawa = 'pierogi' WHERE dzien_tygodnia = 'sroda';
UPDATE menu SET potrawa = 'sajgonki' WHERE dzien_tygodnia = 'sroda';
UPDATE menu SET potrawa = 'paczki' WHERE dzien_tygodnia = 'czwartek';
UPDATE menu SET potrawa = 'ryba' WHERE dzien_tygodnia = 'piatek';
select * from menu; 
/ 

-- Zadanie 9
drop table obecnosc; 
drop table obecnosc_mezczyzn;
/
create table obecnosc(imie varchar2(25), plec varchar2(1), wiek int);
create table obecnosc_mezczyzn(imie varchar2(25), wiek int);

/ 
create or replace trigger przekaz_do_tabeli after insert on obecnosc for each row 

begin
    if :new.plec = 'M' then insert into obecnosc_mezczyzn values (:new.imie, :new.wiek);
    end if;
end;

/ 
create or replace trigger aktualizuj_tabele after update on obecnosc for each row 
begin
        update obecnosc_mezczyzn
        set wiek = :new.wiek where imie = :new.imie;
end;
/
insert into obecnosc(imie, plec, wiek) values('Paulina','K', 24);
insert into obecnosc(imie, plec, wiek) values('Maciej','M', 36);
insert into obecnosc(imie, plec, wiek) values('Andrzej','M', 32);
insert into obecnosc(imie, plec, wiek) values('Barbara','K', 28);
insert into obecnosc(imie, plec, wiek) values('Lukasz','M', 32);
/
select * from obecnosc; 
select * from obecnosc_mezczyzn; 
UPDATE obecnosc SET wiek = '60' WHERE imie = 'Lukasz';
UPDATE obecnosc SET wiek = '49' WHERE imie = 'Andrzej';
UPDATE obecnosc SET wiek = '22' WHERE imie = 'Paulina';
/ 
select * from obecnosc; 
select * from obecnosc_mezczyzn; 

-- Zadanie 10

create or replace trigger usun_dane after delete on obecnosc for each row 
begin
    if :old.plec = 'M' then
    delete from obecnosc_mezczyzn where imie = :old.imie; 
    end if;
end;
/
delete from obecnosc where imie = 'Paulina';
delete from obecnosc where imie = 'Lukasz';
/
select * from obecnosc; 
select * from obecnosc_mezczyzn; 
/
-- Zadanie 11
drop table czas_pracy; 
drop view widok;
create table czas_pracy (imie varchar2 (25), poniedzialek int, wtorek int, sroda int, czwartek int); 
insert into czas_pracy (imie, poniedzialek, wtorek, sroda, czwartek) values ('Paulina',1,0,0,0); 
insert into czas_pracy (imie, poniedzialek, wtorek, sroda, czwartek) values ('Wojtek',1,1,1,0); 
insert into czas_pracy (imie, poniedzialek, wtorek, sroda, czwartek) values ('Robert',1,1,0,0); 
insert into czas_pracy (imie, poniedzialek, wtorek, sroda, czwartek) values ('Grzegorz',1,1,1,1); 
create view widok as 
select imie, sum(poniedzialek+wtorek+sroda+czwartek) as ilosc_dni
from czas_pracy
group by imie;

select * from czas_pracy;
select * from widok;
/ 
create or replace trigger widok_trigger instead of insert on widok for each row 
begin
     if :new.ilosc_dni=4 then
     insert into czas_pracy(imie,poniedzialek, wtorek, sroda, czwartek) values (:new.imie,1,1,1,1);    
     elsif :new.ilosc_dni=3 then
     insert into czas_pracy(imie,poniedzialek, wtorek, sroda, czwartek) values (:new.imie,1,1,1,0);  
     elsif :new.ilosc_dni=2 then
     insert into czas_pracy(imie,poniedzialek, wtorek, sroda, czwartek) values (:new.imie,1,1,0,0); 
     elsif :new.ilosc_dni=1 then
     insert into czas_pracy(imie,poniedzialek, wtorek, sroda, czwartek) values (:new.imie,1,0,0,0); 
     else
     insert into czas_pracy(imie,poniedzialek, wtorek, sroda, czwartek) values (:new.imie,0,0,0,0); 
     end if; 
end;
/
insert into widok(imie,ilosc_dni) values('Karol',2); 
/
select * from widok;
select * from czas_pracy;

-- Zadanie 12

create or replace trigger widok_trigger instead of update on widok for each row 
begin
     if :new.ilosc_dni=4 then
     update czas_pracy set poniedzialek = 1, wtorek = 1, sroda = 1, czwartek = 1 where imie = :old.imie;    
     elsif :new.ilosc_dni=3 then
     update czas_pracy set poniedzialek = 1, wtorek = 1, sroda = 1, czwartek = 0 where imie = :old.imie;    
     elsif :new.ilosc_dni=2 then
     update czas_pracy set poniedzialek = 1, wtorek = 1, sroda = 0, czwartek = 0 where imie = :old.imie;    
     elsif :new.ilosc_dni=1 then
     update czas_pracy set poniedzialek = 1, wtorek = 0, sroda = 0, czwartek = 0 where imie = :old.imie;    
     else
     update czas_pracy set poniedzialek = 0, wtorek = 0, sroda = 0, czwartek = 0 where imie = :old.imie;    
     end if; 
end;
/
UPDATE widok SET ilosc_dni = 3 WHERE imie = 'Paulina';
/
select * from widok;
select * from czas_pracy;

