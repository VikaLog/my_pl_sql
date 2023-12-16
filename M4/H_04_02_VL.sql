PROCEDURE del_jobs(p_job_id     IN VARCHAR2, 
          po_result    OUT VARCHAR2) IS
                          
    v_delete_no_data_found EXCEPTION;
                    
BEGIN

    check_work_time;
    
    BEGIN
        
        DELETE FROM  vika.jobs
        WHERE job_id = p_job_id;
        -- COMMIT;
        
        IF SQL%ROWCOUNT = 0 THEN
            raise v_delete_no_data_found;
        END IF;
    
        po_result := 'Job ' || p_job_id || ' is deleted';

    EXCEPTION
        WHEN v_delete_no_data_found THEN
            raise_application_error(-20004, 'Job ' || p_job_id || ' is not exist');
    
    END;

END del_jobs;

