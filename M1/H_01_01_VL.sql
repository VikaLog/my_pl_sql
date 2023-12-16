DECLARE 
    v_year NUMBER := 2013;
    v_check_year NUMBER;
BEGIN

    v_check_year := mod(v_year, 4);
    
    IF v_check_year = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Leap year');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Non-leap year');
    END IF;
    
END;
/