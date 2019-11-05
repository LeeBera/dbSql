--년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
--201911 --> 30 / 201912 --> 31

--한달 더한 후 원래값을 빼면 = 일수
--마지막날짜 구한 후 --> DD만 추출
SELECT TO_CHAR(LAST_DAY(TO_DATE('201912', 'YYYYMM')), 'DD') day_cnt
FROM dual;

--fn3
SELECT :yyyymm AS param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') day_cnt
FROM dual;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT empno, ename, sal, TO_CHAR(sal, '999,999.99') sal_fmt
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal, 'l999,999.99') sal_fmt
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99') sal_sal
FROM emp;

--function null
--NVL(coll, coll이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, NVL(comm, 0) nvl_comm,
        sal + comm, sal + NVL(comm, 0),
        NVL(sal + comm, 0)
FROM emp;

--NVL2(coll, coll이 null이 아닐 경우 표현되는 값, coll null일 경우 표현되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--함수 인자중 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;

--FUNCTION
--emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT empno, ename, mgr, NVL(mgr, 9999) N, NVL2(mgr, mgr, 9999) N_1, COALESCE(mgr, 9999) N_2
FROM emp;

--fn5

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) N_reg_dt
FROM users;

SELECT ename, job, sal, 
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20 
        ELSE sal
    END AS case_sal
FROM emp;

--decode(col, search1, return1, search2, return2, search3, return3, ..., default)
SELECT empno, ename, job, sal,
        CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20 
        ELSE sal
         END AS case_sal,
        DECODE(job, 'SALESMAN', sal * 1.05, 'MANAGER', sal * 1.10, 'PRESIDENT', sal * 1.20, sal) decode_sal
FROM emp;

--cond1
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING' , 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') AS dname 
FROM emp;


SELECT empno, ename, 
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES' 
        WHEN deptno = 40 THEN 'OPERATIONS' 
        ELSE 'DDIT'
    END AS dname
FROM emp;


SELECT empno, ename, hiredate, 
    CASE
        WHEN MOD(TO_CHAR(sysdate, 'YYYY')-TO_CHAR(hiredate, 'YYYY'), 2) = 0 THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END AS CONTACTTODOCTOR
FROM emp;

--올해가 짝수해인가? 홀수해인가?
--1. 올해 년도 구하기(DATE ==> TO_CHAR(DATE, FORMAT))
--2. 올해 년도가 짝수인지 계산
-- 어떤 수를 2로 나누면 나머지는 항상 2보다 작다
-- 2로 나눌경우 나머지는 0, 1
-- MOD(대상, 나눌값)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM dual;

--emp 테이블에서 입사일자가 홀수년인지 짝수년인지 확인
SELECT empno, ename, hiredate,
    CASE
     WHEN MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2) THEN '건강검진 대상'
     ELSE '건강검진 비대상'
    END CONTACTTODOCTOR
FROM emp;

--cond3
SELECT userid, usernm, alias, reg_dt, 
    CASE
        WHEN MOD(TO_CHAR(sysdate, 'YYYY')-TO_CHAR(reg_dt, 'YYYY'), 2) = 0 THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END AS CONTACTTODOCTOR
FROM users;

--group function(AVG, MAX, MIN, SUM, COUNT)
--그룹함수는 NULL값을 계산대상에서 제외한다.
--SUM(comm), COUNT(*), COUNT(mgr)
--직원 중 가장 높은 급여를 받는 사람의 급여
--직원 중 가장 낮은 급여를 받는 사람의 급여
--직원의 급여 평균(소수점 둘째짜리까지만 나오게 ==> 소수점 셋째자리에서 반올림)
--직원의 급여 전체 합
--직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt, --값이 null이면 카운트 안한다.
       COUNT(mgr) mgr_cnt,
       SUM(comm)--그룹함수에서는 null값을 빼고 연산하기 때문에 null값이 있는 컬럼이 있어도 연산값이 null이 되지 않는다.
FROM emp;

SELECT empno, ename, sal
FROM emp
order by sal;

--부서별 가장 높은 급여를 받는 사람의 급여
--GROUP BY 절에 기술되지 않은 컬럼이 SELECT 절에 기술될 경우 에러
SELECT deptno, ename, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT deptno, MAX(ename), MAX(sal) max_sal
FROM emp
GROUP BY deptno;



--그룹화와 관련없는 임의의 문자열, 상수는 올 수 있다.
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt, --값이 null이면 카운트 안한다.
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
       --그룹함수에서는 null값을 빼고 연산하기 때문에 null값이 있는 컬럼이 있어도 연산값이 null이 되지 않는다.
FROM emp;
GROUP BY deptno;

--부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(empno) count_all
FROM emp;

--grp2
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(empno) count_all
FROM emp
GROUP BY deptno;

