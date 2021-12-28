    SELECT 
        c.phone_number,
        /*c.connection_id,*/
        c.Call_Time,
        SUBSTR(c.Call_Time,1,8) Substr_date,
        TO_DATE(SUBSTR(c.Call_Time,1,8), 'DD-MM-YY') Call_Date,
        TO_CHAR(TO_DATE(SUBSTR(c.Call_Time,1,8), 'DD-MM-YY'), 'D','NLS_DATE_LANGUAGE = ENGLISH') Day_week,
        TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(c.Call_Time,1,8), 'DD-MM-YY'), 'D','NLS_DATE_LANGUAGE = ENGLISH') , 9) Day_week_Number,

        CASE WHEN (
            (EXTRACT(HOUR FROM (TO_TIMESTAMP(c.Call_Time,'DD-MM-YY HH24:MI'))) > 8.59)
            AND
            (EXTRACT(HOUR FROM (TO_TIMESTAMP(c.Call_Time,'DD-MM-YY HH24:MI'))) < 18.00)
            AND
            ( (TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(c.Call_Time,1,8), 'DD-MM-YY'), 'D','NLS_DATE_LANGUAGE = ENGLISH') , 9)) < 6)
            ) 
                                                                        THEN 1 ELSE 2 END Peak_Call,
        CASE WHEN (c.Is_International = 'FALSE') THEN 0 ELSE 3 END   Int_Call,
        CASE WHEN (c.Is_Roaming       = 'FALSE') THEN 0 ELSE 4 END   Roam_Call
    FROM TBLCALLS c
    WHERE c.phone_number in ('046 046 7698')
    
    
    
        /*TO_DATE(SUBSTR(c.Call_Time,1,8), 'DD-MM-YY'), 'D','NLS_DATE_LANGUAGE = ENGLISH')) Day_week_Number,
        TO_CHAR(date '1982-03-09', 'D', 'NLS_DATE_LANGUAGE = ENGLISH') Day_Num,
        TO_CHAR(date '1982-03-09', 'Dy') Day_of_Week,*/    