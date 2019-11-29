CREATE OR REPLACE  PROCEDURE create_daily_sales(p_yyyymm VARCHAR)
IS
        -- �޷��� �� ������ ������ RECORD TYPE
        TYPE cal_row IS RECORD(
                dt VARCHAR2(8),
                d  VARCHAR2(1));
                
        -- �޷� ������ ������ table type
        -- cal_row�� ������ ������ �� �ִ� Ÿ���̴�.
        TYPE calendar IS TABLE OF cal_row;
        cal calendar;
        
        -- �����ֱ� cursor
        CURSOR cycle_cursor IS
                SELECT *
                FROM cycle;
        
BEGIN        
        
        SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'YYYYMMDD') dt,
                      TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM') + ( LEVEL - 1 ), 'd') d
                      BULK COLLECT INTO cal
        FROM dual
        CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD'));
        
        -- �����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
        DELETE daily
        WHERE dt LIKE p_yyyymm || '%';
        
        -- �����ֱ� loop
        FOR rec IN cycle_cursor LOOP
                FOR i IN 1..cal.COUNT LOOP
                        -- �����ֱ��� �����̶� ������ �����̶� ���� ��
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