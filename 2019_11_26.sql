SELECT ename, sal, deptno, 
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--(�ǽ� ana1)
--����� ��ü �޿� ������ rank, dense_rank, row_number�� �̿�
--�� �޿��� ������ ��� ����� ���� ����� ���� ������ �ǵ��� �ۼ��ϼ���.
SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC, empno) rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;

--(�ǽ� no_ana2)
--��� ����� ���� �����ȣ, ����̸�, �ش� ����� ���� �μ��� ��� ���� ��ȸ�ϴ� ����

SELECT e.empno, e.ename, e.deptno, d.cnt
FROM emp e, (SELECT deptno, COUNT(*) cnt
            FROM emp a
            GROUP BY deptno) d
WHERE e.deptno = d.deptno
ORDER BY e.deptno;

--�м��Լ��� ���� �μ��� ������(COUNT)
SELECT ename, empno, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

SELECT ename, empno, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--(�ǽ� ana2)
SELECT empno, ename, sal, deptno, 
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;

--(�ǽ� ana3)
SELECT empno, ename, sal, deptno, 
       MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--(�ǽ� ana4)
SELECT empno, ename, sal, deptno, 
       MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

--�μ��� �����ȣ�� ���� ���� ���
--�μ��� �����ȣ�� ���� ���� ���

--last_value�� ������ �̻��� Ȯ�� �ʿ�
SELECT empno, ename, deptno,
       FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) first_empno,
       LAST_VALUE(empno) OVER (PARTITION BY deptno) last_empno
FROM emp;

--LAG(������)
--������
--LEAD(������)
--�޿��� ���������� �������� �� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                         �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�

SELECT empno, ename, sal, 
       LAG(sal) OVER (ORDER BY sal) lag_sal,
       LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

--(�ǽ� ana5)
SELECT empno, ename, hiredate, sal,;


--(�ǽ� ana6)
SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER (PARTITION BY job) lag_sal
FROM emp;

--(�ǽ� no_ana3)
SELECT d.empno, d.ename, d.sal, (d.sal + c.sal) c_sum
FROM emp d, (SELECT a.ename, SUM(NVL(b.sal, 0)) sal
                                FROM emp a LEFT OUTER JOIN emp b ON (a.sal > b.sal)
                                GROUP BY a.ename) c
WHERE d.ename = c.ename
ORDER BY d.sal;  

--WINDOWING
--UNBOUNDED PRECDING : ���� ���� �������� �����ϴ� ��� ��
--CURRENT ROW : ���� ��
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
       
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
       
       SUM(sal) OVER (ORDER BY sal, empno 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3

FROM emp;

--(�ǽ� ana7)
SELECT empno, ename, deptno, sal, 
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum  
FROM emp;

SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_num,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING ) row_num2,
       --ORDER BY �ڿ��� CURRNET ROW�� �������� �ʾƵ� �⺻������ �ڱ������ �����Ѵ�.
       
       SUM(sal) OVER (ORDER BY sal RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_num,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING ) range_num2
       --���� ���� ���� �ϳ��� ����
       
FROM emp;