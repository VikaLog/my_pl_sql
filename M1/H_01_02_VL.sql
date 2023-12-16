DECLARE 
    v_date DATE := to_date('30.07.2023', 'DD.MM.YYYY');
    v_day NUMBER;
BEGIN

    v_day := to_number(to_char(v_date, 'dd'));
    
    IF v_day = to_number(to_char(last_day(v_date), 'dd')) THEN
        DBMS_OUTPUT.PUT_LINE('Payday');
    ELSIF v_day = 15 THEN
        DBMS_OUTPUT.PUT_LINE('Payday advance');
    ELSIF v_day < 15 THEN
        DBMS_OUTPUT.PUT_LINE('Waiting for an advance');
    ELSIF v_day > 15 THEN
        DBMS_OUTPUT.PUT_LINE('Waiting for a salary');
    END IF;
    
END;
/