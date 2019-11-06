--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� �ܷΰ� ���� ����
--sum, MAX, MIN, AVG, COUNT
--GROUP BY col : express
--SELECT ������ GROUP BY ���� ����� col, express ǥ�� ����

--���� �� ���� ���� �޿� ��ȸ
--14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ��� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--grp3
SELECT DECODE(deptno, 10, 'ACCOUNTING' , 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') AS dname, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;
--������ ���.

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
--emp ���̺��� dname �÷��� ����. --> �μ���ȣ(deptno)�ۿ� ����
desc emp;

--emp���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
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

--ansi natural join : ���̺��� �÷����� ���� �÷��� �������� join
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

--from ���� ���� ��� ���̺� ����
--where���� �������� ���
--������ ����ϴ� ���� ���൵ �������
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job = 'SALESMAN';--job�� SALES�� ����� ������� ��ȸ

SELECT emp.empno, emp.ename, dept.dname
FROM dept, emp
WHERE emp.job = 'SALESMAN'
AND emp.deptno = dept.deptno;

--JOIN wiht ON(�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF join : ���� ���̺��� ����
--emp���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
--a :��������, b:������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno 
AND a.empno BETWEEN 7369 AND 7698;

--non-equaljoing(��� ������ �ƴ� ���)
SELECT *
FROM salgrade;

--������ �޿� �����????
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