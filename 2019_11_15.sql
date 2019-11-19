--emp 테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
--PRIMARY KEY = UNIGUE + NOT NULL
--UNIQUE ==> 해당 컬럼으로 UNIQUE INDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    37 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    37 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 --2 -> 1 -> 0 거꾸로 거슬러 올라간다.
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
   --유니크한 인덱스 값으로 데이터를 조회한다.
   
--empno 컬럼으로 인덱스가 존재하는 상황에서 다른 컬럼 값으로 데이터를 조회하는 경우

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   111 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   111 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
   --데이터를 조회하기 위해서 job컬럼의 데이터를 처음부터 끝까지 읽은 다음 MANAGER에 해당하는 값만 남기고 다 버린다.
   
--TABLE 생성 (제약조건이 없고 인덱스를 별도로 생성 X)
--> TABLE ACCESS FULL

--첫번째 인덱스
--> TABLE ACCESS FULL
--> 첫번째 인덱스

--두번째 인덱스
--> TABLE ACCESS FULL
--> 첫번째 인덱스
--> 두번째 인덱스

--세번째 인덱스
--> TABLE ACCESS FULL
--> 첫번째 인덱스
--> 두번째 인덱스
--> 세번째 인덱스


--인덱스 구성 컬럼만 SELECT 절에 기술한 경우
--테이블 접근이 필요없다. 그래서 두 줄로 끝남(0과 1)

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
   
--pk를 만들어도 unique가 되기 때문에 자동적으로 unique 인덱스가 만들어진다.

----------------------------------------------

--컬럼에 중복이 가능한 non-unique 인덱스 생성 후 
--unique index와의 실행계획 비교
--PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   --인덱스를 생성하면 테이블 안의 데이터는 자동정렬된다.
   --정렬이 되어있으므로 같은 값이 있는지 밑에 있는 데이터 한개값을 더 읽어본다. 만약 다르다면 거기서 끝나고
   --같다면 그 다음 데이터를 또 읽어본다.(같은 값이 더 있는지 확인하기 위해)
   
--emp 테이블에 job컬럼으로 두번째 인덱스 생성 (non-unique index)
--job 컬럼은 다른 로우의 job컬럼과 중복이 가능한 컬럼이다.
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   111 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   111 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
   
   
   
--emp 테이블에 job, ename 컬럼을 기준으로 non-unique 인덱스 생성
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
    
--emp 테이블에 ename, job 컬럼으로 non_unique 인덱스 생성
CREATE INDEX IDX_EMP_04 ON emp (ename, job);

--HINT를 상용한 실행계획 제어
--힌트는 문법적으로 옳을 경우에만 실행이 되고 아닐 경우는 무시된다.
EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp IDX_EMP_01 ) */ *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE '%C';

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT /*+ INDEX ( emp IDX_EMP_01 ) */*
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--INDEX 실습 idx1
DROP TABLE dept_test;
SELECT *
FROM dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1;

--ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);
CREATE UNIQUE INDEX idx_u_dept_test_03 ON dept_test (deptno);
CREATE INDEX idx_dept_test_01 ON dept_test (dname);
CREATE INDEX idx_dept_test_02 ON dept_test (deptno, dname);

--INDEX 실습 idx2
--ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
DROP UNIQUE INDEX idx_u_dept_test_03;
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;

ALTER TABLE emp DROP CONSTRAINT FK_EMP_DEPT;
ALTER TABLE emp DROP CONSTRAINT SYS_C007053;
DROP INDEX IDX_EMP_01;
DROP INDEX IDX_EMP_02;
DROP INDEX IDX_EMP_03;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT *
FROM emp;

--deptno, mgr 
