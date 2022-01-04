/* Ciaran Finnegan 	: Student No. D21124026										*/
/* TUD - Class TU060 - MSc In Science (Data Science) - Part Time - First Year 	*/


/* Data Warehouse Design and Implementation : Working With Data - Assignment Two 
                                                        - January 2022			*/


/* SQL to Train Default Naive Bayes for the ML Section of WWD CA2  */
/* Default Classificatin Model being used for initial ML Analysis   */
/* on possibility of Customer churn, based on metrics at end of     */
/* this given month in the data warehouse                           */


/* -- Create a model with the ORACLE CREATE_MODEL() procedure       --*/
DECLARE
    /*-- Assign name to this model          --*/
    churn_model_name VARCHAR(30) :=  'default_nb_model_cchurn1';
BEGIN

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
      settings_table_name => NULL -- uses default settings only
   );


END;


