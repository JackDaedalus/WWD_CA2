/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* --- SQL REPORT ONE : Top 100 Customers From Last Month - By Revenue   */


/*--- Read in the value of the last time entry in the data warehouse --- */
/*--- for a call event. This will be the dynamic baseline for the    --- */
/*--- timeframe of the query                                         --- */
drop table temp_date;
CREATE TABLE temp_date as
    SELECT MAX(call_event_date) as Max_Date FROM dw_dimtblDateTime;



/*--- Select Customer Phone Number and Sum of Charges --- */
SELECT Customer_Phone, Total_Revenue

FROM
(
    /*--- Sub query SUMS the charge amounts in FACT Table --- */
    SELECT      a.phone_number as Customer_Phone, 
                SUM(c.call_event_charge) as Total_Revenue
 
    FROM        dw_dimtblCustomer a,
                dw_dimtblDateTime b,
                dw_facttblCallRevenue c
                
    WHERE       a.customerphonekey  = c.Customer_Key
    AND         b.datetimekey       = c.datetimekey
    AND         b.call_event_date   > ( /* -- Last 30 days of charges --*/
                                        select (Max_date)-30 from temp_date
                                      )
 
    GROUP BY    a.phone_number

)
/*--- Order and limit query to show Top 100 entries by customer charge ---*/
ORDER BY Total_Revenue DESC
fetch first 100 row only;