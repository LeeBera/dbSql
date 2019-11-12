SELECT *
FROM dept;

SELECT *
FROM customer;

DELETE dept WHERE deptno=99;
COMMIT;

INSERT INTO dept --해당 테이블의 모든 컬럼을 수정할 경우 생략가능 다만 컬럼의 순서를 잘 지켜서 값을 삽입
VALUES (99, 'DDIT', 'DAEJEON');

INSERT INTO dept (deptno, dname, loc)
VALUES (99, 'DDIT', 'DAEJEON');
COMMIT;

INSERT INTO customer
VALUES (99, 'DDIT');

DESC emp;

INSERT INTO emp (empno, ename, job)
VALUES (9999, 'brown', null);

--변경사항을 꼭 적용하고 싶다면 커밋 잊지말고 하기


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


--SELECT 결과(여러건)를 INSERT;
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;

--UPDATE
--UPDATE 테이블 SET 컬럼 = 값, 컬럼 = 값
--WHERE condition

UPDATE dept SET dname = '대덕IT', loc='ym'
WHERE deptno = 99;

ROLLBACK;

--고객관리-현금영수증 (야구르트여사님-13000, 운영팀, 일반직원, 영업점-650)
--주민번호 뒷자리
UPDATE 사용자테이블 SET 비밀번호 = 주민번호뒷자리
WHERE 사용자 구분이 = '여사님';

SELECT *
FROM emp;

--DELETE 테이블명
--WHERE condition
--사원번호가 9999인 직원을 emp테이블에서 삭제
DELETE emp
WHERE empno = 9999;

--부서테이블을 이용해서 emp 테이블에 입력한 5건(4건)의 데이터를 삭제
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

--DDL : AUTO COMMIT, ROLLBACK이 안 된다.
--CREATE
CREATE TABLE ranger_new (
    ranger_no NUMBER, --숫자 타입 
    ranger_name VARCHAR2(50), --문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);

DESC ranger_new;

--ddl은 rollback이 적용되지 않는다.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

SELECT *
FROM ranger_new;

--날짜타입에서 특정 필드가져오기
--ex) sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM') year1,
       EXTRACT(day FROM reg_dt) day,
       EXTRACT(year FROM reg_dt) year2,
       EXTRACT(MONTH FROM reg_dt) month
FROM ranger_new;

--제약조건
--DEPT 모방해서 DEPT_TEST 생성
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,--deptno 컬럼을 식별자로 지정
    dname varchar2(14),          --식별자로 지정이 되면 값이 중복이 될 수 없으며, null일 수도 없다.
    loc varchar2(13)
);
DESC dept_test;

--primary key제약 조건 확인
--1.deptno컬럼에 null이 들어갈 수 없다.
--2.deptno컬럼에 중복된 값이 들어갈 수 없다.

INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');

ROLLBACK;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
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
    --지금은 아까와 달리 어떤 컬럼에 적용해야 하는지 모른다. 그래서 따로 정해줘야 한다.
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
