--GROUPING (cube, rollup���� ���� �÷�)
--�ش� �÷��� �Ұ� ��꿡 ���� ��� 1
--������ ���� ��� 0

--job�÷�
--case1. GROUPING(job) = 1 AND GROUPING(deptno) = 1
--       job --> '�Ѱ�'
--case else
--       job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
        END job, 
        CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job || ' �Ұ�'
            ELSE deptno || ''
        END deptno,
        GROUPING(job), GROUPING(deptno), SUM(sal) sal
FROM emp
GROUP BY ROLLUP (job, deptno);


--(�ǽ� GROUP_AD3)
SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno, job)
ORDER BY deptno, job;

--(�ǽ� GROUP_AD4)
SELECT d.dname, e.job, SUM(e.sal)
FROM dept d, (SELECT *
              FROM emp
              ORDER BY deptno, job) e
WHERE d.deptno = e.deptno
GROUP BY ROLLUP (d.dname, e.job)
ORDER BY d.dname, e.job DESC;

--(�ǽ� GROUP_AD5)
SELECT CASE 
        WHEN GROUPING(d.dname) = 1 AND
             GROUPING(e.job) = 1 THEN '����'
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
--CUBE ���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
--GROUP BY CUBE(job, deptno)
--oo : GROUP BY job, deptno
--ox : GROUP BY job
--xo : GROUP By detpno
--XX : GROUP BY --��� �����Ϳ� ���ؼ�...

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

--(�������� ADVANCED)
SELECT *
FROM emp;
SELECT *
FROM emp_test;

DROP TABLE emp_test;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
CREATE TABLE emp_test AS 
SELECT *
FROM emp;

--emp_test ���̺��� dept���̺��� �����ǰ��ִ� dname �÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test���̺��� dname�÷��� dept���̺��� dname�÷� ������ ������Ʈ

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE dept.deptno = emp_test.deptno);
--WHERE empno IN (7369, 7499); --�� ����
COMMIT;

SELECT *
FROM dept_test;

DROP TABLE dept_test;

--dept���̺��� �̿��Ͽ� dept_test���̺� ����
CREATE TABLE dept_test AS
SELECT *
FROM dept;

--dept_test���̺� empcnt (number) �÷� �߰�
ALTER TABLE dept_test ADD (empcnt NUMBER);

SELECT *
FROM dept_test;

--subquery�� �̿��Ͽ� dept_test���̺��� empcnt�÷��� 
--�ش� �μ��� ���� update������ �ۼ��ϼ���.
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp WHERE dept_test.deptno = emp.deptno);

SELECT deptno, COUNT(*) 
FROM emp
GROUP BY deptno;

SELECT *
FROM dept_test;

SELECT *
FROM dept_test;

--������ ���� �μ��� ������.
DELETE dept_test
WHERE NOT EXISTS (SELECT 'x' FROM emp e WHERE dept_test.deptno = e.deptno);

--�ι�° ���
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

--(�ǽ� sub_a3)
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

--emp, emp_test empno�÷����� ���� ������ ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;

--2. emp.empno, emp.ename, emp.sal, emp_test.sal, �ش���(emp���̺� ����)�� ���� �μ��� �޿����
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