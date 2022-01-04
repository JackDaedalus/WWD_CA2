SET DEFINE OFF

CREATE TABLE tblRateTypes ( id NUMBER(38) NOT NULL,
name VARCHAR2(26) NOT NULL);



INSERT INTO tblRateTypes (id, name) 
VALUES (1, 'peak');

INSERT INTO tblRateTypes (id, name) 
VALUES (2, 'off-peak');

INSERT INTO tblRateTypes (id, name) 
VALUES (3, 'international');

INSERT INTO tblRateTypes (id, name) 
VALUES (4, 'roaming');

INSERT INTO tblRateTypes (id, name) 
VALUES (5, 'voice mail');

INSERT INTO tblRateTypes (id, name) 
VALUES (6, 'customer service');

