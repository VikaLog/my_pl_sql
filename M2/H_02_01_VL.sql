DECLARE
    v_employee_id hr.employees.employee_id%TYPE := 110;
    v_job_id hr.employees.job_id%TYPE;
    v_job_title hr.jobs.job_title%TYPE;
BEGIN
    
    SELECT em.job_id
    INTO v_job_id
    FROM hr.employees em
    WHERE em.employee_id = v_employee_id;
    
    SELECT j.job_title
    INTO v_job_title
    FROM hr.jobs j
    WHERE j.job_id = v_job_id;
    
    DBMS_OUTPUT.put_line('The job of employee_id '||v_employee_id||' is '||v_job_title);
    
END;
/

SELECT *
FROM hr.employees em
WHERE em.employee_id = 110;
/

SELECT j.job_title
FROM hr.jobs j
WHERE j.job_id = 'FI_ACCOUNT';