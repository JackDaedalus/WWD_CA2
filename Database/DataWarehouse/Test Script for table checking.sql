declare
v_sql LONG;
begin

v_sql:='create table EMPLOYEE
  (
  ID NUMBER(3),
  NAME VARCHAR2(30) NOT NULL
  )';
execute immediate v_sql;

EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        NULL; -- suppresses ORA-00955 exception
      ELSE
         RAISE;
      END IF;
END; 