/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* SQL to populate the DIMENSION data warehouse tables for WWD CA2 */

/*	------------------------------------------------------  	*/
/*	Populate the CUSTOMER Dimension Tables							*/
/*	------------------------------------------------------  	*/

INSERT INTO dw_dimtblCustomer(Phone_Number,Plan_Desc,Plan_ID)
    SELECT 
        c.Phone_Number,
        p.name,
        p.id
    FROM TBLCUSTOMERS c, TBLCONTRACTPLANS p
    WHERE c.plan_id = p.id;


/* There is an erroneous duplication in the CUSTOMER Table
   Removing any duplicate phone entries to avoid future
   issues with populating FACT table or SQL queries             */
   
/* Delete the duplicate but keep one entry                      */
DELETE FROM dw_dimtblCustomer a
WHERE ROWID <
    (SELECT max(rowid)
     FROM dw_dimtblCustomer b
     WHERE a.Phone_Number = b.Phone_Number);


/*	------------------------------------------------------  	*/
/*	Populate the Call Event Dimension Tables							*/
/*	------------------------------------------------------  	*/

INSERT INTO dw_dimtblCallEvent(Connection_ID, Call_Event_Type, Call_Event_ID)
    
    SELECT 
        cs.connection_id,
        rt.name,
        rt.id
    FROM TBLCUSTOMERSERVICE cs, TBLRATETYPES rt
    WHERE cs.call_type_id = rt.id
    
    UNION

    SELECT 
        vm.connection_id,
        rt.name,
        rt.id
    FROM TBLVOICEMAILS vm, TBLRATETYPES rt
    WHERE vm.call_type_id = rt.id
    
    UNION

    SELECT  ctypes.connection_id, 
            rt.name,
            ctypes.call_type
        
        FROM (
        
        
            SELECT 
            
                calls.connection_id,
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
                    c.connection_id,
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
                                
                ) calls
                
                
        ) ctypes, TBLRATETYPES rt
        
        WHERE ctypes.call_type = rt.id;
        
  

/*	------------------------------------------------------  	*/
/*	Temp Test SQL to check DIM Values  						    */
/*	------------------------------------------------------  	*/

/*
select * 
FROM dw_dimtblCustomer
WHERE Phone_Number in ('046 046 7698','01 227 9959','01 112 1838');

select * 
FROM dw_dimtblCallEvent
WHERE call_event_type = 'roaming';
*/

select count(*) FROM dw_dimtblCustomer;
select count(*) FROM dw_dimtblCallEvent;

/*
TRUNCATE TABLE dw_dimtblCustomer;
TRUNCATE TABLE dw_dimtblCallEvent;*/