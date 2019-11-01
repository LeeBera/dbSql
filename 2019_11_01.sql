--����
--WHERE
--������
-- �� : =, !=, <>, >= , <, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' ( % : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL ( !=NULL )
-- AND, OR, NOT 

--emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ���� ������ȸ
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
  
--emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';

--where13
--emp���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ȸ�� ���� ��ȸ
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
   
--order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
--order by ������ WHERE�� ������ ���
--WHERE ���� ���� ��� FROM�� ������ ���
--emp���̺��� ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

--ASC :default
--ASC�� �Ⱥٿ��� �� ������ ������
SELECT *
FROM emp
ORDER BY ename; --ASC

--�̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ������������ ����, 
--���� job�� ���� ��� ���(empno)���� �ø����� ����

SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--��Ī���� �����ϱ�
--��� ��ȣ(empno), �����(empname), ����(sal * 12) as year_sal
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷� ���� �ε����� ����
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
WHERE ROWNUM = 2; --���� �ҷ����� ���Ѵ�. 1���� ���� �����;� �Ѵ�.
--WHERE ROWNUM <= 10;

--emp ���̺��� ���(empno), �̸�(ename)�� �޿��������� �������� �����ϰ�
--���ĵ� ��������� ROWNUM
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
--DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

--���ڿ� ��ҹ��� ���� �Լ�
--LOWER, UPPER, INITCAP
SELECT LOWER ('Hello, World'), UPPER ('Hello, World'),
       INITCAP ('hello, world')
FROM dual;


SELECT LOWER ('Hello, World'), UPPER ('Hello, World'),
       INITCAP ('hello, world')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';

--������ SQL ĥ������
--1. �º��� �������� ���ƶ�
--�º�(TABLE �� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
--FUNCTION Based Index -> FBI

--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
--LENGTH : ���ڿ��� ����
--INSTR : 
--
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') CONCAT,
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr1,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       --INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ������ ǥ��)
       INSTR('HELLO, WORLD', 'O', 6) instr1,
       --LPAD(���ڿ�, ��ü ���ڿ� ����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���� ��� �߰��� ����);
       LPAD('HELLO, WORLD', 15, '*') lapd,
       LPAD('HELLO, WORLD', 15) lapd1,
       RPAD('HELLO, WORLD', 15) rapd
       
FROM dual;