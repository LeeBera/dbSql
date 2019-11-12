--���κ���
--������ �� ���°�? 
--RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
--EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ������� �μ���ȣ�� ���� �ְ�, �μ���ȣ�� ���� dept���̺��
--������ ���� ��� �μ��� ������ ������ �� �ִ�.

--���� ��ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
--emp, dept
SELECT emp.empno, emp.ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���
--COUNT(col) : col ���� �����ϸ� 1, null : 0
--             ����� �ñ��� ���̸� *
SELECT dept.deptno, dname, COUNT(*) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dept.deptno, dname;

SELECT *
FROM dept;

--TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;


--OUTER JOIN : ���ο� �����ص� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� �������� �ϴ� ���� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ������ �ǵ��� �ϴ� ���� ����
--RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ���� ����
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

--���� ������, �ش� ������ ������ ���� outer join
--���� ��ȣ, �����̸�, ������ ��ȣ, ������ �̸�
--ANSI
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

--ORACLE
--LEFT, RIGHT�� ���� fullouter�� �������� ����
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, a.ename
FROM emp a LEFT OUTER JOIN emp b 
ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b 
ON (a.mgr = b.empno)
WHERE b.deptno = 10;

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

--ORACLE outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� outer join�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);

select *
from buyprod;

--outerjoin1
SELECT TO_CHAR(b.buy_date, 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, b.buy_qty buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

SELECT TO_CHAR(b.buy_date, 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, b.buy_qty buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id)
WHERE b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin2
SELECT TO_CHAR(TO_DATE('05/01/25', 'YY/MM/DD'), 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, b.buy_qty buy_qty
FROM buyprod b, prod p 
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin3
SELECT TO_CHAR(TO_DATE('05/01/25', 'YY/MM/DD'), 'YY/MM/DD') buy_date, b.buy_prod buy_prod, p.prod_id prod_id, p.prod_name prod_name, NVL(b.buy_qty, 0) buy_qty
FROM buyprod b, prod p 
WHERE b.buy_prod(+) = p.prod_id 
AND b.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin4
SELECT *
FROM cycle;

SELECT *
FROM product;

--outerjoin4
SELECT p.pid, p.pnm, NVL(c.cid, 1), NVL(c.day, 0), NVL(c.cnt, 0)
FROM cycle c RIGHT OUTER JOIN product p ON (c.pid = p.pid AND c.cid = 1);

SELECT p.pid, p.pnm, NVL(c.cid, 1), NVL(c.day, 0), NVL(c.cnt, 0)
FROM cycle c, product p 
WHERE c.pid(+) = p.pid 
AND c.cid(+) = 1;

--outerjoin5
SELECT p.pid, p.pnm, NVL(c.cid, 1), NVL(c.day, 0), NVL(c.cnt, 0)
FROM cycle c, product p 
WHERE c.pid(+) = p.pid 
AND c.cid(+) = 1;

--outerjoin6
SELECT a.pid, a.pnm, a.cid, ct.cnm, a.day, a.cnt
FROM
    (SELECT p.pid, p.pnm, NVL(c.cid, 1) cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
    FROM cycle c, product p 
    WHERE c.pid(+) = p.pid 
    AND c.cid(+) = 1) a, customer ct
WHERE a.cid = ct.cid;

--crossjoin1
SELECT * 
FROM customer, product;

SELECT *
FROM customer CROSS JOIN product;

--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ :
--SELECT - scalar subquery(�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �������� �Ѵ�.)
--FROM - inline view
--WHERE - subquery

--SCALAR SUBQUERY
SELECT empno, ename, sysdate now /*���糯¥*/
FROM emp;

SELECT empno, ename, (SELECT sysdate FROM dual) /*���糯¥*/
FROM emp;

SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
--�����ڰ� 7788�� ������ ����������


--sub1
--��ձ޿����� ���� �޿��� �޴� ������ ���� ��ȸ�ϼ���
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
           
--sub2
--��ձ޿����� ���� �޿��� �޴� ������ ������ ��ȸ�ϼ���
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
--sub3
--SMITH�� WARD����� ���� �μ��� ��� ��� ������ ��ȸ�ϴ� ������ ������ ���� �ۼ��ϼ���.
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
            FROM emp
            WHERE ename = 'SMITH')
OR deptno = (SELECT deptno
            FROM emp
            WHERE ename = 'WARD');
