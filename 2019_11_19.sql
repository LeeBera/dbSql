--

SELECT *
FROM emp_test;

DROP TABLE emp_test;

--multiple insert�� ���� �׽�Ʈ ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺��� emp���̺�κ��� �����Ѵ�(CTAS)
--�����ʹ� �������� �ʴ´�.

CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1 = 2;

--INSERT ALL
--�ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual; 

--INSERT ������ Ȯ��
SELECT *
FROM emp_test;

--INSERT ALL �÷� ����
ROLLBACK;

INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

--multiple insert (conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    --������ ������� ���� ���� ���� �� mm,
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 as empno, 'brown' as ename FROM dual UNION ALL
SELECT 2 as empno, 'sally' as ename FROM dual;
--as ��������

SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

SELECT 1 empno, 'brown' ename FROM dual
UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

--INSERT FIRST
--���ǿ� �����ϴ� ù��° insert ������ ����
INSERT FIRST
 WHEN empno > 10 THEN
    INTO emp_test (empno) VALUES (empno)
 WHEN empno > 5 THEN
    INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual;

ROLLBACK;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

--empno�� 7369�� �����͸� emp ���̺�κ��� emp_test���̺� ����(insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp_test;

--emp���̺��� ������ �� emp_test���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ���
--emp_test.ename = ename || '_merge'������ update
--�����Ͱ� ���� ��쿡�� emp_test���̺� insert

MERGE INTO emp_test 
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN UPDATE SET ename = ename || '_merge'
WHEN NOT MATCHED THEN INSERT VALUES (emp.empno, emp.ename);

MERGE INTO emp_test 
USING (table || view )
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN UPDATE SET ename = ename || '_merge'
WHEN NOT MATCHED THEN INSERT VALUES (emp.empno, emp.ename);

--�ٸ� ���̺��� �ʰ� ���̺� ��ü�� ������ ���� ������ merge�ϴ� ���
ROLLBACK;

--empno = 1, ename = 'brown';
--empno�� ���� ���� ������ ename�� 'brown'���� update
--empno�� ���� ���� ������ �ű� insert

SELECT *
FROM emp_test;


MERGE INTO emp_test
USING dual
ON (emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE set ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');
    
SELECT 'X'
FROM emp_test
WHERE empno = 1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno = 1;

INSERT INTO emp_test VALUES (1, 'brown');


INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;

MERGE INTO emp_test a
USING using emp b
ON (a.empno = b.empno)

WHEN MATCHED THEN
UPDATE SET a.ename = b.ename || '_merge'

WHEN NOT MATCHED THEN
INSERT VALUES (b.empno, b.ename);

SELECT *
FROM emp_test;

MERGE INTO emp_test a
USING dual
ON (a.empno = 1)

WHEN MATCHED THEN
UPDATE SET a.ename = 'brown' || '_merge'

WHEN NOT matched THEN
INSERT VALUES (1, 'brown');
ROLLBACK;

--�ǽ� GROUP_AD1

SELECT null deptno, SUM(sal) sal
FROM emp

UNION ALL

SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

--rollup
--group by�� ���� �׷��� ����
--Group by ROLLUP
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷��� GROUP BY �Ͽ� UNION �� �Ͱ� ����
--ex : GROUP BY ROLLUP (job, deptno)
--  GROUP BY job, deptno
--  UNION
--  GROUP BY job
--  UNION
--  GROUP BY --> �Ѱ� (��� �࿡ ���� �׷��Լ� ����)

SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


--GROUPING SETS (col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷��� GROUP BY ���� �̿�ȴ�.

--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp���̺��� �̿��Ͽ� �μ��� �޿��հ�, ������(job)�� �޿����� ���Ͻÿ�

--�μ���ȣ, job, �޿��հ�
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null deptno, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));
