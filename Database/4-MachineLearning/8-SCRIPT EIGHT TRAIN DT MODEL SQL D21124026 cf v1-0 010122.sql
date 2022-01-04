/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
														- January 2022			*/


/* SQL to Train Decision Tree model for the ML Section of WWD CA2  */
/* DT algorithm is the second Model being used for ML Analysis   */
/* on possibility of Customer churn, based on metrics at end of     */
/* this given month in the data warehouse                           */

/* Remove Settings Table for Model if it already exists.            */
/* Will produce error on initial run but not effect procedure below */
/* This also clears out any prior model settings                    */
DROP TABLE decision_tree_model_settings;

-- Create the settings table
CREATE TABLE decision_tree_model_settings (
setting_name VARCHAR2(30),
setting_value VARCHAR2(30));

/* -- Create a model with the ORACLE CREATE_MODEL() procedure       --*/
DECLARE
    /*-- Assign name to this model          --*/
    churn_model_name VARCHAR(30) :=  'decision_tree_model_cchurn1';
BEGIN

    /*-- Populate the settings table     --*/
    
    /*-- Specify Decision Tree as chosen algorithm - override default   --*/
    /*-- of Naive Bayes.                                                --*/
    INSERT INTO decision_tree_model_settings (setting_name, 
                                              setting_value)
        VALUES (dbms_data_mining.algo_name,
                dbms_data_mining.algo_decision_tree);

                
    /*-- Specify Auto Data Preparation. By default, ADP is not used.     --*/          
    INSERT INTO decision_tree_model_settings (setting_name, 
                                              setting_value)
        VALUES (dbms_data_mining.prep_auto,
                dbms_data_mining.prep_auto_on);   


    /*-- Drop previous version of model          --*/
	/* THIS LINE MUST BE UNCOMMENTED IF THE SCRIPT IS RUN MORE THAN ONCE */
    /*DBMS_DATA_MINING.DROP_MODEL(churn_model_name);*/






    /*-- Create/re-create model, using training data sampple extracted      --*/
    /*-- from the CASE table prepared for this ML customer churn analysis   --*/
    DBMS_DATA_MINING.CREATE_MODEL(
      model_name => churn_model_name,
      mining_function => dbms_data_mining.classification,
      data_table_name => 'CaseTrainSample_ml_v',
      case_id_column_name => 'CASEID',
      target_column_name => 'OUT_OF_CONTRACT',
      settings_table_name => 'decision_tree_model_settings' 
   );


END;


