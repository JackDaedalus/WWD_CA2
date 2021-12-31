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
    CustomerPhoneKey  NUMBER GENERATED ALWAYS as IDENTITY(START with 1000 INCREMENT by 1 NOCACHE) NOT NULL,
    Phone_Number      VARCHAR2(26) NOT NULL,
    Plan_Desc         VARCHAR2(15) NOT NULL,
    Plan_ID           NUMBER(38,0),
    Social_Class      VARCHAR(26),
    PRIMARY KEY (CustomerPhoneKey)
);

--Create Call Event Dimensions
CREATE TABLE dw_dimtblCallEvent(
    CallEventKey    NUMBER GENERATED ALWAYS as IDENTITY(START with 1000 INCREMENT by 1 NOCACHE) NOT NULL,
    Connection_ID   VARCHAR2(128) NOT NULL,
    Call_Event_Type VARCHAR2(25) NOT NULL,
    Call_Event_ID   NUMBER(38,0),
    PRIMARY KEY (CallEventKey)
);

--Create Date Dimensions
CREATE TABLE dw_dimtblDateTime(
    DateTimeKey         NUMBER GENERATED ALWAYS as IDENTITY(START with 1000 INCREMENT by 1 NOCACHE) NOT NULL,
    CalendarDate        VARCHAR2(26) NOT NULL,
    Call_Event_Date     Date NULL,
    Call_TStamp         Timestamp NULL,
    Month_of_Year_Num   INT NULL,
    Day_of_Week_Num     INT NULL,
    Tbl_Source          VARCHAR2(26) NULL,
    PRIMARY KEY (DateTimeKey)
);



/*	------------------------------------------------------  	*/

/*	Create the Fact Table - to capture Revenue/Charge measurements	    */

/*	------------------------------------------------------  	*/



CREATE TABLE dw_facttblCallRevenue(
    FactID          	NUMBER GENERATED ALWAYS as IDENTITY(START with 1000 INCREMENT by 1 NOCACHE) NOT NULL,
    DateTimeKey     	INT NOT NULL,   
    Customer_Key    	INT NOT NULL,
    CallEvent_Key   	INT NOT NULL,
	Cost_Per_Minute		NUMBER(4,2),
	Call_Event_Duration NUMBER(38,7),
	Call_Event_Charge	NUMBER(20,2),
    CONSTRAINT timedate_fk FOREIGN KEY (DateTimeKey) 
        REFERENCES dw_dimtblDateTime(DateTimeKey), 
    CONSTRAINT customer_fk FOREIGN KEY (Customer_Key) 
        REFERENCES dw_dimtblCustomer(CustomerPhoneKey),
    CONSTRAINT callevent_fk FOREIGN KEY (CallEvent_Key) 
        REFERENCES dw_dimtblCallEvent(CallEventKey), 
    PRIMARY KEY (FactID)
);

