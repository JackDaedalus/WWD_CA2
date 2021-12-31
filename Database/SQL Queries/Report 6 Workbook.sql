/*---
SET sqlformat ansiconsole;
 ---*/
/*---           Format Column Output of Report for Presentation       ---*/
/*--- 
COLUMN Report_Start_Dt                      HEADING 'Report Start Date' 
COLUMN Report_End_Dt                        HEADING 'Report End Date' 
COLUMN Customer_Phone                       FORMAT A15 HEADING 'Customer|Phone Number'
COLUMN Total_Activity_Last_30_Days_Duration FORMAT A25 HEADING 'Total Customer Activity|Last 30 Days (In Minutes)' 
COLUMN Total_Revenue_Last_30_Days           FORMAT  U9999.99  HEADING 'Total Revenue Generated|Last 30 Days'  
---*/




/*--- Select Customer Phone Number and Sum of Duration, Total Charges  --- */
SELECT Customer_Phone, Call_Type, Total_Activity_YTD

FROM
(
    /*--- Sub query SUMS the Duration amounts (+charge) in FACT Table --- */
    SELECT      a.phone_number as Customer_Phone, 
                c.call_event_type as Call_Type,
                SUM(d.call_event_duration) as Total_Activity_YTD
 
    FROM        dw_dimtblCustomer a,
                dw_dimtblDateTime b,
                dw_dimtblCallEvent c,
                dw_facttblCallRevenue d
                
    WHERE       a.customerphonekey  = d.Customer_Key
    AND         b.datetimekey       = d.datetimekey
    AND         c.calleventkey      = d.callevent_key
    AND         c.call_event_id     = 6 /*-- Customer Service Calls 
                                             to Customer            --*/
 
    GROUP BY    a.phone_number, c.call_event_type

)
/*--- Order and limit query to show Top 100 entries by customer activity ---*/
ORDER BY Total_Activity_YTD DESC
fetch first 3 row only;