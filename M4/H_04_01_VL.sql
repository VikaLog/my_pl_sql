PROCEDURE  check_work_time IS
BEGIN 
    
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') THEN
        raise_application_error(-20205, 'You can make changes only in working day');
    END IF;
    
END check_work_time;
/

