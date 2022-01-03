/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
                                                        - January 2022			*/

/* -- Create VIEWs to contain CASEID ID column, along with the predicted    --*/
/* -- label for churn and probability for churn for each row in the test    --*/
/* -- view data. These views will be used to generate Confusion Matrices    --*/
/* -- that will allow a comparison of the Naive Bayes and Decision Tree     --*/
/* -- models built for this Machine Learning predictive analysis problem    --*/

/*-- Prepare predictive results from the Naive Bayes model          -- */
CREATE OR REPLACE VIEW churn_class_nb_test_results
AS
SELECT CASEID,
   prediction(DEFAULT_NB_MODEL_CCHURN1 USING *) predicted_value,
   prediction_probability(DEFAULT_NB_MODEL_CCHURN1 USING *) probability
FROM CaseTestSample_ml_v;



/*-- Prepare predictive results from the Decision Tree model        -- */
CREATE OR REPLACE VIEW churn_class_dt_test_results
AS
SELECT CASEID,
   prediction(DECISION_TREE_MODEL_CCHURN1 USING *) predicted_value,
   prediction_probability(DECISION_TREE_MODEL_CCHURN1 USING *) probability
FROM CaseTestSample_ml_v;

