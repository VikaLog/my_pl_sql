DECLARE
    v_def_persent VARCHAR2(30);
    v_persent VARCHAR2(5);
BEGIN
    FOR cc IN (SELECT 
                    em.manager_id, 
                    em.commission_pct*100                AS percent_of_salary,
                    em.first_name || ' ' || em.last_name AS emp_name
               FROM hr.employees em
               WHERE em.department_id = 80) LOOP
               
        IF cc.manager_id = 100 THEN
            DBMS_OUTPUT.put_line('Employee - ' || cc.emp_name || ', percent of salary is not allowed.');
            CONTINUE;
        END IF;
        
        IF cc.percent_of_salary BETWEEN 10 AND 20 THEN
            v_def_persent := 'minimum';
        ELSIF cc.percent_of_salary BETWEEN 25 AND 30 THEN
            v_def_persent := 'medium';
        ELSIF cc.percent_of_salary BETWEEN 35 AND 40 THEN
            v_def_persent := 'maximum';       
        END IF;
        
        v_persent := CONCAT(cc.percent_of_salary, '%');
        DBMS_OUTPUT.put_line('Employee - ' || cc.emp_name || '; percent of salary - ' || v_persent || '; description of percentage - ' || v_def_persent);
    
    END LOOP;
END;
/

SELECT 
    em.manager_id, 
    em.commission_pct*100                    AS percent_of_salary,
    em.first_name || ' ' || em.last_name     AS emp_name
FROM hr.employees em
WHERE em.department_id = 80;