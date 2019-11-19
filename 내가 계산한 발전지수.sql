SELECT *
FROM fastfood
WHERE GB = '����ŷ'
AND ADDR LIKE '%����%';

SELECT *
FROM fastfood
WHERE GB = '�Ƶ�����'
AND ADDR LIKE '%����%';

SELECT *
FROM fastfood
WHERE GB = 'KFC'
AND ADDR LIKE '%����%';

SELECT *
FROM fastfood
WHERE GB = '�Ե�����'
AND ADDR LIKE '%����%';


SELECT *
FROM fastfood
WHERE GB 



SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB IN ('����ŷ')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB IN ('�Ƶ�����')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB NOT IN ('�����̽�')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

SELECT sido, SIGUNGU, GB, COUNT(*) cnt
FROM fastfood
WHERE GB IN ('�Ե�����')
GROUP BY sido, SIGUNGU, GB
ORDER BY sido, sigungu;

--�������� ����
--����ŷ, �Ƶ�����, kfc ����
SELECT sido, sigungu, gb
FROM fastfood
WHERE sido = '����������'
AND gb IN ('����ŷ', '�Ƶ�����', 'kfc')
ORDER BY sigungu, gb;

SELECT sido, sigungu, gb
FROM fastfood
WHERE sido = '����������'
AND gb IN ('�Ե�����')
ORDER BY sigungu, gb;


SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('�Ե�����')
GROUP BY sido, sigungu;

SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ', '�Ƶ�����', 'kfc')
GROUP BY sido, sigungu;

(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('�Ե�����')
GROUP BY sido, sigungu);

(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ', '�Ƶ�����', 'kfc')
GROUP BY sido, sigungu);

SELECT a.sido, a.sigungu, ROUND((b.cnt/a.cnt), 2) point
FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('�Ե�����') GROUP BY sido, sigungu) a,
     (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('����ŷ', '�Ƶ�����', 'kfc') GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY point DESC;

SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal DESC;

SELECT sido, sigungu, sal
FROM tax
ORDER BY sal DESC;

--�õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
SELECT  s.sido, s.sigungu, s.point, s.part1 rank, f.sido, f.sigungu, f.sal
FROM (SELECT ROWNUM part1, z.*
        FROM (SELECT a.sido, a.sigungu, ROUND((b.cnt/a.cnt), 2) point
            FROM (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('�Ե�����') GROUP BY sido, sigungu) a,
                 (SELECT sido, sigungu, COUNT(*) cnt FROM fastfood WHERE gb IN ('����ŷ', '�Ƶ�����', 'kfc') GROUP BY sido, sigungu) b
            WHERE a.sido = b.sido
            AND a.sigungu = b.sigungu
            ORDER BY point DESC) z) s, 
    (SELECT ROWNUM part2, y.*
            FROM(SELECT sido, sigungu, sal
                FROM tax
                ORDER BY sal DESC) y) f
WHERE s.part1 = f.part2;