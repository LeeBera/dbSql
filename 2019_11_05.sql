--��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
--201911 --> 30 / 201912 --> 31

--�Ѵ� ���� �� �������� ���� = �ϼ�
--��������¥ ���� �� --> DD�� ����
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
--NVL(coll, coll�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, NVL(comm, 0) nvl_comm,
        sal + comm, sal + NVL(comm, 0),
        NVL(sal + comm, 0)
FROM emp;

--NVL2(coll, coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm, comm, 0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 ������ null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--�Լ� ������ null�� �ƴ� ù��° ����
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;

--FUNCTION
--emp���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���
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
        WHEN MOD(TO_CHAR(sysdate, 'YYYY')-TO_CHAR(hiredate, 'YYYY'), 2) = 0 THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END AS CONTACTTODOCTOR
FROM emp;

--���ذ� ¦�����ΰ�? Ȧ�����ΰ�?
--1. ���� �⵵ ���ϱ�(DATE ==> TO_CHAR(DATE, FORMAT))
--2. ���� �⵵�� ¦������ ���
-- � ���� 2�� ������ �������� �׻� 2���� �۴�
-- 2�� ������� �������� 0, 1
-- MOD(���, ������)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM dual;

--emp ���̺��� �Ի����ڰ� Ȧ�������� ¦�������� Ȯ��
SELECT empno, ename, hiredate,
    CASE
     WHEN MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2) THEN '�ǰ����� ���'
     ELSE '�ǰ����� ����'
    END CONTACTTODOCTOR
FROM emp;

--cond3
SELECT userid, usernm, alias, reg_dt, 
    CASE
        WHEN MOD(TO_CHAR(sysdate, 'YYYY')-TO_CHAR(reg_dt, 'YYYY'), 2) = 0 THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END AS CONTACTTODOCTOR
FROM users;

--group function(AVG, MAX, MIN, SUM, COUNT)
--�׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
--SUM(comm), COUNT(*), COUNT(mgr)
--���� �� ���� ���� �޿��� �޴� ����� �޿�
--���� �� ���� ���� �޿��� �޴� ����� �޿�
--������ �޿� ���(�Ҽ��� ��°¥�������� ������ ==> �Ҽ��� ��°�ڸ����� �ݿø�)
--������ �޿� ��ü ��
--������ ��
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt, --���� null�̸� ī��Ʈ ���Ѵ�.
       COUNT(mgr) mgr_cnt,
       SUM(comm)--�׷��Լ������� null���� ���� �����ϱ� ������ null���� �ִ� �÷��� �־ ���갪�� null�� ���� �ʴ´�.
FROM emp;

SELECT empno, ename, sal
FROM emp
order by sal;

--�μ��� ���� ���� �޿��� �޴� ����� �޿�
--GROUP BY ���� ������� ���� �÷��� SELECT ���� ����� ��� ����
SELECT deptno, ename, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT deptno, MAX(ename), MAX(sal) max_sal
FROM emp
GROUP BY deptno;



--�׷�ȭ�� ���þ��� ������ ���ڿ�, ����� �� �� �ִ�.
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal, SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt, --���� null�̸� ī��Ʈ ���Ѵ�.
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
       --�׷��Լ������� null���� ���� �����ϱ� ������ null���� �ִ� �÷��� �־ ���갪�� null�� ���� �ʴ´�.
FROM emp;
GROUP BY deptno;

--�μ��� �ִ� �޿�
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

