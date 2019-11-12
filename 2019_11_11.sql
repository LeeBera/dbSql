--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
   OR deptno = 30;
   
SELECT *
FROM emp 
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN ('SMITH', 'WARD'));
                 
SELECT *
FROM emp 
WHERE deptno in (SELECT deptno 
                 FROM emp 
                 WHERE ename IN (:name1, :name2));

--ANY : set�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
--SMITH, WARD �λ���� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < any (SELECT sal --800, 1250 --> 1250���� ���� �޿��� �޴� ���
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
--SMITH�� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp
WHERE sal > all (SELECT sal --800, 1250 --> 1250���� ���� �޿��� �޴� ���
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));
                 
--NOT IN
--�������� ��������
--.mgr �÷��� ���� ������ ����
SELECT DISTINCT mgr
FROM emp;

--� ������ ������ ������ �ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE empno IN (7839, 7782, 7698, 7902, 7566, 7788);

SELECT *
FROM emp
WHERE empno IN (SELECT mgr
                FROM emp);
                
--�����ڿ����� ���� �ʴ� ������� ������ȸ
--�� NOT IN������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó����
SELECT *
FROM emp    --7839, 7782, 7698, 7902, 7566, 7788 ���� 6���� ����� ���Ե��� �ʴ� ����
WHERE empno NOT IN (SELECT mgr
                    FROM emp 
                    WHERE emp is NOT NULL);

SELECT *
FROM emp    --7839, 7782, 7698, 7902, 7566, 7788 ���� 6���� ����� ���Ե��� �ʴ� ����
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);
                    
--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
--7698 30
--7839 10
SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);
--���� �߿� �����ڿ� �μ���ȣ�� (7698, 30) �̰ų�, (7839, 10)�� ���
--mgr, deptno �÷��� (����)�� ������Ű�� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
--7698 30
--7839 10
--(7698 30) (7698 10) 
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                        FROM emp
                        WHERE empno IN (7499, 7782))
AND deptno IN (SELECT deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
--SCALAR : supquery : SELECT ���� �����ϴ� ���� ����(�� ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, '�μ���' dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;


--sub4 ������ ����
SELECT *
FROM dept;
INSERT INTO dept VALUES (99, 'ddit', 'daejeon');
COMMIT;

SELECT DISTINCT deptno
FROM emp;

SELECT deptno
FROM emp;

SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);

--sub5                
SELECT pid, pnm
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);

SELECT *
FROM cycle
WHERE cid = 2;

SELECT *
FROM cycle
WHERE cid = 1;

--sub6
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);

--sub7
SELECT cycle.cid, customer.CNM, cycle.pid, product.PNM, cycle.day, cycle.cnt
FROM cycle, product, customer
WHERE cycle.PID = product.pid
AND cycle.cid = customer.cid
AND cycle.cid = 1
AND cycle.pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);

SELECT *
FROM customer;
SELECT *
FROM cycle;
SELECT *
FROM product;

--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� ������ �����ϸ� ���̻� �������� �ʰ� ���߱� ������
--���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp--emp�� ���ΰ� ��ġ�� ������ �� �� �ϳ��� ��Ī�� �־�� �Ѵ�.
              WHERE empno = a.mgr);
              
--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
              FROM emp--emp�� ���ΰ� ��ġ�� ������ �� �� �ϳ��� ��Ī�� �־�� �Ѵ�.
              WHERE empno = a.mgr);

--sub8
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--sub9
--EXISTS������ �̿��ؼ� Ǯ��
SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X'
              FROM cycle
              WHERE cid = 1
              AND pid = p.pid);

--���������θ� Ǯ��
SELECT *
FROM product p
WHERE p.pid NOT IN (SELECT c.pid
                    FROM cycle c
                    WHERE c.cid = 1);



--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)
SELECT *
FROM dept
WHERE deptno IN (10, 20, 30);

SELECT *
FROM dept
WHERE EXISTS (SELECT 'X'
             FROM emp
             WHERE deptno = dept.deptno);
             
--IN���� �ϴ� ��             
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
                 FROM emp);
                 
--���տ���
--����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--����� 7369, 7499�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7369 OR empno = 7499;


--����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION --������, �ߺ��� ����
--      DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����
--      (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : UNION�� ���� ����
--            �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--            UNION �����ں��� ���ɸ鿡�� ����
--����� 7566, 7499�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7499;



--UNION ALL
--����� 7566 �Ǵ� 7698�� ��� ��ȸ (����̶�, �̸�)
SELECT empno, ename
FROM emp
WHERE empno IN(7566, 7698)
UNION ALL
---����� 7566, 7698�� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;


--INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
--7369	SMITH
--7499	ALLEN

SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);




--MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
--������ ����
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499);


SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698, 7369);

SELECT 1 n, 'x' m
FROM dual
union
SELECT 2, 'y'
FROM dual
ORDER BY m DESC;--ORDER BY ��ġ �� �����ֱ�

