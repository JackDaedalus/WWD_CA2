/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* SQL to populate the CASE table for the ML Section of WWD CA2 */


CREATE VIEW CaseTrainSample_ml_tbl as
    select * from dw_CaseMLChurn_tbl sample (80) SEED (1000);


CREATE VIEW CaseTestSample_ml_tbl as
    Select * from dw_CaseMLChurn_tbl
    where caseid not in (
                        Select caseid 
                        from   CaseTrainSample_ml_tbl);  






select count(*) from dw_CaseMLChurn_tbl where out_of_contract = 'N';
select count(*) from dw_CaseMLChurn_tbl where out_of_contract = 'Y';


select count(*) from  CaseTrainSample_ml_tbl where out_of_contract = 'N';
select count(*) from  CaseTrainSample_ml_tbl where out_of_contract = 'Y';


select count(*) from  CaseTestSample_ml_tbl where out_of_contract = 'N';
select count(*) from  CaseTestSample_ml_tbl where out_of_contract = 'Y';




select count(*) from  CaseTrainSample_ml_tbl;
select count(*) from  CaseTestSample_ml_tbl;



select * from CaseTestSample_ml_tbl;

DROP VIEW CaseTestSample_ml_tbl;
DROP VIEW CaseTrainSample_ml_tbl;
