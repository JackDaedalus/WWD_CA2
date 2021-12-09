SET DEFINE OFF

CREATE TABLE tblSocialGrade ( Grade VARCHAR2(26) NOT NULL,
Social_Class VARCHAR2(26) NOT NULL);



INSERT INTO tblSocialGrade (Grade, Social_Class) 
VALUES ('A', 'Upper middle class');

INSERT INTO tblSocialGrade (Grade, Social_Class) 
VALUES ('B', 'Middle middle class');

INSERT INTO tblSocialGrade (Grade, Social_Class) 
VALUES ('C1', 'Lower middle class');

INSERT INTO tblSocialGrade (Grade, Social_Class) 
VALUES ('C2', 'Skilled working class');

INSERT INTO tblSocialGrade (Grade, Social_Class) 
VALUES ('D', 'Working class');

INSERT INTO tblSocialGrade (Grade, Social_Class) 
VALUES ('E', 'Non-working');

