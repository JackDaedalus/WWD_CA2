/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
														- January 2022			*/


/* SQL to populate the Date TIME DIMENSION data warehouse tables for WWD CA2 */



/*	------------------------------------------------------  	*/
/*	Populate the Date Time Dimension Table						*/
/*	------------------------------------------------------  	*/

/* ---                                                              --- */
/* ---   Add Time records from  Calls                               --- */
/* ---                                                              --- */
INSERT INTO dw_dimtblDateTime(CalendarDate, Tbl_Source)
    
        SELECT      
            c.call_time,
            'Calls' as Source_Tbl
        FROM TBLCALLS c, dw_dimtblCallEvent ce
        WHERE c.connection_id = ce.connection_id;
        
        
/* ---                                                              --- */
/* ---   Add Time records from Voicemails                           --- */
/* ---                                                              --- */        
INSERT INTO dw_dimtblDateTime(CalendarDate, Tbl_Source)

        SELECT      
            vm.call_time,
            'Voicemails' as Source_Tbl
        FROM TBLVOICEMAILS vm, dw_dimtblCallEvent ce
        WHERE vm.connection_id = ce.connection_id;


/* ---                                                              --- */
/* ---   Add Time records from Customer Service Calls               --- */
/* ---                                                              --- */
INSERT INTO dw_dimtblDateTime(CalendarDate, Tbl_Source)

        SELECT      
            cs.call_time,
            'CS' as Source_Tbl
        FROM TBLCUSTOMERSERVICE cs, dw_dimtblCallEvent ce
        WHERE cs.connection_id = ce.connection_id;
  
  
  
  
/* ---                                                              --- */
/* ---   Add Additional Date formats to Time Date Dimension Table   --- */
/* ---                                                              --- */

UPDATE dw_dimtblDateTime
    SET Call_Event_Date     = TO_DATE(SUBSTR(CalendarDate,1,8), 'DD-MM-YY'),
        Call_TStamp         = TO_TIMESTAMP(CalendarDate,'DD-MM-YY HH24:MI'),
        Day_of_Week_Num     = TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(CalendarDate,1,8), 'DD-MM-YY'), 'D','NLS_DATE_LANGUAGE = ENGLISH') , 9);
        
UPDATE dw_dimtblDateTime
    SET Month_of_Year_Num   = EXTRACT(month FROM CALL_EVENT_DATE);




/*	------------------------------------------------------  	*/
/*	Temp Test SQL to check Date Time DIM Values  				*/
/*	------------------------------------------------------  	*/

SELECT count(*) FROM dw_dimtblDateTime;

