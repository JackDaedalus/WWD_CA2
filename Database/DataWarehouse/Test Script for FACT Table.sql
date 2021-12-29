select * from dw_dimtblCallEvent
where calleventkey
in (155169)
order by connection_id; 


select * from dw_dimtblCustomer where CustomerPhoneKey
in (4446);


select * from dw_dimtblDateTime where DateTimeKey
in (1507)
order by DATETIMEKEY desc;


select distinct(call_event_type) from dw_dimtblCallEvent;
select distinct(plan_desc) from dw_dimtblCustomer;



SELECT a.call_event_type 
FROM dw_dimtblCallEvent a
WHERE a.connection_id in ('ff0c98e2-ec28-469a-8fe3-a6f18afd834b');


SELECT r.cost_per_minute 
FROM TBLCALLRATE r
WHERE r.call_type_id = '1' 
AND r.plan_id = '1'
    

 


DELETE dw_dimtblCustomer
WHERE Phone_Number in (
    SELECT      Phone_Number
    FROM        dw_dimtblCustomer
    GROUP BY    Phone_Number
    HAVING      count(*) > 1); 

select Phone_Number,
count(*)
from dw_dimtblCustomer
group by Phone_Number
having count(*) > 1; 

select * from dw_dimtblCustomer
where Phone_Number in ('01 495 7529');

Delete from dw_dimtblCustomer a
WHERE ROWID <
    (SELECT max(rowid)
     FROM dw_dimtblCustomer b
     WHERE a.Phone_Number = b.Phone_Number)





/*SELECT  a.Call_Time, b.CalendarDate 
FROM    stage_FACT_Tbl a, dw_dimtblDateTime b
WHERE   b.CalendarDate = a.Call_Time;*/

/*SELECT  count(a.Call_Time) 
FROM    stage_FACT_Tbl a, dw_dimtblDateTime b
WHERE   b.CalendarDate = a.Call_Time;*/

/*SELECT  count(b.CalendarDate) 
FROM    stage_FACT_Tbl a, dw_dimtblDateTime b
WHERE   b.CalendarDate = a.Call_Time;*/


select CalendarDate,
count(*)
from dw_dimtblDateTime
group by CalendarDate
having count(*) > 1
order by count(*) desc; 

select CalendarDate,
count(*)
from dw_dimtblDateTime
group by CalendarDate
having count(*) = 1
order by count(*) desc; 




Delete from dw_dimtblDateTime a
WHERE ROWID <
    (SELECT max(rowid)
     FROM dw_dimtblDateTime b
     WHERE a.CalendarDate = b.CalendarDate)



UPDATE stage_FACT_Tbl a
SET a.CallEvent_Key = 

    (SELECT b.CallEventKey 
     FROM dw_dimtblCallEvent b
     WHERE b.Connection_ID = a.Connection_ID)

WHERE EXISTS 
    (SELECT * FROM dw_dimtblCallEvent b
     WHERE b.Connection_ID = a.Connection_ID);





select * from dw_dimtblCallEvent
where calleventkey
in (15838)
order by connection_id; 

select * from dw_dimtblCallEvent
where connection_id
in ('ff0c98e2-ec28-469a-8fe3-a6f18afd834b');


select * from dw_dimtblCustomer where CustomerPhoneKey
in (4446);


select * from dw_dimtblDateTime where DateTimeKey
in (1507)
order by DATETIMEKEY desc;


select distinct(call_event_type) from dw_dimtblCallEvent;
select distinct(plan_desc) from dw_dimtblCustomer;


('ff0c98e2-ec28-469a-8fe3-a6f18afd834b');

SELECT  b.Cost_Per_Minute, b.call_type_id, b.plan_id
FROM    TBLCALLRATES b, 
        dw_dimtblCallEvent c, 
        dw_dimtblCustomer d,
        dw_facttblCallRevenue f
WHERE   b.call_type_id      = c.call_event_id
AND     b.plan_id           = d.plan_id
AND     c.calleventkey      = f.CallEvent_Key
AND     d.customerphonekey  = f.Customer_Key
AND     c.connection_id     = ('ff0c98e2-ec28-469a-8fe3-a6f18afd834b');



UPDATE dw_facttblCallRevenue a
SET a.Cost_Per_Minute = 
    (SELECT b.Cost_Per_Minute 
     FROM TBLCALLRATES b, 
        dw_dimtblCallEvent c, 
        dw_dimtblCustomer d
     WHERE b.call_type_id      = c.call_event_id
        AND     b.plan_id           = d.plan_id
        AND     c.calleventkey      = a.CallEvent_Key
        AND     d.customerphonekey  = a.Customer_Key
        AND     c.connection_id     = ('ff0c98e2-ec28-469a-8fe3-a6f18afd834b')
     )
WHERE EXISTS 
    (SELECT * FROM TBLCALLRATES b, 
        dw_dimtblCallEvent c, 
        dw_dimtblCustomer d
     WHERE b.call_type_id      = c.call_event_id
        AND     b.plan_id           = d.plan_id
        AND     c.calleventkey      = a.CallEvent_Key
        AND     d.customerphonekey  = a.Customer_Key
        AND     c.connection_id     = ('ff0c98e2-ec28-469a-8fe3-a6f18afd834b')
        );


select * FROM dw_facttblCallRevenue;

select * FROM dw_facttblCallRevenue where CallEvent_Key in (15838);


UPDATE stage_FACT_Tbl a
SET a.DateTimeKey = 
    (SELECT b.DateTimeKey 
     FROM dw_dimtblDateTime b
     WHERE b.CalendarDate = a.Call_Time
     ORDER BY b.DateTimeKey
     fetch first 1 row only)
WHERE EXISTS 
    (SELECT * FROM dw_dimtblDateTime b
     WHERE b.CalendarDate = a.Call_Time);  
  
     
     

