/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/

/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
                                                        - January 2022			*/

/* --- SQL REPORT TWO  : Contract Plan Peformance - By Month/Revenue   */

/*---           Add Title to SQL REPORT ONE Ouptut                    ---*/
TTITLE LEFT 'SQL REPORT TWO -  Contract Plan Peformance - By Month/Revenue' SKIP 1 

/*--- Set up a VIEW to capture the data warehouse contract ---*/
/*--- plan date for the last four months (the complete data range)    ---*/
CREATE OR REPLACE VIEW plan_rev_per_month_v AS

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
        AND         b.Month_of_Year_Num in (1,2,3,4) /*-- All four months in 
                                                            data warehouse ---*/
     
        GROUP BY    a.plan_desc, a.plan_id, b.Month_of_Year_Num
    
    )
    /*--- Order query to show contract plans in alphabetical order ---*/
    ORDER BY Contract_Desc DESC;


/*---           Format Column Output of Report for Presentation       ---*/

/*--- Format Columns for output  ---*/
COLUMN CONTRACT_DESC              FORMAT A13 HEADING 'Contract Plan|Description' 
COLUMN January                    FORMAT A13 HEADING 'January|Revenue (€)' 
COLUMN February                   FORMAT A13 HEADING 'February|Revenue (€)' 
COLUMN March                      FORMAT A13 HEADING 'March|Revenue (€)' 
COLUMN April                      FORMAT A13 HEADING 'April|Revenue (€)' 


/*--- The PIVOT function inverts the columns/rows into the format required ---*/
/*--- for the Contract Plan Revenue Report.  The PIVOT function avoids the ---*/
/*--- for more complex joins or unions to present the revenue data         ---*/

select * from plan_rev_per_month_v /*-- Use temp table for report presentation --*/
PIVOT (
    sum(MONTHLY_REVENUE) for REV_MONTH in (1 "January",2 "February",3 "March",4 "April")
    )
order by CONTRACT_DESC;    


