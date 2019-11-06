--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 겨로가 행을 생성
--sum, MAX, MIN, AVG, COUNT
--GROUP BY col : express
--SELECT 절에는 GROUP BY 절에 기술된 col, express 표기 가능

--직원 중 가장 높은 급여 조회
--14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--grp3
SELECT DECODE(deptno, 10, 'ACCOUNTING' , 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') AS dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;
--워닝이 뜬다.

SELECT DECODE(deptno, 10, 'ACCOUNTING' , 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') AS dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING' , 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT')
ORDER BY dname;

--grp4
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(hiredate) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(TO_CHAR(hiredate, 'YYYYMM')) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

--grp5
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy, COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

--grp6
SELECT COUNT(deptno) cnt, COUNT(*) cnt
FROM dept;

SELECT distinct deptno
FROM emp;

--JOIN
--emp 테이블에는 dname 컬럼이 없다. --> 부서번호(deptno)밖에 없음
desc emp;

--emp테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE deptno = 10;
UPDATE emp SET dname = 'RESEARCH' WHERE deptno = 20;
UPDATE emp SET dname = 'SALES' WHERE deptno = 30;
COMMIT;

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN dname;

SELECT *
FROM emp;

--ansi natural join : 테이블의 컬럼명이 같은 컬럼을 기준으로 join
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

--ORACLE join
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI JOIN WITH USIN
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from 절에 조인 대상 테이블 나열
--where절에 조인조건 기술
--기존에 사용하던 조건 제약도 기술가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job = 'SALESMAN';--job이 SALES인 사람만 대상으로 조회

SELECT emp.empno, emp.ename, dept.dname
FROM dept, emp
WHERE emp.job = 'SALESMAN'
AND emp.deptno = dept.deptno;

--JOIN wiht ON(개발자가 조인 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF join : 같은 테이블끼리 조인
--emp테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
--a :직원정보, b:관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno 
AND a.empno BETWEEN 7369 AND 7698;

--non-equaljoing(등식 조건이 아닌 경우)
SELECT *
FROM salgrade;

--직원의 급여 등급은????
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--non equi joing
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno 
AND a.empno BETWEEN 7369 AND 7698;

--join0

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY dname;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
ORDER BY dname;

--join0_1
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.deptno IN (10, 30);

--join0_2
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
ORDER BY sal DESC;

--join0_3
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
AND empno > 7600
ORDER BY sal DESC;