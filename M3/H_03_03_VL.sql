CREATE PACKAGE util AS

    FUNCTION get_job_title(p_employee_id IN NUMBER) RETURN VARCHAR;
    
    FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR;
                                           
    PROCEDURE del_jobs(p_job_id     IN VARCHAR2, 
                       po_result    OUT VARCHAR2);

END util;
/


CREATE PACKAGE BODY util AS

    FUNCTION get_job_title(p_employee_id IN NUMBER) RETURN VARCHAR IS

    v_job_title jobs.job_title%TYPE;
BEGIN

    SELECT j.job_title
    INTO v_job_title
    FROM employees em
    JOIN jobs j
    ON em.job_id = j.job_id
    WHERE em.employee_id = p_employee_id;

    RETURN v_job_title;

END get_job_title;


FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR IS

    v_dep_name vika.departments.department_name%TYPE;
BEGIN

    SELECT d.department_name
    INTO v_dep_name
    FROM vika.employees em
    JOIN vika.departments d
    ON em.department_id = d.department_id
    WHERE em.employee_id = p_employee_id;

    RETURN v_dep_name;

END get_dep_name;


--procedure

PROCEDURE del_jobs(p_job_id     IN VARCHAR2, 
          po_result    OUT VARCHAR2) IS
                          
    v_is_exist_job NUMBER;
                    
BEGIN

    SELECT COUNT(j.job_id)
    INTO v_is_exist_job
    FROM vika.jobs j
    WHERE j.job_id = p_job_id;

    IF v_is_exist_job >=1 THEN
    
        DELETE FROM  vika.jobs
        WHERE job_id = p_job_id;
        -- COMMIT;

        po_result := 'Job ' || p_job_id || ' is deleted';
    ELSE
        po_result := 'Job ' || p_job_id || ' is not exist';
    END IF;

END del_jobs;

END util;
/





DECLARE 
    v_result VARCHAR2(100); 
BEGIN

    util.del_jobs(p_job_id     => 'IT_QA', 
                 po_result => v_result);
    
    DBMS_OUTPUT.PUT_LINE(v_result);
                 
END;
/


SELECT 
    util.get_job_title(p_employee_id => employee_id) as job_title,
    util.get_dep_name(p_employee_id => employee_id) as dep_name
FROM vika.employees;