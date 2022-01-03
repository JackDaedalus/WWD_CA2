/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
                                                        - January 2022			*/

/* --- SQL REPORT FIVE  : Contract Plan Moving Average Revenue YTD  */

/*--- Set up a temporary table to capture the data warehouse contract ---*/
/*--- plan data for the last four months (the complete data range)    ---*/
CREATE TABLE plan_rev_per_month AS

    /*--- Select Contract Plan Description and Sum of Charges --- */
    SELECT  Contract_Desc, 
            Total_Revenue_For_Month as Monthly_Revenue, 
            Rev_Month
    
    FROM
    (
        /*--- Sub query SUMS the charge amounts in FACT Table for each --- */
        /*--- Contract Plan by a query joining the Dimension Tables    --- */
        SELECT      a.plan_desc as Contract_Desc, 
                    a.plan_id as Contract_Plan_ID,
                    b.Month_of_Year_Num as Rev_Month,
                    SUM(c.call_event_charge) as Total_Revenue_For_Month                                     
     
        FROM        dw_dimtblCustomer a,
                    dw_dimtblDateTime b,
                    dw_facttblCallRevenue c
                    
        WHERE       a.customerphonekey  = c.Customer_Key
        AND         b.datetimekey       = c.datetimekey
     
        GROUP BY    a.plan_desc, a.plan_id, b.Month_of_Year_Num
    
    )
    /*--- Order query to show contract plans in alphabetical order ---*/
    ORDER BY Contract_Desc DESC;


/*---           Add Title to SQL REPORT FIVE Ouptut                    ---*/
TTITLE LEFT 'SQL REPORT FIVE -  TELCO Plans Moving Average Revenue YTD' SKIP 1 

/*---           Format Column Output of Report for Presentation       ---*/
SET sqlformat ansiconsole;
/*--- Format Columns for output  ---*/
COLUMN CONTRACT_DESC          FORMAT A13 HEADING 'Contract Plan|Description' 
COLUMN rev_month              FORMAT A8  HEADING 'Month|In Year'  
COLUMN monthly_revenue        FORMAT A13 HEADING 'Revenue That|Month (€)' 
COLUMN Plan_Moving_Avg        FORMAT A25 HEADING 'Trend: Moving Monthly|Average-Per Plan(€)'


/*---  Moving Averages are based on the change in monthly revenue from  ---*/
/*---  the contract plans across all customer accounts. The revenue     ---*/
/*---  for each month is a summation across all contract plans          ---*/

/*---  Moving Average Report Table for STANDARD Contract Plan       ---*/
SELECT Contract_Desc, rev_month, monthly_revenue, AVG(monthly_revenue)
OVER (ORDER BY rev_month, monthly_revenue ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) 
                                                                AS Plan_Moving_Avg
FROM plan_rev_per_month
WHERE Contract_Desc = ('standard')
ORDER BY rev_month;

/*---  Moving Average Report Table for OFF-PEAK Contract Plan       ---*/
SELECT Contract_Desc, rev_month, monthly_revenue, AVG(monthly_revenue)
OVER (ORDER BY rev_month, monthly_revenue ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) 
                                                                AS Plan_Moving_Avg
FROM plan_rev_per_month
WHERE Contract_Desc = ('off peak')
ORDER BY rev_month;

/*---  Moving Average Report Table for COSMOPOLITAN Contract Plan       ---*/
SELECT Contract_Desc, rev_month, monthly_revenue, AVG(monthly_revenue)
OVER (ORDER BY rev_month, monthly_revenue ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) 
                                                                AS Plan_Moving_Avg
FROM plan_rev_per_month
WHERE Contract_Desc = ('cosmopolitan')
ORDER BY rev_month;


/*--- Remove temporary report table --*/
DROP TABLE plan_rev_per_month;
