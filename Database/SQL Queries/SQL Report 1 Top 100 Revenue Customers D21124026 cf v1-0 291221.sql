/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/

/* -- Set SQL Session to try and pick up EURO Currency symbols   */
alter session set NLS_ISO_CURRENCY='IRELAND';
alter session set NLS_DUAL_CURRENCY = '€';

/* --- SQL REPORT ONE : Top 100 Customers From Last Month - By Revenue   */
/*SET sqlformat ansiconsole;*/
/*SET sqlformat default;*/


/*---           Add Title to SQL REPORT ONE Ouptut                    ---*/
TTITLE LEFT 'SQL REPORT ONE -  Top 100 Customers From 30 Days - By Revenue' SKIP 1 


/*---           Format Column Output of Report for Presentation       ---*/
COLUMN Report_Start_Dt              HEADING 'Report Start Date' 
COLUMN Report_End_Dt                HEADING 'Report End Date' 
COLUMN Customer_Phone               FORMAT A15 HEADING 'Customer|Phone Number'
COLUMN Total_Revenue_Last_30_Days   FORMAT  U9999.99  HEADING 'Total Revenue Generated|Last 30 Days'  




/*--- Read in the value of the last time entry in the data warehouse --- */
/*--- for a call event. This will be the dynamic baseline for the    --- */
/*--- timeframe of the query                                         --- */
drop table temp_date;
CREATE TABLE temp_date as
    SELECT MAX(call_event_date) as Max_Date FROM dw_dimtblDateTime;


/* --- Generate the upper and lower date ranges for report display   --- */
SELECT (Max_date) as Report_Start_Dt,((Max_date)-30) as Report_End_Dt from temp_date;

/*--- Select Customer Phone Number and Sum of Charges --- */
SELECT Customer_Phone, Total_Revenue_Last_30_Days

FROM
(
    /*--- Sub query SUMS the charge amounts in FACT Table --- */
    SELECT      a.phone_number as Customer_Phone, 
                SUM(c.call_event_charge) as Total_Revenue_Last_30_Days                                     
 
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
ORDER BY Total_Revenue_Last_30_Days DESC
fetch first 100 row only;