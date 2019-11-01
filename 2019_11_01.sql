--복습
--WHERE
--연산자
-- 비교 : =, !=, <>, >= , <, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' ( % : 다수의 문자열과 매칭, _ : 정확히 한글자 매칭)
-- IS NULL ( !=NULL )
-- AND, OR, NOT 

--emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 정보조회
--BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD')
                   AND TO_DATE('1986/12/31', 'YYYY/MM/DD');
-- >=, <=                   
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1986/12/31', 'YYYY/MM/DD');          
  
--emp 테이블에서 관리자(mgr)이 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';

--where13
--emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 회원 정보 조회
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
   OR empno < 7900 AND empno >= 7800
   OR empno < 790 AND empno >= 780
   OR empno = 78;
   
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899
   OR empno BETWEEN 780 AND 789
   OR empno = 78;
   
--where14
SELECT *
FROM emp
WHERE job IN ('SALESMAN') 
   OR empno LIKE '78%' AND hiredate >= TO_DATE ('19810601', 'YYYYMMDD');
   
--order by 컬럼명 | 별칭 | 컬럼인덱스 [ASC | DESC]
--order by 구분은 WHERE절 다음에 기술
--WHERE 절이 없을 경우 FROM절 다음에 기술
--emp테이블을 ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC :default
--ASC를 안붙여도 위 쿼리와 동일한
SELECT *
FROM emp
ORDER BY ename; --ASC

--이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;

--job을 기준으로 내림차순으로 정렬, 
--만약 job이 같을 경우 사번(empno)으로 올림차순 정렬

SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--별칭으로 정렬하기
--사원 번호(empno), 사원명(empname), 연봉(sal * 12) as year_sal
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY 2;

--orderby1
SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

DESC dept;

--orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno ASC;

--oderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--oderby4
SELECT *
FROM emp
WHERE deptno IN (10, 30)
  AND sal > 1500
ORDER BY ename DESC;

SELECT ROWNUM, empno, ename
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2; --값을 불러오지 못한다. 1부터 값을 가져와야 한다.
--WHERE ROWNUM <= 10;

--emp 테이블에서 사번(empno), 이름(ename)을 급여기준으로 오름차순 정렬하고
--정렬된 결과순으로 ROWNUM
SELECT empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a ;

SELECT ROWNUM, aC.*
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) aC 
WHERE ROWNUM <= 10;
--WHERE ROWNUM 1 BETWEEN 1 AND 10;

--row_2
SELECT *
FROM
    (SELECT ROWNUM as RN, a.*
     FROM
        (SELECT empno, ename, sal
         FROM emp
         ORDER BY sal) a)
WHERE RN BETWEEN 11 AND 14;


--FUNCTION
--DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

--문자열 대소문자 관련 함수
--LOWER, UPPER, INITCAP
SELECT LOWER ('Hello, World'), UPPER ('Hello, World'),
       INITCAP ('hello, world')
FROM dual;


SELECT LOWER ('Hello, World'), UPPER ('Hello, World'),
       INITCAP ('hello, world')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

--개발자 SQL 칠거지악
--1. 좌변을 가공하지 말아라
--좌변(TABLE 외 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
--FUNCTION Based Index -> FBI

--CONCAT : 문자열 결합 - 두개의 문자열을 결합하는 함수
--SUBSTR : 문자열의 부분 문자열 (java : String.substring)
--LENGTH : 문자열의 길이
--INSTR : 
--
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') CONCAT,
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr1,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       --INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후의 표시)
       INSTR('HELLO, WORLD', 'O', 6) instr1,
       --LPAD(문자열, 전체 문자열 길이, 문자열이 전체문자열길이에 미치지 못할 경우 추가할 문자);
       LPAD('HELLO, WORLD', 15, '*') lapd,
       LPAD('HELLO, WORLD', 15) lapd1,
       RPAD('HELLO, WORLD', 15) rapd
       
FROM dual;