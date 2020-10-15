--generowanie losowej nazwy rosliny
create or replace function gen_nazwa(
    dlugosc int:=5
) return string as
begin
    return dbms_random.string('U',1) || dbms_random.string('l',dlugosc);
end gen_nazwa;
/
select 
    gen_nazwa() as nazwa1,
    gen_nazwa(15) as nazwa2,
    gen_nazwa(3) as nazwa3
from dual;
/
-- generowanie losowych wspolrzednych x;y
create or replace function gen_wspolrzedne return varchar2 as
begin
    return trunc(dbms_random.value(-150,150),2)||';'||                  
    trunc(dbms_random.value(-200,200),2);
end gen_wspolrzedne;
/
select 
    gen_wspolrzedne() as wspolrzedne1,
    gen_wspolrzedne() as wspolrzedne2,
    gen_wspolrzedne() as wspolrzedne3
from dual;
/
--generowanie losowej godziny
create or replace function gen_czas return date as
begin
    return to_date('00:00','hh24:mi') + trunc(dbms_random.value(0,23))/24;
end gen_czas;
/
alter session set nls_date_format = 'hh24:mi';
/
select 
    gen_czas() as czas1,
    gen_czas() as czas2,    
    gen_czas() as czas3
from dual;
/
--generowanie losowej wypowiedzi psa
create or replace function gen_zdanie(
    min_ilosc int:=1,
    max_ilosc int:= 10
)return varchar2 as
    dialog varchar2(100);
begin
    for x in 1..trunc(dbms_random.value(min_ilosc,max_ilosc)) loop
        dialog := dialog || 'hau ';
    end loop;
    return dialog;
end gen_zdanie;
/
select 
    gen_zdanie() as zdanie1,
    gen_zdanie(1,3) as zdanie2,
    gen_zdanie(5,15) as zdanie3
from dual;
/
--procedura generowania bazy danych roœlin
drop table rosliny; 
/
create table rosliny(id int, nazwa varchar2(50), wspolrzedne varchar2(20), godzina date); 
/
alter session set nls_date_format = 'hh24:mi';
/
create or replace procedure dodaj_rosliny(ilosc int) as 
begin
    for vi in 1..ilosc loop
        insert into rosliny(id,nazwa,wspolrzedne,godzina)
        values(vi, gen_nazwa(), gen_wspolrzedne(), gen_czas());
    end loop; 
end;
/ 
execute dodaj_rosliny(500); 
/
select * from rosliny;
/
--generowanie dialogu psow
drop table dialog; 
/
create table dialog(id int, imie varchar2(50), zdanie varchar2(100)); 
/
create or replace procedure generuj_dialog(ilosc int) as 
begin
    for vi in 1..ilosc loop
        insert into dialog(id,imie, zdanie)
        values(vi, 'pies'||trunc(dbms_random.value(1,vi)), gen_zdanie());
    end loop; 
end;
/ 
execute generuj_dialog(50); 
/
select * from dialog;