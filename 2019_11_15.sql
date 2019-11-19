--emp ���̺� empno�÷��� �������� PRIMARY KEY�� ����
--PRIMARY KEY = UNIGUE + NOT NULL
--UNIQUE ==> �ش� �÷����� UNIQUE INDEX�� �ڵ����� ����

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
 --2 -> 1 -> 0 �Ųٷ� �Ž��� �ö󰣴�.
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
   --����ũ�� �ε��� ������ �����͸� ��ȸ�Ѵ�.
   
--empno �÷����� �ε����� �����ϴ� ��Ȳ���� �ٸ� �÷� ������ �����͸� ��ȸ�ϴ� ���

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
   --�����͸� ��ȸ�ϱ� ���ؼ� job�÷��� �����͸� ó������ ������ ���� ���� MANAGER�� �ش��ϴ� ���� ����� �� ������.
   
--TABLE ���� (���������� ���� �ε����� ������ ���� X)
--> TABLE ACCESS FULL

--ù��° �ε���
--> TABLE ACCESS FULL
--> ù��° �ε���

--�ι�° �ε���
--> TABLE ACCESS FULL
--> ù��° �ε���
--> �ι�° �ε���

--����° �ε���
--> TABLE ACCESS FULL
--> ù��° �ε���
--> �ι�° �ε���
--> ����° �ε���


--�ε��� ���� �÷��� SELECT ���� ����� ���
--���̺� ������ �ʿ����. �׷��� �� �ٷ� ����(0�� 1)

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
   
--pk�� ���� unique�� �Ǳ� ������ �ڵ������� unique �ε����� ���������.

----------------------------------------------

--�÷��� �ߺ��� ������ non-unique �ε��� ���� �� 
--unique index���� �����ȹ ��
--PRIMARY KEY �������� ����(unique �ε��� ����)
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
   --�ε����� �����ϸ� ���̺� ���� �����ʹ� �ڵ����ĵȴ�.
   --������ �Ǿ������Ƿ� ���� ���� �ִ��� �ؿ� �ִ� ������ �Ѱ����� �� �о��. ���� �ٸ��ٸ� �ű⼭ ������
   --���ٸ� �� ���� �����͸� �� �о��.(���� ���� �� �ִ��� Ȯ���ϱ� ����)
   
--emp ���̺� job�÷����� �ι�° �ε��� ���� (non-unique index)
--job �÷��� �ٸ� �ο��� job�÷��� �ߺ��� ������ �÷��̴�.
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
   
   
   
--emp ���̺� job, ename �÷��� �������� non-unique �ε��� ����
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
    
--emp ���̺� ename, job �÷����� non_unique �ε��� ����
CREATE INDEX IDX_EMP_04 ON emp (ename, job);

--HINT�� ����� �����ȹ ����
--��Ʈ�� ���������� ���� ��쿡�� ������ �ǰ� �ƴ� ���� ���õȴ�.
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

--INDEX �ǽ� idx1
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

--INDEX �ǽ� idx2
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
