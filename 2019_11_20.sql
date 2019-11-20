--GROUPING (cube, rollup절의 사용된 컬럼)
--해당 컬럼이 소계 계산에 사용된 경우 1
--사용되지 않은 경우 0

--job컬럼
--case1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--       job --> '총계'
--case else
--       job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
        END job, 
        CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job || ' 소계'
            ELSE deptno || ''
        END deptno,
        GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


--(실습 GROUP_AD3)
SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job;

--(실습 GROUP_AD4)
SELECT d.dname, e.job, SUM(e.sal)
FROM dept d, (SELECT *
              FROM emp
              ORDER BY deptno, job) e
WHERE d.deptno = e.deptno
GROUP BY ROLLUP (d.dname, e.job)
ORDER BY d.dname, e.job DESC;

--(실습 GROUP_AD5)
SELECT CASE 
        WHEN GROUPING(d.dname) = 1 AND
             GROUPING(e.job) = 1 THEN '총합'
        ELSE d.dname
        END dname,
        e.job, SUM(e.sal)
FROM dept d, (SELECT *
              FROM emp
              ORDER BY deptno, job) e
WHERE d.deptno = e.deptno
GROUP BY ROLLUP (d.dname, e.job)
ORDER BY d.dname, e.job DESC;

--CUBE (col, col2...)
--CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
--GROUP BY CUBE(job, deptno)
--oo : GROUP BY job, deptno
--ox : GROUP BY job
--xo : GROUP By detpno
--XX : GROUP BY --모든 데이터에 대해서...

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

--(서브쿼리 ADVANCED)
SELECT *
FROM emp;
SELECT *
FROM emp_test;

DROP TABLE emp_test;

--emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성
CREATE TABLE emp_test AS 
SELECT *
FROM emp;

--emp_test 테이블의 dept테이블에서 관리되고있는 dname 컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test테이블의 dname컬럼을 dept테이블의 dname컬럼 값으로 업데이트

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno);
--WHERE empno IN (7369, 7499); --도 가능
COMMIT;

SELECT *
FROM dept_test;

DROP TABLE dept_test;

--dept테이블을 이용하여 dept_test테이블 생성
CREATE TABLE dept_test AS
SELECT *
FROM dept;

--dept_test테이블에 empcnt (number) 컬럼 추가
ALTER TABLE dept_test ADD (empcnt NUMBER);

SELECT *
FROM dept_test;

--subquery를 이용하여 dept_test테이블의 empcnt컬럼에 
--해당 부서원 수를 update쿼리를 작성하세요.
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp WHERE dept_test.deptno = emp.deptno);

SELECT deptno, COUNT(*) 
FROM emp
GROUP BY deptno;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test;

--직원이 없는 부서를 지워라.
DELETE dept_test
WHERE NOT EXISTS (SELECT 'x' FROM emp e WHERE dept_test.deptno = e.deptno);

--두번째 방법
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

--(실습 sub_a3)
SELECT *
FROM emp_test;

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT *
FROM emp_test;

UPDATE emp_test a SET sal = (sal + 200)
WHERE sal < (SELECT AVG(sal) avg_sal
             FROM emp_test b
             WHERE a.deptno = b.deptno);

--emp, emp_test empno컬럼으로 같은 값끼리 조회
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;

--2. emp.empno, emp.ename, emp.sal, emp_test.sal, 해당사원(emp테이블 기준)이 속한 부서의 급여평균
SELECT emp.empno, emp.ename, emp.sal before, emp_test.sal after, emp.deptno, ROUND(e.sal, 2) sal_avg
FROM emp, emp_test, (SELECT c.deptno, AVG(sal) sal FROM emp c group by c.deptno) e
WHERE emp.empno = emp_test.empno
AND emp.deptno = e.deptno
ORDER BY emp.deptno DESC, before;


SELECT *
FROM emp_test a
WHERE sal < (SELECT AVG(sal) FROM emp_test b WHERE b.deptno = a.deptno);

SELECT ROUND(AVG(sal)) avg_sal
FROM emp
GROUP BY deptno;