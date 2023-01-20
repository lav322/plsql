-------------------An anonymous block example
set SERVEROUTPUT ON
--declare
--    cursor c_emps is select * from employees_copy for update;
--    v_salary_increase number:= 1.10;
--    v_old_salary number;
--begin
--    for r_emp in c_emps loop
--      v_old_salary := r_emp.salary;
--      r_emp.salary := r_emp.salary*v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
--      update employees_copy set row = r_emp where current of c_emps;
--      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
--                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
--    end loop;
--end;

-----------------An anonymous block example 2 
--declare
--    cursor c_emps is select * from employees_copy for update;
--    v_salary_increase number:= 1.10;
--    v_old_salary number;
--    v_new_salary number;
--    v_salary_max_limit pls_integer := 20000;
--begin
--    for r_emp in c_emps loop
--      v_old_salary := r_emp.salary;
--      --check salary area
--      v_new_salary := r_emp.salary*v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
--      if v_new_salary > v_salary_max_limit then
--       RAISE_APPLICATION_ERROR(-20000, 'The new salary of '||r_emp.first_name|| ' cannot be higher than '|| v_salary_max_limit);
--      end if;
--      r_emp.salary := r_emp.salary*v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
--      ----------
--      update employees_copy set row = r_emp where current of c_emps;
--      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
--                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
--    end loop;
--end;
--


-----------------Creating a procedure with the IN parameters
create or replace procedure increase_salaries (v_salary_increase in number, v_department_id pls_integer) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    end loop;
    dbms_output.put_line('Procedure finished executing!');
end;

----------------- Creating a procedure with the OUT parameters
create or replace procedure increase_salaries 
    (v_salary_increase in out number, v_department_id pls_integer, v_affected_employee_count out number) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
    v_sal_inc number := 0;
begin
    v_affected_employee_count := 0;
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
      v_affected_employee_count := v_affected_employee_count + 1;
      v_sal_inc := v_sal_inc + v_salary_increase + nvl(r_emp.commission_pct,0);
    end loop;
    v_salary_increase := v_sal_inc / v_affected_employee_count;
    dbms_output.put_line('Procedure finished executing!');
end;