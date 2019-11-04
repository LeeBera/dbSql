--���� where11
--job�� SALESMAN�̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������ �������� ��ȸ

SELECT *
FROM emp
WHERE job IN ('SALESMAN')
OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');
--OR hiredate >= TO_DATE('1981-06-01', 'YYYY-MM-DD');
--OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--ROWNUM
SELECT ROWNUM, emp.*
FROM emp;

--ROWNUM�� ���� ����
--ORDER BY���� SELECT �� ���Ŀ� ����
--ROWNUM �����÷��� ����ǰ��� ���ĵǱ� ������
--�츮�� ���ϴ´�� ù��° �����ͺ��� �������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM 
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1������ �о�� �ȴ�.
--WHERE���� ROWNUM���� �߰��� �д� �� �Ұ���
--�ȵǴ� ���̽�
--WHERE ROWNUM = 2;
--WEHRE ROWNUM > 3;

--�Ǵ� ���̽�
--WHERE ROWNUM = 1;
--WEHRE ROWNUM <= 3;

--����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW�� ���ΰ� ��Ī�� ���� ����¡ ó��
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;

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
       LPAD('HELLO, WORLD', 15) lapd,
       LPAD('HELLO, WORLD', 15, ' ') lapd,
       RPAD('HELLO, WORLD', 15, '*') rpad,
       --REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
       REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
       TRIM('  HELLO, WORLD  ') trim,
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

--ROUND(������, ���� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1, --�Ҽ��� ��° �ڸ����� ����
       ROUND(105.55, 1) r2, --�Ҽ��� ��° �ڸ����� ����
       ROUND(105.55, 0) r3, --�Ҽ��� ù° �ڸ����� ����
       ROUND(105.55, -1) r4 --���� ù° �ڸ����� ����
FROM dual;

DESC emp;

SELECT empno, ename, 
       sal, sal/1000, /*ROUND(sal/1000) qutient,*/ MOD(sal, 1000) reminder
FROM emp;
--ROUND(sal/1000)�� ROUND(sal/1000, 0)�� ����.

SELECT 
TRUNC(105.54, 1) t1, --�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 1) t2, --�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 0) t3, --�Ҽ��� ù° �ڸ����� ����
TRUNC(105.55, -1) t4 --���� ù° �ڸ����� ����
FROM dual;

--SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
--������ ���ڰ� ���� �Լ�

--TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
--��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR (SYSDATE + 5, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;
SELECT TO_CHAR (SYSDATE + (1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

--FUNCTION(date �ǽ� fn1)
SELECT TO_CHAR(TO_DATE('191231', 'YY/MM/DD'), 'YY/MM/DD') LASTDAY, 
       TO_CHAR(TO_DATE('191231' - 5, 'YY/MM/DD'), 'YY/MM/DD') LASTDAY_BEFOER5,
       TO_CHAR (SYSDATE, 'YY/MM/DD') NOW, 
       TO_CHAR (SYSDATE - 3, 'YY/MM/DD') NOW_BEFORE3
FROM dual;

SELECT LASTDAY, LASTDAY-5 AS LASTDAY_BEFORE5,
        NOW, NOW-3 NOW_BEFORE3
FROM
    (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
    SYSDATE NOW
    FROM dual);
    
--date format
--�⵵ : YYYY, YY, RR : ���ڸ��� ���� ���ڸ��϶��� �ٸ�
-- RR : 50���� Ŭ ��� ���ڸ��� 19, 50���� ������� ���ڸ��� 20
--YYYY, RRRR�� ���� �������̸� ��������� ǥ�� �� ��
-- D : ������ ���ڷ� ǥ�� (�Ͽ��� - 1, ������ - 2, ȭ���� - 3, ������ - 4, ����� - 5, �ݿ��� - 6, ����� -7)
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('49/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,--50�̻��� ��� 1900�⵵�� ����ϰ� 50���� ������ 2000������ ����Ѵ�.
       TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,  
       TO_CHAR(SYSDATE, 'D') d, -- ������ ������ -2
       TO_CHAR(SYSDATE, 'IW') iw -- ���� ǥ��
FROM dual;

--FUNCTION(date �ǽ� fn2)
--���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

--��¥�� �ݿø�(ROUND), ����(TRUNC)
--ROUND(DATE, '����') YYYY, MM, DD
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate,
       TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') AS round_YYYY,
       TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') AS round_DD,
       TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS round_MM,
       TO_CHAR(ROUND(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS round_MM1
FROM emp
WHERE ename = 'SMITH';

SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate,
       TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_YYYY,
       TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_DD,
       TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_MM
FROM emp
WHERE ename = 'SMITH';

SELECT SYSDATE + 30 --28, 29, 31
FROM dual;

--��¥ ���� �Լ�
--MONTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
--198012~201910
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between2
FROM emp
WHERE ename='SMITH';

--ADD_MONTHS(DATE, ������) : DATE�� �������� ���� ��¥
--�������� ����� ��� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months1
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, --���� ��¥ ���� ù ����� ����
       NEXT_DAY(SYSDATE, '�����') first_sat1
FROM dual;

--LAST_DAY(DATE)�ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
       LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LAST_DAY_12,
       TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 1)), 'DD') DCNT
FROM dual;

--DATE + ���� = DATE (DATE���� ������ŭ ������ DATE)
--D1 + ���� =D2
--�纯���� D2 ����
--D1 + ���� - D2 = D2 - D2
--D1 + ���� - D2 = 0
--D1 + ���� = D2
--�纯�� D1 ����
--D1 + ���� - D1 = D2 -D1
--���� = D2 - D1
--��¥���� ��¥�� ���� ���ڰ� ���´�
SELECT TO_DATE('20191104', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD'),
       TO_DATE('20191201', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD'),
       --201908 : 2019�� 8���� �ϼ� : 31
       ADD_MONTHS(TO_DATE('201908', 'YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM') d31
FROM dual;