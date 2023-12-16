CREATE FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR IS

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
/


SELECT 
    get_job_title(p_employee_id => employee_id) as job_title,
    get_dep_name(p_employee_id => employee_id) as dep_name
FROM vika.employees;


