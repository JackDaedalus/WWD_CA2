    SELECT      a.phone_number              as Customer_Phone,
                a.Customer_Age              as Customer_Age,
                a.plan_id                   as Plan_ID,
                a.Social_Class              as Social_Class,
                max(b.Call_Event_Date)      as last_call,
                (trunc(to_date('29-APR-21')) - max(b.Call_Event_Date)) as Days_Since_Last_CallEvent,
                count(f.datetimekey)        as Total_Num_Calls,
                sum(f.call_event_charge)    as Call_Charge_Total,
                avg(f.call_event_charge)    as Call_Charge_Avg,
                sum(f.Call_Event_Duration)  as Call_Duration_Total,
                avg(f.Call_Event_Duration)  as Call_Duration_Avg,

                a.out_of_contract           as Churn_Indicator
 
    FROM        dw_facttblCallRevenue f,
                dw_dimtblCustomer a,
                dw_dimtblDateTime b,
                dw_dimtblCallEvent c
                
                
    WHERE       a.customerphonekey  = f.Customer_Key
    AND         b.datetimekey       = f.datetimekey
    AND         c.calleventkey      = f.callevent_key
    AND         a.phone_number in ('046 046 7698','066 425 0664','029 706 4631')
    
    GROUP BY    a.phone_number,
                a.Customer_Age,
                a.plan_id,
                a.Social_Class,
                a.out_of_contract;


select count(*) from dw_CaseMLChurn_tbl where out_of_contract = 'Y';
select count(*) from dw_CaseMLChurn_tbl where out_of_contract = 'N';

select max(Call_Event_Date) from dw_dimtblDateTime;