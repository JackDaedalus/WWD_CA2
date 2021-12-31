/* Top 20 customers from last month */

/*Show Revenue Trends for last Three Months */
DROP TABLE Customer_Revenue_Profile;
DROP TABLE Customer_Revenue_Profile_Report;


CREATE TABLE Customer_Revenue_Profile AS

    SELECT      a.phone_number as Customer_Phone, 
                SUM(c.call_event_charge) as Monthly_Revenue,
                b.Month_of_Year_Num as Month_Number
     
    FROM        dw_dimtblCustomer a,
                dw_dimtblDateTime b,
                dw_facttblCallRevenue c
                    
    WHERE       a.customerphonekey  = c.Customer_Key
    AND         b.datetimekey       = c.datetimekey
    AND         b.Month_of_Year_Num in (1,2,3,4) /*-- Precceding Three Months data ---*/
    AND         a.phone_number      IN
                (
                /*--- Select Customer Phone Number based on Sum of Charges in April--- */
                SELECT Cust_Number
                
                FROM
                (
                    /*--- Sub query SUMS the charge amounts in FACT Table --- */
                    SELECT      d.phone_number as Cust_Number, 
                                SUM(f.call_event_charge) as Total_Revenue_April                                     
                 
                    FROM        dw_dimtblCustomer d,
                                dw_dimtblDateTime e,
                                dw_facttblCallRevenue f
                                
                    WHERE       d.customerphonekey  = f.Customer_Key
                    AND         e.datetimekey       = f.datetimekey
                    AND         e.Month_of_Year_Num in (4) /*-- Last Month (April) ---*/
                 
                    GROUP BY    d.phone_number
                
                )
                /*--- Order query to show Top 20 customers by customer charge ---*/
                ORDER BY Total_Revenue_April DESC
                fetch first 20 row only
                )
    GROUP BY a.phone_number, b.Month_of_Year_Num
    ORDER BY a.phone_number DESC, b.Month_of_Year_Num ASC;            



CREATE TABLE Customer_Revenue_Profile_Report AS

    select * from Customer_Revenue_Profile /*-- Use temp table for report presentation --*/
    PIVOT (
        sum(MONTHLY_REVENUE) for Month_Number in (1 "January",2 "February",3 "March",4 "April")
        )
    order by CUSTOMER_PHONE; 

COMMIT WORK;




ALTER TABLE
    Customer_Revenue_Profile_Report
ADD
    YTD_Revenue	NUMBER(20,2);
  

    
UPDATE Customer_Revenue_Profile_Report
SET YTD_Revenue = (Customer_Revenue_Profile_Report."January"
                   + Customer_Revenue_Profile_Report."February"
                   + Customer_Revenue_Profile_Report."March"
                   + Customer_Revenue_Profile_Report."April");


SELECT * FROM Customer_Revenue_Profile_Report
ORDER BY ytd_revenue DESC;


/*
DROP TABLE Customer_Revenue_Profile;
DROP TABLE Customer_Revenue_Profile_Report;
*/