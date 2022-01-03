/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/


/* SQL to compute the Confusion Matrix fron the Decision Tree model when applied  */
/* to the customer churn Machine Learning predicitve analysis requirement		*/
SET SERVEROUTPUT ON

/* -- Use ORACLE COMPUTE_CONFUSION_MATRIX function, taking the input of the VIEW   	--*/
/*--  created based on the predictive analysis of the DT model against the Test 	--*/
/*--  dataset extracted from the CASE table				--*/
DROP TABLE churn_class_dt_confusion_matrix;

DECLARE
   v_accuracy NUMBER;
BEGIN
    DBMS_DATA_MINING.COMPUTE_CONFUSION_MATRIX (
       accuracy => v_accuracy,
       apply_result_table_name => 'churn_class_dt_test_results',
       target_table_name => 'CaseTestSample_ml_v',
       case_id_column_name => 'CASEID',
       target_column_name => 'OUT_OF_CONTRACT',
       confusion_matrix_table_name => 'churn_class_dt_confusion_matrix',
       score_column_name => 'PREDICTED_VALUE',
       score_criterion_column_name => 'PROBABILITY',
       cost_matrix_table_name => null,
       apply_result_schema_name => null,
       target_schema_name => null,
       cost_matrix_schema_name => null,
       score_criterion_type => 'PROBABILITY');
       DBMS_OUTPUT.PUT_LINE('**** MODEL ACCURACY ****: ' || ROUND(v_accuracy,4));
END;