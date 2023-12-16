CREATE PROCEDURE del_jobs(p_job_id     IN VARCHAR2, 
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
/

SELECT job_id
FROM vika.jobs
;

DECLARE 
    v_result VARCHAR2(100); 
BEGIN

    del_jobs(p_job_id     => 'IT_QA4', 
                 po_result => v_result);
    
    DBMS_OUTPUT.PUT_LINE(v_result);
                 
END;
/