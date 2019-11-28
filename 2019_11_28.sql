--(�ǽ� pro_2)
CREATE OR REPLACE PROCEDURE registdept_test 
(pa_deptno IN dept_test.deptno%TYPE, 
pa_dname IN dept_test.dname%TYPE, 
pa_loc IN dept_test.loc%TYPE)
IS
    
BEGIN
    INSERT INTO dept_test (deptno, dname, loc) VALUES (pa_deptno , pa_dname, pa_loc);
    COMMIT;
END;
/

exec registdept_test(90, 'ddit', 'daejeon');

select *
from dept_test;

--(�ǽ� pro_3)
CREATE OR REPLACE PROCEDURE update_dept_test 
(pa_deptno IN dept_test.deptno%TYPE,
pa_dname IN dept_test.dname%TYPE,
pa_loc IN dept_test.loc%TYPE)
IS

BEGIN
    UPDATE dept_test SET dname = pa_dname, loc = pa_loc WHERE deptno = pa_deptno;
    COMMIT;
END;
/

exec update_dept_test(90, 'DDIT', 'DAEJEON');

SELECT *
FROM dept_test;

--ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��
SET serveroutput ON;


DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || 
                         dept_row.dname || ', ' ||
                         dept_row.loc);
END;
/

--���պ��� : record
DECLARE 
    --UserVO userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    --�� ���� �� ���� �÷�
    
    v_dname dept.dname%TYPE;
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/

--tableType
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER; 
    
    --java : Ÿ�� ������;
    --pl/sql : ������ Ÿ��;
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
    
BEGIN
    bi := 100;

    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    dbms_output.put_line(bi);

    --�ε��� Ÿ���� �������־�� �Ѵ�.
    --dbms_output.put_line(v_dept(0).dname);
    
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(2).dname);
--    dbms_output.put_line(v_dept(3).dname);
--    dbms_output.put_line(v_dept(4).dname);
--    --pl/sql������ �ε����� 1���� �����Ѵ�.
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
END;
/

--IF
--ELSE IF --> ELSIF
--END IF;--�� ��������Ѵ�.

DECLARE 
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    
    IF ind = 1 THEN 
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--FOR LOOP :
--FOR �ε��� ���� IN ���۰�..���ᰪ LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);   
    END LOOP;
END;
/

--LOOP : ��� ���� �Ǵ� ������ LOOP �ȿ��� ����
--java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line(i);
        i := i + 1;
        --loop ��� ���࿩�� �Ǵ�
        EXIT WHEN i >= 5;
    END LOOP;
END;
/

--���̺� ����
 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

SELECT *
FROM dt;

--���� ��� : 5��

--(�ǽ� prp_3)
DECLARE
    TYPE dt_test IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    v_dt dt_test;
    i NUMBER;
    rara NUMBER;
    roro NUMBER;
    
BEGIN
    i := 0;
    rara := 0;
    roro := 0;
    
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt;
    
    LOOP
        i := i + 1;
        
        roro := v_dt(i) - v_dt(i+1);
        rara := rara + roro;
        EXIT WHEN i <= v_dt.count - 1;
    END LOOP;
    
    dbms_output.put_line('��� : ' + (v_dt.count-1));
END;
/

SELECT *
FROM dt;

DECLARE
    TYPE d_row IS RECORD (dt DATE);
    
    TYPE d_table IS TABLE OF d_row INDEX BY BINARY_INTEGER;
    d_tab d_table;
    diff_sum NUMBER := 0;
BEGIN
    SELECT *
    BULK COLLECT INTO d_tab
    FROM dt;
    
    FOR i IN 1..d_tab.count LOOP
        IF i != 1 THEN
        dbms_output.put_line((d_tab(i).dt - d_tab(i-1).dt));
        diff_sum := diff_sum + (d_tab(i).dt - d_tab(i-1).dt);
        END IF;
    END LOOP;
    dbms_output.put_line('diff_sum : ' || diff_sum);
    dbms_output.put_line('������� : ' || (diff_sum/(d_tab.count-1)));
END;
/

--lead, lag �������� ����, ���� �����͸� ������ �� �ִ�.
SELECT *
FROM dt
ORDER BY dt DESC;

SELECT AVG (diff)
FROM
(SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC), dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
FROM dt)
ORDER BY dt desc;

--�м��Լ��� ������� ���ϴ� ȯ�濡��
SELECT AVG(a.dt-b.dt) avg_dt
FROM (SELECT ROWNUM RN, dt
        FROM
            (SELECT *
            FROM dt
            ORDER BY dt DESC)) a,
     (SELECT ROWNUM RN, dt
        FROM
            (SELECT *
            FROM dt
            ORDER BY dt DESC)) b
WHERE a.rn + 1 = b.rn(+);

--HALL OF HONOR(���Ծ�)
SELECT (MAX(dt)-MIN(dt))/(COUNT(*) - 1) avg_dt
FROM dt;

--cursor
DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS 
        SELECT deptno, dname FROm dept;
        
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --���̻� ���� �����Ͱ� ���� �� ����
    END LOOP;
END;
/

--FOR LOOP CURSOR ����
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/
--�Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ', ' || emp.ename 
                            || ', ' || emp.job);
    END LOOP;
END;
/