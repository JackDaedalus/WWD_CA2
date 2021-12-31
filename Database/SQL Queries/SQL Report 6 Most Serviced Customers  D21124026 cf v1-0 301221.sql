/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* --- SQL REPORT SIX : Customers Most Contacted by Customer Service    ---*/
/* --- This query can be correlated against other queries to show if    ---*/
/* --- Customer Service contact impacts on revenue and/or is influenced ---*/
/* --- by the social class of the customer                              ---*/


/*---           Add Title to SQL REPORT SIX Ouptut                    ---*/
TTITLE LEFT 'SQL REPORT SIX -  100 Most Contacted Customers in 2021 (YTD)' SKIP 1 


SET sqlformat ansiconsole;

/*---           Format Column Output of Report for Presentation       ---*/
COLUMN Customer_Phone     FORMAT A13 HEADING 'Customer|Phone Number'
COLUMN Social_Class       FORMAT A23 HEADING 'Customer|Socio-economic Group'
COLUMN TOTAL_ACTIVITY_YTD FORMAT A32 HEADING 'Total Customer Services Activity|With Customer(In Minutes)' 
---*/


/*-- Select Phone Number, Social Class and Sum of Duration for Customer -- */
/*--- Service Calls i Year To date - 2021                               -- */
SELECT Customer_Phone, Social_Class, Total_Activity_YTD

FROM
(
    /*--- Sub query SUMS the Duration amounts (+charge) in FACT Table --- */
    SELECT      a.phone_number as Customer_Phone, 
                a.Social_Class as Social_Class,
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
 
    GROUP BY    a.phone_number, a.Social_Class

)
/*--- Order and limit query to show Top 100 entries by Customer Service  ---*/
/*--- contact activity with the customers                               ---*/
ORDER BY Total_Activity_YTD DESC
fetch first 100 row only;