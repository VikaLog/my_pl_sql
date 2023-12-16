DECLARE
    v_recipient VARCHAR2(50);
    v_subject VARCHAR2(50);
    v_mes VARCHAR2(5000) := 'Вітаю шановний! </br> Ось звіт з нашою компанії: </br></br>';
BEGIN
    
    SELECT CONCAT(email, '@gmail.com')
    INTO v_recipient
    FROM employees
    WHERE employee_id = 207;
    
    v_subject := 'Department info';
    
    SELECT
    v_mes||'<!DOCTYPE html>
    <html>
        <head>
            <title></title>
            <style>
                table, th, td {border: 1px solid;}
                .center{text-align: center;}
            </style>
        </head>
        <body>
            <table border=1 cellspacing=0 cellpadding=2 rules=GROUPS frame=HSIDES>
                <thead>
                    <tr align=left>
                        <th>Ід департаменту</th>
                        <th>Кількість співробітників</th>
                    </tr>
                </thead>
                 <tbody>
                 '|| list_html || '
                 </tbody>
            </table>
        </body>
    </html>' AS html_table
    INTO v_mes
    FROM (
    SELECT LISTAGG('<tr align=left>
            <td>' || department_id || '</td>' || '
            <td class=''center''> ' || employee_count||'</td>
        </tr>', '<tr>')
    WITHIN GROUP(ORDER BY employee_count) AS list_html
    FROM ( SELECT 
                department_id,
                COUNT(employee_id) AS employee_count
            FROM employees  
            GROUP BY department_id ));
            
    v_mes := v_mes || '</br></br> З повагою, Віка';
    

    sys.sendmail(p_recipient => v_recipient,
    p_subject => v_subject,
    p_message => v_mes || ' ');
END;
/