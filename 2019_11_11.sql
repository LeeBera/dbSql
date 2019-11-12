--SMITH, WARD가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
   OR deptno = 30;
   
SELECT *
FROM emp 
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN ('SMITH', 'WARD'));
                 
SELECT *
FROM emp 
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN (:name1, :name2));

--ANY : set중에 만족하는게 하나라도 있으면 참으로(크기비교)
--SMITH, WARD 두사람의 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal < any (SELECT sal --800, 1250 --> 1250보다 적은 급여를 받는 사람
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고 WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp
WHERE sal > all (SELECT sal --800, 1250 --> 1250보다 높은 급여를 받는 사람
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
--NOT IN
--관리자의 직원정보
--.mgr 컬럼에 값이 나오는 직원
SELECT DISTINCT mgr
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);
                
--관리자역할을 하지 않는 사원들의 정보조회
--단 NOT IN연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한
SELECT *
FROM emp    --7839, 7782, 7698, 7902, 7566, 7788 다음 6개의 사번에 포함되지 않는 직원
WHERE empno NOT IN (SELECT mgr
                    FROM emp 
                    WHERE emp is NOT NULL);

SELECT *
FROM emp    --7839, 7782, 7698, 7902, 7566, 7788 다음 6개의 사번에 포함되지 않는 직원
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);
                    
--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--7698 30
--7839 10
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);
--직원 중에 관리자와 부서번호가 (7698, 30) 이거나, (7839, 10)인 사람
--mgr, deptno 컬럼을 (동시)에 만족시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
--7698 30
--7839 10
--(7698 30) (7698 10) 
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                        FROM emp
                        WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
--SCALAR : supquery : SELECT 절에 등장하는 서브 쿼리(단 값이 하나의 행, 하나의 컬럼)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, '부서명' dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;


--sub4 데이터 생성
SELECT *
FROM dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT DISTINCT deptno
FROM emp;

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);

--sub5                
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

SELECT *
FROM cycle
WHERE cid = 2;

SELECT *
FROM cycle
WHERE cid = 1;

--sub6
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);

--sub7
SELECT cycle.cid, customer.CNM, cycle.pid, product.PNM, cycle.day, cycle.cnt
FROM cycle, product, customer
WHERE cycle.PID = product.pid
AND cycle.cid = customer.cid
AND cycle.cid = 1
AND cycle.pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);

SELECT *
FROM customer;
SELECT *
FROM cycle;
SELECT *
FROM product;

--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값잏 ㅏ나라도 존재하면 더이상 진행하지 않고 멈추기 때문에
--성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp--emp가 메인과 겹치기 때문에 둘 중 하나라도 별칭이 있어야 한다.
              WHERE empno = a.mgr);
              
--MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
              FROM emp--emp가 메인과 겹치기 때문에 둘 중 하나라도 별칭이 있어야 한다.
              WHERE empno = a.mgr);

--sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--sub9
--EXISTS연산자 이용해서 풀기
SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle
              WHERE cid = 1
              AND pid = p.pid);

--서브쿼리로만 풀기
SELECT *
FROM product p
WHERE p.pid NOT IN (SELECT c.pid
                    FROM cycle c
                    WHERE c.cid = 1);



--부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)
SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

SELECT *
FROM dept
WHERE EXISTS (SELECT 'X'
             FROM emp
             WHERE deptno = dept.deptno);
             
--IN으로 하는 법             
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);
                 
--집합연산
--사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--사번이 7369, 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;


--사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION --합집합, 중복을 제거
--      DBMS에서는 중복을 제거하기 위해 데이터를 정렬
--      (대량의 데이터에 대해 정렬시 부하)
--UNION ALL : UNION과 같은 개념
--            중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION 연산자보다 성능면에서 유리
--사번이 7566, 7499인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7499;



--UNION ALL
--사번이 7566 또는 7698인 사원 조회 (사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698)
UNION ALL
---사번이 7566, 7698인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;


--INTERSECT(교집합 : 위 아래 집합간 공통 데이터)
--7369	SMITH
--7499	ALLEN

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);




--MINUS(차집합 : 위 집합에서 아래 집합을 제거)
--순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);


SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369);

SELECT 1 n, 'x' m
FROM dual
union
SELECT 2, 'y'
FROM dual
ORDER BY m DESC;--ORDER BY 위치 잘 지켜주기

