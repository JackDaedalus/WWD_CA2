/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/





/* SQL to populate the DIMENSION data warehouse tables for WWD CA2 */

/*	------------------------------------------------------  	*/
/*	Populate the CUSTOMER Dimension Tables							*/
/*	------------------------------------------------------  	*/

INSERT INTO dw_dimtblCustomer(Phone_Number)
    SELECT DISTINCT(PHONE_NUMBER) 
    FROM TBLCUSTOMERS;

select * FROM dw_dimtblCustomer;
select count(*) FROM dw_dimtblCustomer;

TRUNCATE TABLE dw_dimtblCustomer;

/*	------------------------------------------------------  	*/
/*	Populate the Call Event Dimension Tables							*/
/*	------------------------------------------------------  	*/

SELECT * FROM dw_dimtblCallEvent;


/*	------------------------------------------------------  	*/
/*	Populate the DATE Dimension Tables							*/
/*	------------------------------------------------------  	*/

SELECT * FROM dw_dimtblDateTime;