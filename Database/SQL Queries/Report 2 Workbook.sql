/* Report 2 */
SET sqlformat ansiconsole;
/* Contract Plan Peformance in March 21*/


CREATE TABLE rev_month AS

    SELECT Contract_Desc, Total_Revenue_For_Month as Monthly_Revenue, Rev_Month
    
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
        AND         b.Month_of_Year_Num in (1,2,3,4)
     
        GROUP BY    a.plan_desc, a.plan_id, b.Month_of_Year_Num
    
    )
    /*--- Order query to show contract plans in alphabetical order ---*/
    ORDER BY Contract_Desc DESC;
    

select * from rev_month;


COLUMN CONTRACT_DESC              FORMAT A13 HEADING 'Contract Plan|Description' 
COLUMN January                    FORMAT A13 HEADING 'January|Revenue (€)' 
COLUMN February                   FORMAT A13 HEADING 'February|Revenue (€)' 
COLUMN March                      FORMAT A13 HEADING 'March|Revenue (€)' 
COLUMN April                      FORMAT A13 HEADING 'April|Revenue (€)' 

/*select CONTRACT_DESC as Cont from rev_month*/
select * from rev_month
PIVOT (
    sum(MONTHLY_REVENUE) for REV_MONTH in (1 "January",2 "February",3 "March",4 "April")
    )
order by CONTRACT_DESC;    



DROP TABLE rev_month;
    
