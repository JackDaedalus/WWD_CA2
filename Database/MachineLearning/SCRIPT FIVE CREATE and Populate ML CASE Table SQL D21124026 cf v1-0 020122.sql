/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* SQL to populate the CASE table for the ML Section of WWD CA2 */


/*	------------------------------------------------------  	*/

/*	                Create the ML CASE Table     	            */
/*	Capture customer Profile/Revenue/Activity measurements      */

/*	------------------------------------------------------  	*/
drop TABLE dw_CaseMLChurn_tbl;


CREATE TABLE dw_CaseMLChurn_tbl(
    CaseID              NUMBER GENERATED ALWAYS as IDENTITY(START with 1000 INCREMENT by 1 NOCACHE) NOT NULL,
    phone_number        VARCHAR2(26 CHAR) NOT NULL,
    customer_age        INTEGER NOT NULL,
    plan_id             INTEGER NOT NULL,
    social_class        VARCHAR2(26 CHAR) NOT NULL,
    total_num_calls     INTEGER,
    call_revenue_total  NUMBER(20, 2),
    call_charge_avg     NUMBER(20, 2),
    call_duration_total NUMBER(38, 7),
    call_duration_avg   NUMBER(38, 7),
    days_since_last_callevent INTEGER,
    out_of_contract     VARCHAR2(1 CHAR),
    PRIMARY KEY (CaseID)
);


/*	------------------------------------------------------  	*/
/*	Populate the CASE Table						*/
/*	------------------------------------------------------  	*/

INSERT INTO dw_CaseMLChurn_tbl 
        (Phone_Number, 
         customer_age, 
         plan_id,
         social_class,
         total_num_calls,
         call_revenue_total,
         call_charge_avg,
         call_duration_total,
         call_duration_avg,
         days_since_last_callevent,
         out_of_contract)

/*-- Joining the FACT and DIMENSION Tables to collect customer specific  --*/
/*-- data to prepare the Case table for use in ML modelling              --*/

    SELECT      a.phone_number              as Customer_Phone,
                a.Customer_Age              as Customer_Age,
                a.plan_id                   as Plan_ID,
                a.Social_Class              as Social_Class,
                count(f.datetimekey)        as Total_Num_Calls,
                sum(f.call_event_charge)    as Call_Charge_Total,
                avg(f.call_event_charge)    as Call_Charge_Avg,
                sum(f.Call_Event_Duration)  as Call_Duration_Total,
                avg(f.Call_Event_Duration)  as Call_Duration_Avg,
                /*-- The data warehouse call records end on 29th April 2021  --*
                /*-- Hence this date is set as the last active day           --*/
                (trunc(to_date('29-APR-21')) - max(b.Call_Event_Date)) as Days_Since_Last_CallEvent,
                a.out_of_contract           as Churn_Indicator
 
    FROM        dw_facttblCallRevenue   f,
                dw_dimtblCustomer       a,
                dw_dimtblDateTime       b,
                dw_dimtblCallEvent      c
                
                
    WHERE       a.customerphonekey  = f.Customer_Key
    AND         b.datetimekey       = f.datetimekey
    AND         c.calleventkey      = f.callevent_key
    
    GROUP BY    a.phone_number,
                a.Customer_Age,
                a.plan_id,
                a.Social_Class,
                a.out_of_contract;


/*	------------------------------------------------------  	*/
/*	Temp Test SQL to check FACT Table Values  				*/
/*	------------------------------------------------------  	*/
/*
SELECT * FROM dw_CaseMLChurn_tbl;


SELECT count(*) FROM dw_CaseMLChurn_tbl;
*/

