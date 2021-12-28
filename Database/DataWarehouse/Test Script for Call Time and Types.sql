
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
    WHERE c.phone_number in ('046 046 7698','066 425 0664')
    
    ) calls;
