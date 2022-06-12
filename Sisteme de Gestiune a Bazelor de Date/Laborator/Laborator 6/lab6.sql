-- 1
CREATE OR REPLACE TRIGGER trig1_ltb
      BEFORE INSERT OR UPDATE OR DELETE ON emp_ltb
BEGIN
 IF (TO_CHAR(SYSDATE,'D') = 1) 
     OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20)
 THEN
    RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat');
 END IF;
END;
/

DROP TRIGGER trig1_ltb;

--2
--Varianta 1
CREATE OR REPLACE TRIGGER trig21_ltb
  BEFORE UPDATE OF salary ON emp_ltb
  FOR EACH ROW
BEGIN
  IF (:NEW.salary < :OLD.salary) THEN 
     RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
  END IF;
END;
/

UPDATE emp_ltb
SET    salary = salary-100;

DROP TRIGGER trig21_ltb;

--Varianta 2
CREATE OR REPLACE TRIGGER trig22_ltb
  BEFORE UPDATE OF salary ON emp_ltb
  FOR EACH ROW
  WHEN (NEW.salary < OLD.salary)
BEGIN
  RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END;
/

UPDATE emp_ltb
SET    salary = salary-100;
DROP TRIGGER trig22_ltb;

--3
create table job_grades_prof as select * from job_grades;

CREATE OR REPLACE TRIGGER trig3_ltb
  BEFORE UPDATE OF lowest_sal, highest_sal ON job_grades_ltb
  FOR EACH ROW
DECLARE
  v_min_sal  emp_ltb.salary%TYPE;
     v_max_sal  emp_ltb.salary%TYPE;
  exceptie EXCEPTION;
BEGIN
  SELECT MIN(salary), MAX(salary)
  INTO   v_min_sal,v_max_sal
  FROM   emp_ltb;
  IF (:OLD.grade_level=1) AND  (v_min_sal< :NEW.lowest_sal) 
     THEN RAISE exceptie;
  END IF;
  IF (:OLD.grade_level=7) AND  (v_max_sal> :NEW.highest_sal) 
     THEN RAISE exceptie;
  END IF;
EXCEPTION
  WHEN exceptie THEN
    RAISE_APPLICATION_ERROR (-20003, 'Exista salarii care se gasesc in afara intervalului'); 
END;
/

UPDATE job_grades_ltb 
SET    lowest_sal =3000
WHERE  grade_level=1;

UPDATE job_grades_ltb
SET    highest_sal =20000
WHERE  grade_level=7;

DROP TRIGGER trig3_ltb;

--4
CREATE OR REPLACE PROCEDURE modific_plati_ltb
          (v_codd  info_dept_ltb.id%TYPE,
           v_plati info_dept_ltb.plati%TYPE) AS
BEGIN
  UPDATE  info_dept_ltb
  SET     plati = NVL (plati, 0) + v_plati
  WHERE   id = v_codd;
END;
/

CREATE OR REPLACE TRIGGER trig4_ltb
  AFTER DELETE OR UPDATE  OR  INSERT OF salary ON emp_ltb
  FOR EACH ROW
BEGIN
  IF DELETING THEN 
     -- se sterge un angajat
     modific_plati_ltb (:OLD.department_id, -1*:OLD.salary);
  ELSIF UPDATING THEN 
    --se modifica salariul unui angajat
    modific_plati_ltb(:OLD.department_id,:NEW.salary-:OLD.salary);  
  ELSE 
    -- se introduce un nou angajat
    modific_plati_ltb(:NEW.department_id, :NEW.salary);
  END IF;
END;
/

SELECT * FROM  info_dept_ltb WHERE id=90;

INSERT INTO emp_ltb (employee_id, last_name, email, hire_date, 
                     job_id, salary, department_id) 
VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 90);

SELECT * FROM  info_dept_ltb WHERE id=90;

UPDATE emp_ltb
SET    salary = salary + 1000
WHERE  employee_id=300;

SELECT * FROM  info_dept_ltb WHERE id=90;

DELETE FROM emp_ltb
WHERE  employee_id=300;   

SELECT * FROM  info_dept_ltb WHERE id=90;

DROP TRIGGER trig4_ltb;

--5
CREATE OR REPLACE VIEW v_info_ltb AS
  SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, 
         d.nume_dept, d.plati 
  FROM   info_emp_ltb e, info_dept_ltb d
  WHERE  e.id_dept = d.id;

SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_ltb');

CREATE OR REPLACE TRIGGER trig5_ltb
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_ltb
    FOR EACH ROW
BEGIN
IF INSERTING THEN 
    -- inserarea in vizualizare determina inserarea 
    -- in info_emp_ltb si reactualizarea in info_dept_ltb
    -- se presupune ca departamentul exista
   INSERT INTO info_emp_ltb 
   VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu,
           :NEW.id_dept);
     
   UPDATE info_dept_ltb
   SET    plati = plati + :NEW.salariu
   WHERE  id = :NEW.id_dept;

ELSIF DELETING THEN
   -- stergerea unui salariat din vizualizare determina
   -- stergerea din info_emp_ltb si reactualizarea in
   -- info_dept_ltb
   DELETE FROM info_emp_ltb
   WHERE  id = :OLD.id;
     
   UPDATE info_dept_ltb
   SET    plati = plati - :OLD.salariu
   WHERE  id = :OLD.id_dept;

ELSIF UPDATING ('salariu') THEN
   /* modificarea unui salariu din vizualizare determina 
      modificarea salariului in info_emp_ltb si reactualizarea
      in info_dept_ltb    */
    	
   UPDATE  info_emp_ltb
   SET     salariu = :NEW.salariu
   WHERE   id = :OLD.id;
    	
   UPDATE info_dept_ltb
   SET    plati = plati - :OLD.salariu + :NEW.salariu
   WHERE  id = :OLD.id_dept;

ELSIF UPDATING ('id_dept') THEN
    /* modificarea unui cod de departament din vizualizare
       determina modificarea codului in info_emp_ltb 
       si reactualizarea in info_dept_ltb  */  
    UPDATE info_emp_ltb
    SET    id_dept = :NEW.id_dept
    WHERE  id = :OLD.id;
    
    UPDATE info_dept_ltb
    SET    plati = plati - :OLD.salariu
    WHERE  id = :OLD.id_dept;
    	
    UPDATE info_dept_ltb
    SET    plati = plati + :NEW.salariu
    WHERE  id = :NEW.id_dept;
  END IF;
END;
/

SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_ltb');

-- adaugarea unui nou angajat
SELECT * FROM  info_dept_ltb WHERE id=10;

INSERT INTO v_info_ltb 
VALUES (400, 'N1', 'P1', 3000,10, 'Nume dept', 0);

SELECT * FROM  info_emp_ltb WHERE id=400;
SELECT * FROM  info_dept_ltb WHERE id=10;

-- modificarea salariului unui angajat
UPDATE v_info_ltb
SET    salariu=salariu + 1000
WHERE  id=400;

SELECT * FROM  info_emp_ltb WHERE id=400;
SELECT * FROM  info_dept_ltb WHERE id=10;

-- modificarea departamentului unui angajat
SELECT * FROM  info_dept_ltb WHERE id=90;

UPDATE v_info_ltb
SET    id_dept=90
WHERE  id=400;

SELECT * FROM  info_emp_ltb WHERE id=400;
SELECT * FROM  info_dept_ltb WHERE id IN (10,90);

-- eliminarea unui angajat
DELETE FROM v_info_ltb WHERE id = 400;
SELECT * FROM  info_emp_ltb WHERE id=400;
SELECT * FROM  info_dept_ltb WHERE id = 90;

DROP TRIGGER trig5_ltb;

--6 
CREATE OR REPLACE TRIGGER trig6_ltb
  BEFORE DELETE ON emp_ltb
 BEGIN
  IF USER= UPPER('grupaltb') THEN
     RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!');
  END IF;
 END;
/

DROP TRIGGER trig6_ltb;

--7
CREATE TABLE audit_ltb
   (utilizator     VARCHAR2(30),
    nume_bd        VARCHAR2(50),
    eveniment      VARCHAR2(20),
    nume_obiect    VARCHAR2(30),
    data           DATE);
CREATE OR REPLACE TRIGGER trig7_ltb
  AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
  INSERT INTO audit_ltb
  VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, 
          SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE INDEX ind_ltb ON info_emp_ltb(nume);
DROP INDEX ind_ltb;
SELECT * FROM audit_ltb;

DROP TRIGGER trig7_ltb;

--8
CREATE OR REPLACE PACKAGE pachet_ltb
AS
	smin emp_ltb.salary%type;
	smax emp_ltb.salary%type;
	smed emp_ltb.salary%type;
END pachet_ltb;
/

CREATE OR REPLACE TRIGGER trig81_ltb
BEFORE UPDATE OF salary ON emp_ltb
BEGIN
  SELECT MIN(salary),AVG(salary),MAX(salary)
  INTO pachet_ltb.smin, pachet_ltb.smed, pachet_ltb.smax
  FROM emp_ltb;
END;
/

CREATE OR REPLACE TRIGGER trig82_ltb
BEFORE UPDATE OF salary ON emp_ltb
FOR EACH ROW
BEGIN
IF(:OLD.salary=pachet_ltb.smin)AND (:NEW.salary>pachet_ltb.smed) 
 THEN
   RAISE_APPLICATION_ERROR(-20001,'Acest salariu depaseste valoarea medie');
ELSIF (:OLD.salary= pachet_ltb.smax) 
       AND (:NEW.salary<  pachet_ltb.smed) 
 THEN
   RAISE_APPLICATION_ERROR(-20001,'Acest salariu este sub valoarea medie');
END IF;
END;
/

SELECT AVG(salary)
FROM   emp_ltb;

UPDATE emp_ltb 
SET    salary=10000 
WHERE  salary=(SELECT MIN(salary) FROM emp_ltb);

UPDATE emp_ltb 
SET    salary=1000 
WHERE  salary=(SELECT MAX(salary) FROM emp_ltb);

DROP TRIGGER trig81_ltb;
DROP TRIGGER trig82_ltb;
