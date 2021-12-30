select count(*) from dw_facttblCallRevenue;
select count(*) from dw_dimtblDateTime;
select count(*) from dw_dimtblCustomer;
select count(*) from dw_dimtblCallEvent;



select * from dw_facttblCallRevenue
fetch first 10 row only;

select * from dw_dimtblCustomer
fetch first 10 row only;

select * from dw_dimtblDateTime
fetch first 10 row only;

select min(call_event_date) from dw_dimtblDateTime;
select max(call_event_date) from dw_dimtblDateTime;



select * from dw_dimtblCustomer
where phone_number in ('065 692 1249'); 

select * from dw_dimtblCustomer
where phone_number in ('065 692 1249'); 

select * from dw_facttblCallRevenue
where Customer_Key in (4325);



select sum(call_event_charge) from dw_facttblCallRevenue
where Customer_Key in (4325);



select * from dw_dimtblCustomer
where phone_number in ('098 479 8154'); 

select * from dw_facttblCallRevenue
where Customer_Key in (4181);

select sum(call_event_charge) from dw_facttblCallRevenue
where Customer_Key in (4181);


SELECT EXTRACT(month FROM CALL_EVENT_DATE) FROM dw_dimtblDateTime;
