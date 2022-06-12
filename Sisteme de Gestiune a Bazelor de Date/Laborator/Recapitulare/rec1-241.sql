select * from employees;

select * 
from employees
order by employee_id;


select department_id, sum(salary)
from employees
where department_id is not null
group by department_id; --11 salarii (11 departamente)

select department_name, sum(salary)
from employees JOIN departments USING (department_id)
where department_id is not null
group by department_name;

--Departamnetul(denumire) cu cea mai mare suma a salariilor

SELECT MAX(salariu)
FROM (SELECT department_id, SUM(salary) AS salariu
      FROM EMPLOYEES
      WHERE department_id IS NOT NULL
      GROUP BY department_id);



select d.department_id, d.DEPARTMENT_NAME, sum(e.salary)
from employees e, departments d
where d.department_id = e.department_id
group by d.department_id,  d.DEPARTMENT_NAME
having sum(salary) = (
                      select max(sum(salary))
                      from employees
                      where department_id is not null
                      group by department_id);   
                      
 select * from employees
 where manager_id is null;
 
 select count(*)
 from employees; --107
 
 select count(COMMISSION_PCT)
 from employees; --35
 
 drop table emp_ong;
 
 create table emp_ong
 as select * from employees;
 
 describe employees;
 desc emp_ong;
 
 alter table employees
 drop constraint EMP_EMP_ID_PK;

alter table emp_ong
add constraint pk_emp_ong primary key(employee_id);

 alter table emp_ong
 drop constraint pk_emp_ong;
 
 alter table emp_ong
add constraint pk2_emp_ong primary key(last_name);
 
select * from employees;
where department_id is null;

delete from departments where department_id =50;

---departemnetele in care nu lucreaza niciun angajat

SELECT department_id
FROM departments
WHERE department_id NOT IN(
                            SELECT department_id
                            FROM employees
                            where department_id is not null
                            );

select e.department_id, d.department_id, d.department_name
from departments d
left outer join employees e on e.department_id=d.department_id;
where e.department_id is null;

select department_id
from departments
minus
select department_id
from employees;

delete from departments where department_id =50;
commit;

delete from departments where department_id =120; --1 rows deleted.

-- Sa se afiseze numele si salariul celor mai prost platiti angajati din firma.

select employee_id, last_name||' '||first_name as angajat, salary
from employees
where salary = (
                  select min(salary)
                  from employees);

27. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament.

SELECT department_id, salary, employee_id
FROM employees E1
where salary = (
                                SELECT MIN(salary)
                                FROM employees E2
                                WHERE E1.department_id = E2.department_id
                                );
select last_name, salary
from employees e
where salary = (select min(salary)
                  from employees
                  where department_id = e.department_id
                  --group by department_id
);

select last_name, salary
from employees
where (department_id, salary) in (select department_id, min(salary)
                                    from employees
                                    group by department_id); --12 rezultate
                                    