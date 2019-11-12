--조인복습
--조인을 왜 쓰는가? 
--RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
--EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는 부서번호만 갖고 있고, 부서번호를 통해 dept테이블과
--조인을 통해 행당 부서의 정보를 가져올 수 있다.

--직원 번호, 직원이름, 직원의 소속 부서번호, 부서이름
--emp, dept
SELECT emp.empno, emp.ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호, 부서명, 해당부서의 인원수
--COUNT(col) : col 값이 존재하면 1, null : 0
--             행수가 궁금한 것이면 *
SELECT dept.deptno, dname, COUNT(*) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dept.deptno, dname;

SELECT *
FROM dept;

--TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;


--OUTER JOIN : 조인에 실패해도 기준이 되는 테이블의 데이터는 조회결과가 나오도록 하는 조인 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회기준이 되도록 하는 조인 형태
--RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인 형태
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

--직원 정보와, 해당 직원의 관리자 정보 outer join
--직원 번호, 직원이름, 관리자 번호, 관리자 이름
--ANSI
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

--ORACLE
--LEFT, RIGHT만 존재 fullouter는 지원하지 않음
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, a.ename
FROM emp a LEFT OUTER JOIN emp b 
ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b 
ON (a.mgr = b.empno)
WHERE b.deptno = 10;

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

--ORACLE outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);

select *
from buyprod;

--outerjoin1
SELECT TO_CHAR(b.buy_date, 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, b.buy_qty buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

SELECT TO_CHAR(b.buy_date, 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, b.buy_qty buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id)
WHERE b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin2
SELECT TO_CHAR(TO_DATE('05/01/25', 'YY/MM/DD'), 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, b.buy_qty buy_qty
FROM buyprod b, prod p 
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin3
SELECT TO_CHAR(TO_DATE('05/01/25', 'YY/MM/DD'), 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, NVL(b.buy_qty, 0) buy_qty
FROM buyprod b, prod p 
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin4
SELECT *
FROM cycle;

SELECT *
FROM product;

--outerjoin4
SELECT p.pid, p.pnm, NVL(c.cid, 1), NVL(c.day, 0), NVL(c.cnt, 0)
FROM cycle c RIGHT OUTER JOIN product p ON (c.pid = p.pid AND c.cid = 1);

SELECT p.pid, p.pnm, NVL(c.cid, 1), NVL(c.day, 0), NVL(c.cnt, 0)
FROM cycle c, product p 
WHERE c.pid(+) = p.pid 
AND c.cid(+) = 1;

--outerjoin5
SELECT p.pid, p.pnm, NVL(c.cid, 1), NVL(c.day, 0), NVL(c.cnt, 0)
FROM cycle c, product p 
WHERE c.pid(+) = p.pid 
AND c.cid(+) = 1;

--outerjoin6
SELECT a.pid, a.pnm, a.cid, ct.cnm, a.day, a.cnt
FROM
    (SELECT p.pid, p.pnm, NVL(c.cid, 1) cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
    FROM cycle c, product p 
    WHERE c.pid(+) = p.pid 
    AND c.cid(+) = 1) a, customer ct
WHERE a.cid = ct.cid;

--crossjoin1
SELECT * 
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;

--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치 :
--SELECT - scalar subquery(하나의 행과, 하나의 컬럼만 조회되는 쿼리여야 한다.)
--FROM - inline view
--WHERE - subquery

--SCALAR SUBQUERY
SELECT empno, ename, sysdate now /*현재날짜*/
FROM emp;

SELECT empno, ename, (SELECT sysdate FROM dual) /*현재날짜*/
FROM emp;

SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
--관리자가 7788인 직원을 서브쿼리에


--sub1
--평균급여보다 높은 급여를 받는 직원의 수를 조회하세요
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
           
--sub2
--평균급여보다 높은 급여를 받는 직원의 정보를 조회하세요
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
--sub3
--SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요.
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
            FROM emp
            WHERE ename = 'SMITH')
OR deptno = (SELECT deptno
            FROM emp
            WHERE ename = 'WARD');
