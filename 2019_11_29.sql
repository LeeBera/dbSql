CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        -- 달력의 행 정보를 저장할 RECORD TYPE
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
                
        -- 달력 정보를 저장할 table type
        -- cal_row를 여러건 저장할 수 있는 타입이다.
        TYPE calendar IS TABLE OF cal_row;
        cal calendar;
        
        -- 애음주기 cursor
        CURSOR cycle_cursor IS
                SELECT *
                FROM cycle;
        
BEGIN        
        
        SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                      TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                      BULK COLLECT INTO cal
        FROM dual
        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));
        
        -- 생성하려고 하는 년월의 실적 데이터를 삭제한다.
        DELETE daily
        WHERE dt LIKE p_yyyymm || '%';
        
        -- 애음주기 loop
        FOR rec IN cycle_cursor LOOP
                FOR i IN 1..cal.COUNT LOOP
                        -- 애음주기의 요일이랑 일자의 요일이랑 같은 비교
                        IF rec.day = cal(i).d THEN
                                INSERT INTO daily VALUES (rec.cid, rec.pid, cal(i).dt, rec.cnt);
                        END IF;
                END LOOP;
                COMMIT;
        END LOOP;
        
END;
/
EXEC create_daily_sales('201911');

SELECT *
FROM daily;

DECLARE
    deptno NUMBER(2);