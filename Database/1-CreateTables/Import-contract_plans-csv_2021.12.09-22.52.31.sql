SET DEFINE OFF

CREATE TABLE tblContractPlans ( id NUMBER(38) NOT NULL,
name VARCHAR2(26) NOT NULL);



INSERT INTO tblContractPlans (id, name) 
VALUES (1, 'standard');

INSERT INTO tblContractPlans (id, name) 
VALUES (2, 'off peak');

INSERT INTO tblContractPlans (id, name) 
VALUES (3, 'cosmopolitan');

