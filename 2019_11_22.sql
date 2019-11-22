create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;
commit;

SELECT *
FROM h_sum;

--(�ǽ� h_4)
SELECT LPAD(' ', 4*(LEVEL-1), ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

SELECT *
FROM dept_h h 
START WITH deptcd = 'dept0_00 _0'
CONNECT BY p_deptcd = PRIOR deptcd;


create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--pruning branch (����ġ��)
--������������ WHERE���� START WITH, CONNECT BY ���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h���̺��� �ֻ��� ������ ��������� ��ȸ
SELECT deptcd, LPAD(' ', 4*(LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--���������� �ϼ��� ���� WHERE���� ����ȴ�
SELECT deptcd, LPAD(' ', 4*(LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--
SELECT deptcd, LPAD(' ', 4*(LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h

START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
           AND deptnm != '������ȹ��';

--CONNECT_BY_ROOT(col) : col�� �ֻ��� ��� �÷� ��
--SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--      . LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� ���� �ִ� ���°� �Ϲ���
--CONNECT_BY_ISLEFA : �ش� row�� leaf node���� �Ǻ�(1 : 0, 0 : X)
SELECT LPAD(' ', 4*(level - 1), ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
       CONNECT_BY_ISLEAF--�� ���� ���� �� �ٸ��� 1, ���� ��ȸ�� ������ �� ������ 0
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

SELECT *
FROM board_test;

--���������� ¥��
SELECT seq, LPAD(' ', (LEVEL -1) * 5, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq;

--���� �ֽű��� ���� ������ �϶�
SELECT seq, LPAD(' ', (LEVEL -1) * 5, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--���� �ֽű��� ���� ������ ��۵� �׷��� ���ĵǰ� �غ���
SELECT SEQ, parent_seq, LPAD(' ', (LEVEL-1) * 4, ' ')|| title title,
       CONNECT_BY_ISLEAF
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq;


(SELECT SEQ, parent_seq, LPAD(' ', (LEVEL-1) * 4, ' ')|| title title,
       SEQ || '_' || PARENT_SEQ
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq);

SELECT e.seq, e.title
FROM
(SELECT CASE
        WHEN SEQ || '_' || PARENT_SEQ 
        
        END line1, seq, parent_seq, title 
FROM board_test) e
START WITH e.line1 = '1'
CONNECT BY prior e.seq = e.parent_seq;

--�̽���� ����
SELECT seq, LPAD(' ', (LEVEL -1) * 5, ' ') || title title, 
       CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
       CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq
ORDER SIBLINGS BY o1 DESC;

--�ܹ���
SELECT *
FROM
    (SELECT SEQ, parent_seq, LPAD(' ', (LEVEL-1) * 4, ' ')|| title title,
           CONNECT_BY_ROOT(seq) r_seq
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY prior seq = parent_seq)
ORDER BY r_seq DESC, seq;


SELECT *
FROM board_test;
--�� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (qn NUMBER);

SELECT seq, LPAD(' ', 4*(LEVEL - 1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY qn DESC, seq;

--
SELECT b.ename, b.sal, a.sal
FROM (SELECT ROWNUM rn1, sal, ename
      FROM 
          (SELECT ename, sal
          FROM emp
          ORDER BY sal DESC)) a RIGHT OUTER JOIN
    (SELECT ROWNUM rn2, sal, ename
    FROM 
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC)) b ON (a.rn1 = b.rn2 + 1);