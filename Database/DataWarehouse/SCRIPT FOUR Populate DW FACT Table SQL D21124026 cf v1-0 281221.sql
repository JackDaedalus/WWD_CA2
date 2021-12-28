/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* SQL to populate the FACT data warehouse tables for WWD CA2 */



/*	------------------------------------------------------  	*/
/*	Populate the FACT Table						*/
/*	------------------------------------------------------  	*/


SELECT      
    ce.CallEventKey
FROM 
    dw_dimtblCallEvent ce,
    dw_dimtblCustomer c
WHERE
    c.phone_number = ce.
AND    c.phone_number In ('046 046 7698');

  
  
  
  
/* ---                                                              --- */
/* ---   Add Additional Calculated values to FACT Table   --- */
/* ---                                                              --- */

/*UPDATE dw_facttblCallRevenue
    SET Cost_Per_Minute 	= 0.49,
        Call_Event_Duration = 1.5,
        Call_Event_Charge 	= 0;




/*	------------------------------------------------------  	*/
/*	Temp Test SQL to check FACT Table Values  				*/
/*	------------------------------------------------------  	*/


/*select * FROM dw_facttblCallRevenue;*/

SELECT count(*) FROM dw_facttblCallRevenue;

/*TRUNCATE TABLE dw_facttblCallRevenue;*/