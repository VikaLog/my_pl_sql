-- SET DEFINE OFF;

CREATE TABLE interbank_index_ua_history
( dt DATE,
id_api VARCHAR2(100),
value NUMBER,
special VARCHAR2(10))
;

CREATE VIEW interbank_index_ua_v AS
SELECT 
    TO_DATE(tt.dt, 'dd.mm.yyyy') AS dt,
    tt.id_api,
    tt.value, 
    tt.special
FROM (SELECT sys.get_nbu(p_url => 'https://bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json') AS json_value FROM dual)
CROSS JOIN json_table
    (
    json_value,'$[*]'
    COLUMNS
        (
            dt VARCHAR2(100) PATH '$.dt',
            id_api VARCHAR2(100) PATH '$.id_api',
            value NUMBER PATH '$.value',
            special VARCHAR2(10) PATH '$.special'
            )
) tt;

CREATE OR REPLACE PROCEDURE download_ibank_index_ua IS
BEGIN
    INSERT INTO interbank_index_ua_history (dt, id_api, value, special)
    SELECT tt.dt, tt.id_api, tt.value, tt.special
    FROM interbank_index_ua_v  tt;
    COMMIT;
END download_ibank_index_ua;
/


BEGIN
sys.dbms_scheduler.create_job(job_name => 'ua_history_update',
                              job_type => 'PLSQL_BLOCK',
                              job_action => 'begin download_ibank_index_ua(); end;',
                              start_date => SYSDATE,
                              repeat_interval => 'FREQ=DAILY; BYHOUR=9',
                              end_date => TO_DATE(NULL),
                              job_class => 'DEFAULT_JOB_CLASS',
                              enabled => FALSE,
                              auto_drop => FALSE,
                              comments => 'Оновлення Українського індексу міжбанківських ставок');
END;
/


