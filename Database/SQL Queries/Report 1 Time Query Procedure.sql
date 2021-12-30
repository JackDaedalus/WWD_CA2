

CREATE OR REPLACE PROCEDURE SQL_REPORT1(name_in IN varchar2) 

IS

    last_date Date;

BEGIN

    SELECT MAX(call_event_date) INTO last_date
    FROM dw_dimtblDateTime;
    
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
        AND         b.call_event_date   > '01-MAR-21'
     
        GROUP BY    a.phone_number
    
    )
    ORDER BY Total_Revenue DESC;
    /*fetch first 100 row only;*/
    
    
EXCEPTION
    
    when others then
        /*dbms_output.put_line(SQLCODE);*/
        dbms_output.put_line(SQLERRM);

    
END;    


BEGIN
    SQL_REPORT1('name');
END;