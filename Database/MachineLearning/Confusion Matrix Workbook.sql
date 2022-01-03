CREATE OR REPLACE VIEW churn_class_nb_test_results
AS
SELECT CASEID,
   prediction(DEFAULT_NB_MODEL_CCHURN1 USING *) predicted_value,
   prediction_probability(DEFAULT_NB_MODEL_CCHURN1 USING *) probability
FROM CaseTestSample_ml_v;



SELECT * 
FROM churn_class_nb_test_results;


DECLARE
   v_accuracy NUMBER;
BEGIN
    DBMS_DATA_MINING.COMPUTE_CONFUSION_MATRIX (
       accuracy => v_accuracy,
       apply_result_table_name => 'churn_class_nb_test_results',
       target_table_name => 'CaseTestSample_ml_v',
       case_id_column_name => 'CASEID',
       target_column_name => 'OUT_OF_CONTRACT',
       confusion_matrix_table_name => 'churn_class_nb_confusion_matrix',
       score_column_name => 'PREDICTED_VALUE',
       score_criterion_column_name => 'PROBABILITY',
       cost_matrix_table_name => null,
       apply_result_schema_name => null,
       target_schema_name => null,
       cost_matrix_schema_name => null,
       score_criterion_type => 'PROBABILITY');
       DBMS_OUTPUT.PUT_LINE('**** MODEL ACCURACY ****: ' || ROUND(v_accuracy,4));
END;


SELECT *
FROM churn_class_nb_confusion_matrix;
