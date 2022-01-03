/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two - January 2022			*/

SET sqlformat ansiconsole;

/*---           Add Title to Confusion Matrices Report                    ---*/
TTITLE LEFT 'Confusion Matrices to Compare Models' Skip 1 

COLUMN ACTUAL_TARGET_VALUE     FORMAT A15 HEADING 'NB Actual Churn' 
COLUMN PREDICTED_TARGET_VALUE  FORMAT A18 HEADING 'NB Predicted Churn' 
COLUMN VALUE                   FORMAT A5 HEADING 'Count' 

/* SQL to display the results from both the NB and DT Confusion Matrices  */


/* -- Show Performance of NB Model  --*/
SELECT *
FROM churn_class_nb_confusion_matrix;

CREATE OR REPLACE VIEW nb_model_accuracy AS
    SELECT 
        (
         SELECT sum(Value)
         FROM churn_class_nb_confusion_matrix
         WHERE (Actual_Target_value = 'N' AND Predicted_Target_value = 'N')
         OR (Actual_Target_value = 'Y' AND Predicted_Target_value = 'Y')
         ) as True_Values,
         
                  
         (SELECT sum(Value)
         FROM churn_class_nb_confusion_matrix
         ) as Total_Values
         
       
    FROM churn_class_nb_confusion_matrix
    fetch first 1 row only;
    


COLUMN NB_Accuracy      FORMAT A17 HEADING 'NB Model Accuracy' 

Select round(True_Values/Total_Values * 100, 2) || '%' as NB_Accuracy
from nb_model_accuracy;



/* -- Show Performance of DT Model  --*/
SELECT *
FROM churn_class_dt_confusion_matrix;

CREATE OR REPLACE VIEW dt_model_accuracy AS
    SELECT 
        (
         SELECT sum(Value)
         FROM churn_class_dt_confusion_matrix
         WHERE (Actual_Target_value = 'N' AND Predicted_Target_value = 'N')
         OR (Actual_Target_value = 'Y' AND Predicted_Target_value = 'Y')
         ) as True_Values,
         
                  
         (SELECT sum(Value)
         FROM churn_class_dt_confusion_matrix
         ) as Total_Values
         
       
    FROM churn_class_dt_confusion_matrix
    fetch first 1 row only;
    


COLUMN DT_Accuracy      FORMAT A17 HEADING 'DT Model Accuracy' 

Select round(True_Values/Total_Values * 100, 2) || '%' as DT_Accuracy
from dt_model_accuracy;



COLUMN ACTUAL_TARGET_VALUE     Clear
COLUMN PREDICTED_TARGET_VALUE  Clear
COLUMN VALUE                   Clear
