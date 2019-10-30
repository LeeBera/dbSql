-- SELECT : ��ȸ�� �÷� ���
--       - ��ü �÷� ��ȸ : *
--       - �Ϻ� �÷� : �ش� �÷��� ���� (,����)
-- FROM :  ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� �������.
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

--1) lprod ���̺��� ��� �÷���ȸ
SELECT *
FROM lprod;

--2) buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT buyer_id, buyer_name
FROM buyer;

--3) cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM cart;

--4) member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT mem_id, mem_pass, mem_name
FROM member;

-- ������ / ��¥����
-- date type + ���� : ���ڸ� ���Ѵ�
-- null�� ������ ������ ����� �׻� null �̴�.
SELECT userid, usernm, reg_dt, 
    reg_dt + 5 reg_dt_after5,
    reg_dt - 5 as reg_dt_before5 --table�� ������� �ͻӸ��ƴ϶� DB���� ���� ���� �ִ�.
FROM users;

--5) prod���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
-- �� prod_id -> id, prod_name -> name ���� �÷� ��Ī�� ����

SELECT prod_id id,
    prod_name name
FROM prod;

--6) 1prod ���̺��� 1prod_gu, 1prod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
-- �� 1prod_gu -> gu, 1prod_nm -> nm���� �÷� ��Ī�� ����)

SELECT lprod_gu gu,
    lprod_nm nm
FROM lprod;

--7) buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
-- �� buyer_id -> ���̾� ���̵�, buyer_name -> �̸����� �÷� ��Ī�� ����)
SELECT buyer_id ���̾���̵�,
    buyer_name as �̸�
FROM buyer;

-- ���ڿ� ����
-- java + --> sql ll
-- CONCAT(str, str) �Լ�
-- user���̺��� userid, usernm
SELECT userid, usernm, userid || usernm, CONCAT(userid, usernm)
FROM users;

-- ���ڿ� ���� �ǽ�_con1
-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        CONCAT('����� ���̵� : ', userid)
FROM users;

-- ���ڿ� ���� �ǽ� sel_con1
SELECT table_name, 
    'SELECT * FROM ' || table_name || ';' as QUERY
FROM user_tables;

-- desc table
desc emp;

-- desc table
-- ���̺� ���ǵ� �÷��� �˰� ���� ��
-- 1. desc
-- 2. SELECT * ........
desc emp;

SELECT *
FROM emp;

-- WHERE��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';

-- usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM users
WHERE usernm = '����';