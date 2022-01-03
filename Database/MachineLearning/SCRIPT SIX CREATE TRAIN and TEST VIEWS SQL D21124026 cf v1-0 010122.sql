/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
														- January 2022			*/


/* SQL to populate the TRAIN and TEST tables for the ML Section of WWD CA2 */


/*-- CREATE A View for the Training Sample for the ML Analysis          --*/
/*-- This is an 80% random sample of the CASE Table generated in        --*/
/*-- Script Five. This view will be used ot train the ML model.         --*/
CREATE OR REPLACE VIEW CaseTrainSample_ml_v as
    select * from dw_CaseMLChurn_tbl sample (80) SEED (1000);

/*-- CREATE A View for the Test Sample for the ML Analysis              --*/
/*-- This code takes the remaining entries in the CASE table            --*/
/*-- and treats them as new data to apply and verify aginst             --*/
/*-- the model built with the Training sample                           --*/
CREATE OR REPLACE VIEW CaseTestSample_ml_v as
    Select * from dw_CaseMLChurn_tbl
    where caseid not in (
                        Select caseid 
                        from   CaseTrainSample_ml_v);  

