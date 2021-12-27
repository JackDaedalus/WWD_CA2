/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/





/* SQL to create the data warehouse Dimension tables for WWD CA2 */


DROP TABLE dw_facttblCallRevenue;
DROP TABLE dw_dimtblDateTime;
DROP TABLE dw_dimtblCustomer;
DROP TABLE dw_dimtblCallEvent;




/*	------------------------------------------------------  	*/

/*	Create the Dimension Tables							    */

/*	------------------------------------------------------  	*/

--Create Customer Dimensions
CREATE TABLE dw_dimtblCustomer(
CustomerPhoneKey  NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1 NOCACHE) NOT NULL,
Phone_Number  VARCHAR2(26) NOT NULL,
PRIMARY KEY (CustomerPhoneKey)
);

--Create Call Event Dimensions
CREATE TABLE dw_dimtblCallEvent(
CallEventKey  INT NOT NULL,
Connection_ID VARCHAR2(128) NOT NULL,
PRIMARY KEY (CallEventKey)
);

--Create Date Dimensions
CREATE TABLE dw_dimtblDateTime(
DateTimeKey  INT NOT NULL,
CalendarDate  DATE NOT NULL,
PRIMARY KEY (DateTimeKey)
);



/*	------------------------------------------------------  	*/

/*	Create the Fact Table - to capture Revenue/Charge measurements	    */

/*	------------------------------------------------------  	*/



CREATE TABLE dw_facttblCallRevenue(
    FactID          NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    DateTimeKey     INT NOT NULL,   
    Customer_Key    INT NOT NULL,
    CallEvent_Key   INT NOT NULL,
    CONSTRAINT timedate_fk FOREIGN KEY (DateTimeKey) 
        REFERENCES dw_dimtblDateTime(DateTimeKey), 
    CONSTRAINT customer_fk FOREIGN KEY (Customer_Key) 
        REFERENCES dw_dimtblCustomer(CustomerPhoneKey),
    CONSTRAINT callevent_fk FOREIGN KEY (CallEvent_Key) 
        REFERENCES dw_dimtblCallEvent(CallEventKey), 
    PRIMARY KEY (FactID)
);

