--���̺��� ������ ��ȸ

/*
    SELECT �÷� : express (���ڿ����) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/

DESC user_tables;
SELECT table_name, 
    'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';
--��ü�Ǽ� - 1

--���ں� ����
--�μ���ȣ�� 30������ ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

SELECT *
FROM dept;

--�μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY');

SELECT *
FROM emp
WHERE hiredate < '82/01/01';

--col BETWEEN X AND Y ����
--�÷��� ���� X���� ũ�ų� ����, Y���� �۰ų� ���� ������
--�޿�(sal)�� 1000���� ũ�ų� ����, Y���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����.
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000
AND deptno = 30;

--���ǿ� �´� ������ ��ȸ�ϱ�(BETWEEN ...AND...�ǽ� where1)
--emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�� �����ڴ� between�� ����Ѵ�.

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYY/MM/DD') AND TO_DATE('19830101', 'YYYY/MM/DD');


--���ǿ� �´� ������ ��ȸ�ϱ�(>=, >, <=, < �ǽ� whtere2)
--emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�� �����ڴ� �񱳿����ڸ� ����Ѵ�.

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYY/MM/DD') 
AND hiredate <= TO_DATE('19830101', 'YYYY/MM/DD');

--IN ������
--COL IN (values...)
--�μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ

SELECT *
FROM emp
WHERE deptno in (10, 20);

--IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;

--���ǿ� �´� ������ ��ȸ�ϱ�(IN �ǽ� where3)
--users ���̺��� userid�� bown, cony, sally�� �����͸� ������ ���� ��ȸ�Ͻÿ�
--IN ������ ���
SELECT userid ���̵�,
    usernm �̸�,
    alias ����
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

--LIKE 'S%'
--COL�� ���� �빮�� S�� �����ϴ� ��� ��
--COL LIKE 'S____'
--COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

--emp ���̺��� �����̸��� S�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S_____';

--���ǿ� �´� ������ ��ȸ�ϱ�(LIKE, %, _ �ǽ� where4)
--member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��__';

--���ǿ� �´� ������ ��ȸ�ϱ�(LIKE, %, _ �ǽ� where5)
--member ���̺��� ȸ���� �̸��� ����[��]�� ���� ��� ����� mem_id, mem_name�� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

--NULL ��
--col IS NULL
--EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;
--WHERE mgr !=null;

--�Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10'; 

--(=, !=)
-- is null is mot null

--���ǿ� �´� ������ ��ȸ�ϱ� (IS NULL �ǽ� where 6)
--emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�.
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--AND/OR
--������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;

--emp ���̺��� ������(mgr) ����� 7698�̰ų�
--    �޿�(sal)�� 1000 �̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;

--emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839); -- IN --> AND


  
--���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
--IN< NOT IN �������� NULL ó��
--emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� null�� �ƴ� ������ ��ȸ

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
  AND mgr IS NOT NULL;

--������(AND< OR �ǽ� where7
--emp ���̺��� job�� SALESMAN �̰� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���

DESC emp;

SELECT *
FROM emp
WHERE job IN ('SALESMAN')
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--������(AND, OR �ǽ� where8)
--emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
--(IN< NOT IN ������ ������)

SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');



--������(AND, OR �ǽ� where9)
--emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
--(IN,  NOT IN ������ ���)

SELECT *
FROM emp
WHERE deptno NOT IN 10
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--������(AND, OR �ǽ� where10)
--emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���.
--(�μ��� 10, 20, 30�� �ִٰ� �����ϰ� IN �����ڸ� ���)

SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');


--������(AND, OR �ǽ� where11)
--emp ���̺��� job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ ������ ������ ������ ���� ��ȸ�ϼ���

SELECT *
FROM emp
WHERE job in ('SALESMAN')
OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--������(AND, OR �ǽ� where12)
--emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ ������ ���� ��ȸ �ϼ���
SELECT *
FROM emp
WHERE job in ('SALESMAN')
OR empno LIKE '78%';

