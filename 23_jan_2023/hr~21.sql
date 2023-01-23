--
------------------- A standard procedure creation with a default value
--create or replace PROCEDURE add_job(job_id varchar2, job_title VARCHAR2,
--                                      min_salary number default 1000,max_salary number default null)is
--begin
--  insert into jobs values(job_id,job_title,min_salary,max_salary);
--  print('The job:'|| job_title ||'is inserted..');
--end;

--functon