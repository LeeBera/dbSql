--(실습 pro_2)
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

--(실습 pro_3)
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

--ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조 타입
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

--복합변수 : record
DECLARE 
    --UserVO userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    --한 행의 두 개의 컬럼
    
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
    
    --java : 타입 변수명;
    --pl/sql : 변수명 타입;
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
    
BEGIN
    bi := 100;

    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    dbms_output.put_line(bi);

    --인덱스 타입을 지정해주어야 한다.
    --dbms_output.put_line(v_dept(0).dname);
    
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(2).dname);
--    dbms_output.put_line(v_dept(3).dname);
--    dbms_output.put_line(v_dept(4).dname);
--    --pl/sql에서는 인덱스가 1부터 시작한다.
    FOR i IN 1..v_dept.count LOOP
        dbms_output.put_line(v_dept(i).dname);
    END LOOP;
END;
/

--IF
--ELSE IF --> ELSIF
--END IF;--로 끝내줘야한다.

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
--FOR 인덱스 변수 IN 시작값..종료값 LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);   
    END LOOP;
END;
/

--LOOP : 계속 실행 판단 로직을 LOOP 안에서 제어
--java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line(i);
        i := i + 1;
        --loop 계속 진행여부 판단
        EXIT WHEN i >= 5;
    END LOOP;
END;
/

--테이블 생성
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

--가격 평균 : 5일

--(실습 prp_3)
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
    
    dbms_output.put_line('평균 : ' + (v_dt.count-1));
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
    dbms_output.put_line('간격평균 : ' || (diff_sum/(d_tab.count-1)));
END;
/

--lead, lag 현재행의 이전, 이후 데이터를 가져올 수 있다.
SELECT *
FROM dt
ORDER BY dt DESC;

SELECT AVG (diff)
FROM
(SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC), dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
FROM dt)
ORDER BY dt desc;

--분석함수를 사용하지 못하는 환경에서
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

--HALL OF HONOR(동규쓰)
SELECT (MAX(dt)-MIN(dt))/(COUNT(*) - 1) avg_dt
FROM dt;

--cursor
DECLARE
    --커서 선언
    CURSOR dept_cursor IS 
        SELECT deptno, dname FROm dept;
        
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
BEGIN
    --커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --더이상 읽을 데이터가 없을 때 종료
    END LOOP;
END;
/

--FOR LOOP CURSOR 결합
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
--파라미터가 있는 명시적 커서
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