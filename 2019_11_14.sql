SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';
--�������� Ȱ��ȭ /��Ȱ��ȭ
--� ���������� Ȱ��ȭ(��Ȱ��ȭ) ��ų ���??

--emp fk���� (dept���̺��� deptno�÷� ����)
--FK_EMP_DEPT ��Ȱ��ȭ

ALTER TABLE emp DISABLE CONSTRAINT fk_emp_dept;

--�������ǿ� ����Ǵ� �����Ͱ� ���� ���� ������?
INSERT INTO emp (empno, ename, deptno)
VALUES (9999, 'brown', 80);

--fk_emp_deptȰ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;

--�������ǿ� ����Ǵ� ������ (�Ҽ� �μ���ȣ�� 80���� ������)�� �����Ͽ� 
--�������� Ȱ��ȭ �Ұ�
DELETE emp
WHERE empno = 9999;

--�ٽ� �� �� fk_emp_deptȰ��ȭ
ALTER TABLE emp ENABLE CONSTRAINT fk_emp_dept;
COMMIT;

SELECT *
FROM emp;

--���� ������ �����ϴ� ���̺� ��� view : USER_TABLES
--���� ������ �����ϴ� �������� view : USER_CONSTRAINTS
--���� ������ �����ϴ� ���������� �÷� view : USER_CONS_COLUMNS

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CYCLE';

--fk_emp_dept
SELECT *
FROM USER_CONS_COLUMNS
WHERE CONSTRAINT_NAME = 'PK_CYCLE';

--���̺� ������ �������� ��ȸ (VIEW ����)
--���̺� �� / �������� �� / �÷��� / �÷� ������

SELECT a.table_name, a.constraint_name, b.column_name, b.position
FROM user_constraints a, user_cons_columns b
WHERE a.constraint_name = b.constraint_name
AND a.constraint_type = 'P' -- PRIMARY KEY�� ��ȸ
ORDER BY a.table_name, b.position;

--emp ���̺�� 8���� �÷� �ּ��ޱ�
--

--���̺� 

SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';

--emp ���̺� �ּ�
COMMENT ON TABLE emp IS '���';

--emp ���̺��� �÷� �ּ�
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

--EMPNO ENAME JOB MGR HIREDATE SAL COMM DEPTNO
COMMENT ON COLUMN emp.empno IS '�����ȣ';
COMMENT ON COLUMN emp.ename IS '�̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '������ ���';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '��';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';

--user_tab_comments, user_col_comments view�� �̿��Ͽ� 
--customer, product, cycle, daily ���̺�� �÷��� �ּ� ������ ��ȸ�ϴ� ������ �ۼ��϶�

--customer ���̺��� �÷� �ּ�
SELECT t.table_name, t.table_type, t.COMMENTS tab_comment, c.COLUMN_NAME, c.COMMENTS col_comment 
FROM user_col_comments c, user_tab_comments t
WHERE c.table_name IN ('CUSTOMER', 'PRODUCT', 'CYCLE', 'DAILY')
AND t.TABLE_NAME = c.TABLE_NAME;

--VIEW ���� (emp���̺��� sal, comm �ΰ� �÷��� �����Ѵ�.)
CREATE OR REPLACE VIEW v_emp AS 
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--INLINE VIEW
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno FROM emp);

--VIEW( �� �ζ��κ�� �����ϴ�.
SELECT *
FROM v_emp;

--���ε� ���� ����� view�� ���� : v_emp_dept
--emp, dept : �μ���, �����ȣ, �����, ������, �Ի�����
CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT a.dname, b.empno, b.ename, b.job, b.hiredate
FROM dept a, emp b
WHERE a.deptno = b.deptno;

SELECT *
FROM v_emp_dept;

--VIEW ����
DROP VIEW v_emp;

--VIEW�� �����ϴ� ���̺��� �����͸� �����ϸ� VIEW���� ������ ����.
--dept 30 - SALES
SELECT *
FROM v_emp_dept;

--dept���̺��� SALES --> MARKET SALES
UPDATE dept SET dname = 'MARKET SALES'
WHERE deptno = 30;

SELECT * --�̰͸� �ٲ�°� �ƴ϶�
FROM dept;

SELECT * --�굵 �ٲ� �ֳĸ� ��� �׳� ���̺��� ���� �����Ǵ°� �ƴ϶� ��ȸ�ϴ� ���̱� �����̴�.
FROM v_emp_dept;

ROLLBACK;

--HR �������� v_emp_dept view ��ȸ������ �ش�)
GRANT SELECT ON v_emp_dept to hr;

--SEQUENCE ���� (�Խñ� ��ȣ �ο��� ������)
CREATE SEQUENCE seq_post
INCREMENT BY 1
START WITH 1;


SELECT seq_post.nextval, seq_post.currval
FROM dual;


SELECT seq_post.currval
FROM DUAL;

SELECT *
FROM post
WHERE reg_id = 'Brown'
AND title = '�������� ����ִ�.'
AND reg_dt = TO_DATE('2019//11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE reg_id = 'Brown'
AND title = '�������� ����ִ�.'
AND reg_dt = TO_DATE('2019//11/14 15:40:15', 'YYYY/MM/DD HH24:MI:SS');

SELECT *
FROM post
WHERE post_id = 1;

--index
--rowid : ���̺� ���� ������ �ּ�, �ش� �ּҸ� �˸� ������ ���̺� �����ϴ� ���� �����ϴ�.

SELECT product.*, ROWID
FROM product
WHERE ROWID = 'AAAFTEAAFAAAAFLAAA';

--table : pid, pnm
--pk_product : pid
SELECT pid
FROM product
WHERE ROWID = 'AAAFTEAAFAAAAFLAAA';


--������ ����
--������ : �ߺ����� ���� ���� ���� ���� ���ִ� ��ü
--1, 2, 3, .........

DESC emp_test;
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(15)
);

--INSERT INTO emp_test VALUE (�ߺ����� �ʴ� ��, 'brown');

--������ ����
CREATE SEQUENCE seq_emp_test;

INSERT INTO emp_test VALUES (seq_emp_test.nextval, 'brown');

SELECT *
FROM emp_test;

--��� ROLLBACK �Ұ�
SELECT seq_emp_test.nextval
FROM dual;
ROLLBACK;

--�����ȹ�� ���� �ε��� ��뿩�� Ȯ��;
--emp ���̺� empno�÷��� �������� �ε����� ���� ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno =7369;

--�ε����� ���� ������ empno=7369�� �����͸� ã�� ����
--emp ���̺� ��ü�� ã�ƺ��� �Ѵ�. => TABLE FULL SCAN

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    37 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    37 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 --1������ �а� 0���� �д´�
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)