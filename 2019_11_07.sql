--emp���̺��� �μ���ȣ(deptno)�� ����
--emp���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
--dept ���̺�� ������ ���� �μ��� ��ȸ

--���� ����
--ANSI : ���̺� JOIN ���̺�2 ON (���̺�.COL = ���̺�2.COL)
--       emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.COL = ���̺�2.COL
--         FROM emp, dept WHERE emp.deptno = dept.deptno

--�����ȣ, �����, �μ���ȣ, �μ���
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

--join0_2
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
ORDER BY sal DESC;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
ORDER BY sal DESC;

--join0_3
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
AND empno > 7600
ORDER BY sal DESC;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
AND empno > 7600
ORDER BY sal DESC;

--join0_4
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
AND emp.empno > 7600
AND dept.dname = 'RESEARCH';

SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
AND emp.empno > 7600
AND dept.dname = 'RESEARCH'
ORDER BY emp.empno DESC;

--join1
SELECT lprod.lprod_id, lprod.LPROD_NM, prod.prod_id, prod.prod_name
FROM lprod JOIN prod ON (lprod.lprod_gu = prod.prod_lgu);

SELECT lprod.lprod_id, lprod.LPROD_NM, prod.prod_id, prod.prod_name
FROM lprod, prod 
WHERE lprod.lprod_gu = prod.prod_lgu;

--join2
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer JOIN prod ON (prod.prod_buyer = buyer.buyer_id);

SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM buyer, prod 
WHERE prod.prod_buyer = buyer.buyer_id;

--join3
SELECT e.mem_id, e.mem_name, p.prod_id, p.prod_name, e.CART_QTY
FROM (SELECT *
        FROM member m JOIN cart c ON (m.mem_id = c.cart_member)) e JOIN prod p ON (e.cart_prod = p.prod_id);

SELECT e.mem_id, e.mem_name, p.prod_id, p.prod_name, e.CART_QTY
FROM (SELECT *
        FROM member m, cart c 
        WHERE m.mem_id = c.cart_member) e, prod p 
WHERE e.cart_prod = p.prod_id;

--join4
SELECT *
FROM customer ct JOIN cycle c ON (ct.cid = c.cid)
WHERE cnm in ('brown', 'sally');

--join5
SELECT ct.cid, ct.cnm, p.pid, p.pnm, c.day, c.cnt
FROM customer ct JOIN cycle c ON (ct.cid = c.cid)
    JOIN product p ON (c.pid = p.pid)
WHERE cnm in ('brown', 'sally');

--join6
WITH cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid)
SELECT customer.cid, cnm, product.pid, pnm, cnt
FROM cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
AND cycle_groupby.pid = product.pid;

SELECT customer.cid, cnm, cycle.pid, pnm, SUM(cnt) cmt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm;



--join7
SELECT p.pid, p.pnm, sum(c.cnt) cnt
FROM product p JOIN cycle c ON (c.pid = p.pid)
GROUP BY p.pid, p.pnm;

--join8
