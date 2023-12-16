
CREATE VIEW rep_project_dep_v AS
SELECT ext_fl.project_id, ext_fl.project_name, ext_fl.department_id, dep.department_name, emp_inf.employee_count, emp_inf.manager_count, emp_inf.total_salary
FROM EXTERNAL ( ( project_id NUMBER,
                  project_name VARCHAR2(100),
                  department_id NUMBER )
    TYPE oracle_loader DEFAULT DIRECTORY FILES_FROM_SERVER -- вказуємо назву директорії в БД
    ACCESS PARAMETERS ( records delimited BY newline
                        nologfile
                        nobadfile
                        fields terminated BY ','
                        missing field VALUES are NULL )
    LOCATION('PROJECTS.csv') -- вказуємо назву файлу
    REJECT LIMIT UNLIMITED /*немає обмежень для відкидання рядків*/ ) ext_fl
INNER JOIN departments dep
    ON dep.department_id = ext_fl.department_id
INNER JOIN (SELECT 
                em.department_id,
                COUNT(em.employee_id) employee_count,
                COUNT(DISTINCT em.manager_id) manager_count,
                SUM(em.salary) total_salary
            FROM employees em
            WHERE em.department_id IS NOT NULL
            GROUP BY em.department_id
            ) emp_inf
    ON emp_inf.department_id = ext_fl.department_id
;
/    

DECLARE
    file_handle UTL_FILE.FILE_TYPE;
    file_location VARCHAR2(200) := 'FILES_FROM_SERVER'; -- Назва створеної директорії
    file_name VARCHAR2(200) := 'TOTAL_PROJ_INDEX_VL.csv'; -- Ім'я файлу, який буде записаний
    file_content VARCHAR2(4000); -- Вміст файлу
BEGIN

    FOR cc IN (
        SELECT  project_id ||','|| project_name ||','|| department_id||','|| department_name ||','|| employee_count ||','|| manager_count ||','|| total_salary AS file_content
        FROM rep_project_dep_v) LOOP
        
        file_content := file_content || cc.file_content || CHR(10);
        
    END LOOP;
    
    file_handle := utl_file.fopen(file_location, file_name, 'W');
    
    utl_file.put_raw(file_handle, utl_raw.cast_to_raw(file_content));
    
    utl_file.fclose(file_handle);

EXCEPTION
    WHEN OTHERS THEN
        RAISE;

END;
/
