select * FROM dw_facttblCallRevenue;

select * FROM dw_facttblCallRevenue where CallEvent_Key in (15838);


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

/* Delete the duplicate but keep one entry                      */
DELETE FROM dw_dimtblCustomer a
WHERE ROWID <
    (SELECT max(rowid)
     FROM dw_dimtblCustomer b
     WHERE a.Phone_Number = b.Phone_Number);



Delete from dw_dimtblDateTime a
WHERE ROWID <
    (SELECT max(rowid)
     FROM dw_dimtblDateTime b
     WHERE a.CalendarDate = b.CalendarDate)