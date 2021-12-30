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




SELECT Customer_Phone, Total_Revenue

FROM
(
    SELECT      a.phone_number as Customer_Phone, 
                SUM(c.call_event_charge) as Total_Revenue
 
    FROM        dw_dimtblCustomer a,
                dw_dimtblDateTime b,
                dw_facttblCallRevenue c
                
    WHERE       a.customerphonekey  = c.Customer_Key
    AND         b.datetimekey       = c.datetimekey
    /*AND         b.call_event_date   > '01-MAR-21'*/
 
    GROUP BY    a.phone_number

)
ORDER BY Total_Revenue DESC
fetch first 100 row only;