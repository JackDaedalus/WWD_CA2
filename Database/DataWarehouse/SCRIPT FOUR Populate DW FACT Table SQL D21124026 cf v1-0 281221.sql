/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* SQL to populate the FACT data warehouse tables for WWD CA2 */

/*---   Temp Table to build up FACT Info  --- */
DROP TABLE stage_FACT_Tbl;


CREATE TABLE stage_FACT_Tbl(
    FactID         	NUMBER GENERATED ALWAYS as IDENTITY(START with 1000 INCREMENT by 1 NOCACHE) NOT NULL,
    Connection_ID   VARCHAR2(128),
    Phone_Number    VARCHAR2(26),
    Call_Time       VARCHAR2(26),
    Rate_Name       VARCHAR2(26),
    DateTimeKey     INT NULL,   
    Customer_Key    INT NULL,
    CallEvent_Key   INT NULL,
    Call_Event_Duration NUMBER(38,7),
    PRIMARY KEY (FactID)
);



/*	------------------------------------------------------  	*/
/*	Populate the FACT Table						*/
/*	------------------------------------------------------  	*/

INSERT INTO stage_FACT_Tbl 
        (Connection_ID, 
         Phone_Number, 
         Call_Time, 
         Call_Event_Duration,
         Rate_Name)
    
    SELECT 
        cs.connection_id,
        cs.phone_number,
        cs.call_time,
        cs.duration,
        rt.name
    FROM TBLCUSTOMERSERVICE cs, TBLRATETYPES rt
    WHERE cs.call_type_id = rt.id
    AND cs.phone_number in ('046 046 7698','066 425 0664','029 706 4631')
    
    UNION

    SELECT 
        vm.connection_id,
        vm.phone_number,
        vm.call_time,
        vm.duration,
        rt.name
    FROM TBLVOICEMAILS vm, TBLRATETYPES rt
    WHERE vm.call_type_id = rt.id
    AND vm.phone_number in ('046 046 7698','066 425 0664','029 706 4631')
    
    UNION

    SELECT  ctypes.connection_id,
            ctypes.phone_number,
            ctypes.call_time,
            ctypes.duration,
            rt.name
        
        FROM (
        
        
            SELECT 
            
                calls.connection_id,
                calls.phone_number,
                calls.call_time,
                calls.duration,
                /* Set Call Type based on Codes for Peak / Off Peak / Roaming / International */
                CASE    WHEN (Peak_Call = 1) THEN 
                            CASE
                        
                                WHEN (Int_Call = 3) THEN 3
                                WHEN (Roam_Call = 4) THEN 4
                                ELSE 1 
                             
                            END
                             
                        WHEN (Peak_Call = 2) THEN 
                            CASE
                        
                                WHEN (Int_Call = 3) THEN 3
                                WHEN (Roam_Call = 4) THEN 4
                                ELSE 2 
                             
                            END
                            
                        else null
                END    as Call_Type                     
                
            FROM (
            
                SELECT 
                    c.phone_number,
                    c.call_time,
                    c.connection_id,
                    c.duration,
                    /* Peak Calls are 9:00 - 18:00 on weekdays - Off Peak Otherwise*/
                    CASE WHEN (
                        (EXTRACT(HOUR FROM (TO_TIMESTAMP(c.Call_Time,'DD-MM-YY HH24:MI'))) > 8.59)
                        AND
                        (EXTRACT(HOUR FROM (TO_TIMESTAMP(c.Call_Time,'DD-MM-YY HH24:MI'))) < 18.00)
                         AND
                        ( (TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(c.Call_Time,1,8), 'DD-MM-YY'), 'D','NLS_DATE_LANGUAGE = ENGLISH') , 9)) < 6)
                        )  
                                                                                    THEN 1 ELSE 2 END Peak_Call,
                    /* Convert FALSE/TRUE flags for Roaming and International calls to Call Type Id Codes  */                                                                
                    CASE WHEN (c.Is_International = 'FALSE') THEN 0 ELSE 3 END   Int_Call,
                    CASE WHEN (c.Is_Roaming       = 'FALSE') THEN 0 ELSE 4 END   Roam_Call
                FROM TBLCALLS c
                WHERE c.phone_number in ('046 046 7698','066 425 0664','029 706 4631')
                                
                ) calls
                
                
        ) ctypes, TBLRATETYPES rt
        
        WHERE ctypes.call_type = rt.id;
        
  
/* ---                                                              --- */
/* ---   Add DIM Table values to Staging FACT Table                 --- */
/* ---                                                              --- */

/* ---  Call Event Foregign Keys                                    --- */

UPDATE stage_FACT_Tbl a
SET a.CallEvent_Key = 
    (SELECT b.CallEventKey 
     FROM dw_dimtblCallEvent b
     WHERE b.Connection_ID = a.Connection_ID)
WHERE EXISTS 
    (SELECT * FROM dw_dimtblCallEvent b
     WHERE b.Connection_ID = a.Connection_ID);



/* ---  Phone Number Foregign Keys                                    --- */

UPDATE stage_FACT_Tbl a
SET a.Customer_Key = 
    (SELECT b.CustomerPhoneKey 
     FROM dw_dimtblCustomer b
     WHERE b.Phone_Number = a.Phone_Number)
WHERE EXISTS 
    (SELECT * FROM dw_dimtblCustomer b
     WHERE b.Phone_Number = a.Phone_Number);
  


/* ---  Date Foregign Keys                                    --- */

UPDATE stage_FACT_Tbl a
SET a.DateTimeKey = 
    (SELECT b.DateTimeKey 
     FROM dw_dimtblDateTime b
     WHERE b.CalendarDate = a.Call_Time
     ORDER BY b.DateTimeKey
     fetch first 1 row only)
WHERE EXISTS 
    (SELECT * FROM dw_dimtblDateTime b
     WHERE b.CalendarDate = a.Call_Time);  
  
  

/* ---                                                              --- */
/* ---   INSERT Values from Staging table into FACT Table           --- */
/* ---                                                              --- */
INSERT INTO dw_facttblCallRevenue 
        (DateTimeKey, 
         Customer_Key, 
         CallEvent_Key,
         Call_Event_Duration)
         
     SELECT     DateTimeKey, 
                Customer_Key, 
                CallEvent_Key,
                Call_Event_Duration
     FROM stage_FACT_Tbl; 


  
/* ---                                                              --- */
/* ---   Add Additional Calculated values to FACT Table   --- */
/* ---                                                              --- */

UPDATE dw_facttblCallRevenue a
SET a.Cost_Per_Minute = 
    (SELECT b.Cost_Per_Minute 
     FROM TBLCALLRATES b, 
        dw_dimtblCallEvent c, 
        dw_dimtblCustomer d
     WHERE b.call_type_id      = c.call_event_id
        AND     b.plan_id           = d.plan_id
        AND     c.calleventkey      = a.CallEvent_Key
        AND     d.customerphonekey  = a.Customer_Key
     )
WHERE EXISTS 
    (SELECT * FROM TBLCALLRATES b, 
        dw_dimtblCallEvent c, 
        dw_dimtblCustomer d
     WHERE b.call_type_id      = c.call_event_id
        AND     b.plan_id           = d.plan_id
        AND     c.calleventkey      = a.CallEvent_Key
        AND     d.customerphonekey  = a.Customer_Key
        );



/*	------------------------------------------------------  	*/
/*	Temp Test SQL to check FACT Table Values  				*/
/*	------------------------------------------------------  	*/




SELECT count(*) FROM stage_FACT_Tbl;
SELECT count(*) FROM dw_facttblCallRevenue;

/*
select Connection_ID, CALLEVENT_KEY FROM stage_FACT_Tbl order by connection_id;
select Phone_Number, Customer_Key FROM stage_FACT_Tbl order by Phone_Number;
select Call_Time, DateTimeKey FROM stage_FACT_Tbl order by Call_Time;


select DateTimeKey, Customer_Key, CallEvent_Key 
FROM stage_FACT_Tbl 
order by DateTimeKey;
*/

select FactID, DateTimeKey, Customer_Key, CallEvent_Key, 
    Call_Event_Duration, 
    Cost_Per_Minute
FROM dw_facttblCallRevenue 
order by DateTimeKey
fetch first 25 row only;

/*TRUNCATE TABLE dw_facttblCallRevenue;*/
TRUNCATE TABLE stage_FACT_Tbl;