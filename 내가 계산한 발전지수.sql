SELECT *
FROM fastfood
WHERE GB = '버거킹'
AND ADDR LIKE '%대전%';

SELECT *
FROM fastfood
WHERE GB = '맥도날드'
AND ADDR LIKE '%대전%';

SELECT *
FROM fastfood
WHERE GB = 'KFC'
AND ADDR LIKE '%대전%';

SELECT *
FROM fastfood
WHERE GB = '롯데리아'
AND ADDR LIKE '%대전%';


SELECT *
FROM fastfood
WHERE GB 



SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB IN ('버거킹')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB IN ('맥도날드')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB NOT IN ('파파이스')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB IN ('롯데리아')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

--대전지역 한정
--버거킹, 맥도날드, kfc 개수
SELECT sido, sigungu, gb
FROM fastfood
WHERE sido = '대전광역시'
AND gb IN ('버거킹', '맥도날드', 'kfc')
ORDER BY sigungu, gb;

SELECT sido, sigungu, gb
FROM fastfood
WHERE sido = '대전광역시'
AND gb IN ('롯데리아')
ORDER BY sigungu, gb;


SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('롯데리아')
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('버거킹', '맥도날드', 'kfc')
GROUP BY sido, sigungu;

(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('롯데리아')
GROUP BY sido, sigungu);

(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('버거킹', '맥도날드', 'kfc')
GROUP BY sido, sigungu);

SELECT a.sido, a.sigungu, ROUND((b.cnt/a.cnt), 2) point
FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('롯데리아') GROUP BY sido, sigungu) a,
     (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('버거킹', '맥도날드', 'kfc') GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY point DESC;

SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal DESC;

SELECT sido, sigungu, sal
FROM tax
ORDER BY sal DESC;

--시도, 시군구, 버거지수, 시도, 시군구, 연말정산 납입액
SELECT  s.sido, s.sigungu, s.point, s.part1 rank, f.sido, f.sigungu, f.sal
FROM (SELECT ROWNUM part1, z.*
        FROM (SELECT a.sido, a.sigungu, ROUND((b.cnt/a.cnt), 2) point
            FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('롯데리아') GROUP BY sido, sigungu) a,
                 (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('버거킹', '맥도날드', 'kfc') GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
            ORDER BY point DESC) z) s, 
    (SELECT ROWNUM part2, y.*
            FROM(SELECT sido, sigungu, sal
                FROM tax
                ORDER BY sal DESC) y) f
WHERE s.part1 = f.part2;