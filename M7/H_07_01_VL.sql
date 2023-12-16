FUNCTION get_region_cnt_emp(p_department_id IN NUMBER DEFAULT NULL) RETURN tab_regions PIPELINED IS
    out_rec tab_regions := tab_regions();
    l_cur SYS_REFCURSOR;

BEGIN
    OPEN l_cur FOR
        SELECT reg.region_name       AS region_name, 
               COUNT(em.employee_id) AS emp_count
        FROM hr.regions  reg
            INNER JOIN hr.countries  countr
                ON countr.region_id = reg.region_id
            INNER JOIN hr.locations loc
                ON loc.country_id = countr.country_id
            INNER JOIN hr.departments dep
                ON dep.location_id = loc.location_id
            INNER JOIN hr.employees em
                ON em.department_id = dep.department_id
        WHERE (em.department_id = p_department_id or p_department_id is null)
        GROUP BY reg.region_name;
    BEGIN
        LOOP
            EXIT WHEN l_cur%NOTFOUND;
            FETCH l_cur BULK COLLECT
                INTO out_rec;
                FOR i IN 1 .. out_rec.count LOOP
                    PIPE ROW(out_rec(i));
                END LOOP;
        END LOOP;
        
        CLOSE l_cur;
    EXCEPTION
        WHEN OTHERS THEN
            IF (l_cur%ISOPEN) THEN
                CLOSE l_cur;
                RAISE;
            ELSE
                RAISE;
            END IF;
    END;
END get_region_cnt_emp;

SELECT *
FROM TABLE(util.get_region_cnt_emp());