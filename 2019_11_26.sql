SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--(실습 ana1)
--사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용
--단 급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 작성하세요.
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;

--(실습 no_ana2)
--모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리

SELECT e.empno, e.ename, e.deptno, d.cnt
FROM emp e, (SELECT deptno, COUNT(*) cnt
            FROM emp a
            GROUP BY deptno) d
WHERE e.deptno = d.deptno
ORDER BY e.deptno;

--분석함수를 통한 부서별 직원수(COUNT)
SELECT ename, empno, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--(실습 ana2)
SELECT empno, ename, sal, deptno, 
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

--(실습 ana3)
SELECT empno, ename, sal, deptno, 
       MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--(실습 ana4)
SELECT empno, ename, sal, deptno, 
       MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--부서별 사원번호가 가장 빠른 사람
--부서별 사원번호가 가장 느린 사람

--last_value의 정렬이 이상함 확인 필요
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) first_empno,
       LAST_VALUE(empno) OVER (PARTITION BY deptno) last_empno
FROM emp;

--LAG(이전행)
--현재행
--LEAD(다음행)
--급여가 높은순으로 정렬했을 때 자기보다 한단계 급여가 낮은 사람의 급여,
--                         자기보다 한단계 급여가 높은 사람의 급여

SELECT empno, ename, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

--(실습 ana5)
SELECT empno, ename, hiredate, sal,;


--(실습 ana6)
SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER (PARTITION BY job) lag_sal
FROM emp;

--(실습 no_ana3)
SELECT d.empno, d.ename, d.sal, (d.sal + c.sal) c_sum
FROM emp d, (SELECT a.ename, SUM(NVL(b.sal, 0)) sal
                                FROM emp a LEFT OUTER JOIN emp b ON (a.sal > b.sal)
                                GROUP BY a.ename) c
WHERE d.ename = c.ename
ORDER BY d.sal;  

--WINDOWING
--UNBOUNDED PRECDING : 현재 행을 기준으로 선행하는 모든 행
--CURRENT ROW : 현재 행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
       
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
       
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3

FROM emp;

--(실습 ana7)
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum  
FROM emp;

SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_num,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING ) row_num2,
       --ORDER BY 뒤에는 CURRNET ROW를 설정하지 않아도 기본값으로 자기행까지 적용한다.
       
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_num,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING ) range_num2
       --값이 같은 행은 하나로 본다
       
FROM emp;