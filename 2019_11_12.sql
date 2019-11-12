SELECT *
FROM dept;

SELECT *
FROM customer;

DELETE dept WHERE deptno=99;
COMMIT;

INSERT INTO dept --�ش� ���̺��� ��� �÷��� ������ ��� �������� �ٸ� �÷��� ������ �� ���Ѽ� ���� ����
VALUES (99, 'DDIT', 'DAEJEON');

INSERT INTO dept (deptno, dname, loc)
VALUES (99, 'DDIT', 'DAEJEON');
COMMIT;

INSERT INTO customer
VALUES (99, 'DDIT');

DESC emp;

INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);

--��������� �� �����ϰ� �ʹٸ� Ŀ�� �������� �ϱ�


SELECT *
FROM emp
WHERE empno = 9999;

ROLLBACK;

DESC emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'ename';

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', sysdate, 2500, null, 40);

SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT *
FROM emp;
DELETE emp;


--SELECT ���(������)�� INSERT;
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;

--UPDATE
--UPDATE ���̺� SET �÷� = ��, �÷� = ��
--WHERE condition

UPDATE dept SET dname = '���IT', loc='ym'
WHERE deptno = 99;

ROLLBACK;

--������-���ݿ����� (�߱���Ʈ�����-13000, ���, �Ϲ�����, ������-650)
--�ֹι�ȣ ���ڸ�
UPDATE ��������̺� SET ��й�ȣ = �ֹι�ȣ���ڸ�
WHERE ����� ������ = '�����';

SELECT *
FROM emp;

--DELETE ���̺��
--WHERE condition
--�����ȣ�� 9999�� ������ emp���̺��� ����
DELETE emp
WHERE empno = 9999;

--�μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5��(4��)�� �����͸� ����
--10, 20 , 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
WHERE empno < 100;

SELECT *
FROM emp
WHERE empno < 100;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);

--LV1 --> LV3
SET TRANSACTION isolation LEVEL SERIALIZABLE;
INSERT INTO dept
values (99, 'ddit', 'daejeon');
ROLLBACK;
SELECT *
FROM dept;

--DDL : AUTO COMMIT, ROLLBACK�� �� �ȴ�.
--CREATE
CREATE TABLE ranger_new (
    ranger_no NUMBER, --���� Ÿ�� 
    ranger_name VARCHAR2(50), --���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);

DESC ranger_new;

--ddl�� rollback�� ������� �ʴ´�.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

SELECT *
FROM ranger_new;

--��¥Ÿ�Կ��� Ư�� �ʵ尡������
--ex) sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM') year1,
       EXTRACT(day FROM reg_dt) day,
       EXTRACT(year FROM reg_dt) year2,
       EXTRACT(MONTH FROM reg_dt) month
FROM ranger_new;

--��������
--DEPT ����ؼ� DEPT_TEST ����
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,--deptno �÷��� �ĺ��ڷ� ����
    dname varchar2(14),          --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������, null�� ���� ����.
    loc varchar2(13)
);
DESC dept_test;

--primary key���� ���� Ȯ��
--1.deptno�÷��� null�� �� �� ����.
--2.deptno�÷��� �ߺ��� ���� �� �� ����.

INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
    --������ �Ʊ�� �޸� � �÷��� �����ؾ� �ϴ��� �𸥴�. �׷��� ���� ������� �Ѵ�.
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

SELECT *
FROM dept_test;
ROLLBACK;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'DDIT', 'DAEJEON');
INSERT INTO dept_test VALUES(2, null, 'DAEJEON');

DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1, 'DDIT', 'DAEJEON');
INSERT INTO dept_test VALUES(2, 'DDIT', 'DAEJEON');
ROLLBACK;
