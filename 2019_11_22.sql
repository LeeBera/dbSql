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

--(실습 h_4)
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
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT *
FROM no_emp;

SELECT LPAD(' ', (LEVEL-1)*4, ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--pruning branch (가지치기)
--계층쿼리에서 WHERE절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

--dept_h테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, LPAD(' ', 4*(LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리가 완성된 이후 WHERE절이 적용된다
SELECT deptcd, LPAD(' ', 4*(LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--
SELECT deptcd, LPAD(' ', 4*(LEVEL - 1), ' ') || deptnm deptnm
FROM dept_h

START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
           AND deptnm != '정보기획부';

--CONNECT_BY_ROOT(col) : col의 최상위 노드 컬럼 값
--SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--      . LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애 주는 형태가 일반적
--CONNECT_BY_ISLEFA : 해당 row가 leaf node인지 판별(1 : 0, 0 : X)
SELECT LPAD(' ', 4*(level - 1), ' ') || org_cd org_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
       CONNECT_BY_ISLEAF--그 계층 끝에 다 다르면 1, 아직 조회할 계층이 더 있으면 0
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test;

--계층쿼리를 짜라
SELECT seq, LPAD(' ', (LEVEL -1) * 5, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq;

--가장 최신글이 위에 오도록 하라
SELECT seq, LPAD(' ', (LEVEL -1) * 5, ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--가장 최신글이 위에 오지만 답글도 그렇게 정렬되게 해보라
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

--이슬언니 버전
SELECT seq, LPAD(' ', (LEVEL -1) * 5, ' ') || title title, 
       CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
       CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY prior seq = parent_seq
ORDER SIBLINGS BY o1 DESC;

--쌤버전
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
--글 그룹번호 컬럼 추가
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