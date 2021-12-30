
set serveroutput on;


DECLARE
v_counter NUMBER := 0;
last_date DATE;
BEGIN

   SELECT MAX(call_event_date) INTO last_date
   FROM dw_dimtblDateTime;
   
    
     
   LOOP
      v_counter := v_counter + 1;
       dbms_output.put_line(v_counter || '**' || sysdate || ' | '  
      || to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
      EXIT WHEN v_counter = 2;
   END LOOP;
   
   dbms_output.put_line('Date is...' || last_date);
   
   
END;
