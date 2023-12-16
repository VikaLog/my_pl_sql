FUNCTION get_sum_price_sales(p_table IN VARCHAR2) RETURN NUMBER IS
    
    v_table        VARCHAR2(50):= p_table;
    v_dynamic_sql  VARCHAR2(500);
    v_sum          NUMBER;
    v_message      logs.message%TYPE;
    
BEGIN

    IF v_table NOT IN ('products', 'products_old') THEN
        v_message := 'Invalid value. products or products_old are expected.';
        to_log(p_appl_proc => 'util.get_sum_price_sales', p_message => v_message);
        raise_application_error(-20001, v_message);
    END IF;

     v_dynamic_sql := 'SELECT SUM(p.price_sales) FROM hr.'||v_table||' p';
     
     EXECUTE IMMEDIATE v_dynamic_sql INTO v_sum;
     
     RETURN v_sum;
     
END get_sum_price_sales;
/