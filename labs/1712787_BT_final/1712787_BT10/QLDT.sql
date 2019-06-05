USE QLDT
GO
--Q58. Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề. 
----EXCEPT - phép trừ
SELECT DISTINCT GV1.*
FROM GIAOVIEN GV1
WHERE NOT EXISTS
(
	(SELECT MaCD FROM CHUDE)
	EXCEPT
	(SELECT CD2.MACD FROM THAMGIADT TG2, DETAI DT2, CHUDE CD2
	WHERE TG2.MaDT = DT2.MaDT AND DT2.MaCD = CD2.MaCD AND TG2.MaGV = GV1.MaGV)
)
----NOT EXISTS - phép chia
SELECT DISTINCT GV1.*
FROM GIAOVIEN GV1, THAMGIADT TG1, DETAI DT1, CHUDE CD1
WHERE GV1.MaGV = TG1.MaGV AND TG1.MaDT = DT1.MaDT AND DT1.MaCD = CD1.MaCD AND NOT EXISTS
(
	SELECT * FROM CHUDE CD1 WHERE NOT EXISTS (SELECT *FROM THAMGIADT TG2, DETAI DT2
	WHERE TG2.MaDT = DT2.MaDT AND DT2.MaCD = CD1.MaCD AND TG2.MaGV = GV1.MaGV)
)
----NOT IN 
SELECT DISTINCT GV1.*
FROM GIAOVIEN GV1
WHERE NOT EXISTS
(
	SELECT MaCD FROM CHUDE WHERE MaCD 
	NOT IN (SELECT CD2.MACD FROM THAMGIADT TG2, DETAI DT2, CHUDE CD2
	WHERE TG2.MaDT = DT2.MaDT AND DT2.MaCD = CD2.MaCD AND TG2.MaGV = GV1.MaGV)
)
----COUNT - gom nhóm	
SELECT GV1.HoTen
FROM GIAOVIEN GV1, THAMGIADT TG1, DETAI DT1, CHUDE CD1
WHERE GV1.MaGV = TG1.MaGV AND TG1.MaDT = DT1.MaDT AND DT1.MaCD = CD1.MaCD
GROUP BY GV1.MaGV, GV1.HoTen
HAVING COUNT(DISTINCT CD1.MaCD) = (SELECT COUNT(*) FROM CHUDE)

--Q59. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia. 
----EXCEPT - phép trừ
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
                (SELECT gv.MAGV FROM GIAOVIEN gv --Tất cả các giáo viên HTTT
				 WHERE gv.MABM = 'HTTT')   
                EXCEPT 
				(SELECT tg2.MAGV FROM THAMGIADT tg2 --những GV mà tg1.MADT đã được tham gia
				 WHERE tg1.MADT = tg2.MADT))
----NOT EXISTS - phép chia
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
               SELECT * FROM GIAOVIEN gv
			   WHERE gv.MABM = 'HTTT'
			   AND NOT EXISTS (SELECT *
			                     FROM THAMGIADT tg2
								 WHERE tg2.MADT = tg1.MADT
								 AND gv.MAGV = tg2.MAGV)) 
---- NOT IN
SELECT DT.TENDT 
FROM DETAI DT
WHERE NOT EXISTS (SELECT * FROM GIAOVIEN GV
		          WHERE GV.MABM = 'HTTT' AND GV.MAGV 
				  NOT IN 
				  (SELECT TG.MAGV FROM THAMGIADT TG
				   WHERE TG.MADT = DT.MADT))
----COUNT - gom nhóm					
SELECT DISTINCT tg1.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT AND tg1.MAGV IN (SELECT MAGV FROM GIAOVIEN
                                          WHERE MABM = 'HTTT')
										  GROUP BY tg1.MADT, dt.TENDT
										  HAVING COUNT(DISTINCT tg1.MAGV) = 
										  (SELECT COUNT(MAGV) FROM GIAOVIEN
										  WHERE MABM = 'HTTT')
 
--Q60. Cho biết tên đề tài có tất cả giảng viên bộ môn “Hệ thống thông tin” tham gia 
----EXCEPT - phép trừ
SELECT DISTINCT dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
                (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm --Tất cả các giáo viên HTTT
				 WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Hệ thống thông tin')   
                EXCEPT 
				(SELECT tg2.MAGV FROM THAMGIADT tg2 --những GV mà tg1.MADT đã được tham gia
				 WHERE tg1.MADT = tg2.MADT))
----NOT EXCEPT - phép chia
SELECT DISTINCT dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
               SELECT * FROM GIAOVIEN gv, BOMON bm
			   WHERE gv.MABM = bm.MABM AND BM.TENBM = N'Hệ thống thông tin'
			   AND NOT EXISTS (SELECT *
			                   FROM THAMGIADT tg2
							   WHERE tg2.MADT = tg1.MADT AND gv.MAGV = tg2.MAGV)) 
---- NOT IN
SELECT DT.TENDT 
FROM DETAI DT
WHERE NOT EXISTS (SELECT * FROM GIAOVIEN GV, BOMON BM
				  WHERE GV.MABM = BM.MABM AND BM.TENBM = N'Hệ thống thông tin'
				  AND GV.MAGV NOT IN (SELECT TG.MAGV FROM THAMGIADT TG
									  WHERE TG.MADT = DT.MADT))
----COUNT - gom nhóm
SELECT DISTINCT dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT AND tg1.MAGV IN (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm
                                          WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Hệ thống thông tin')
										  GROUP BY tg1.MADT, dt.TENDT
										  HAVING COUNT(DISTINCT tg1.MAGV) = 
										  (SELECT COUNT(gv1.MAGV) FROM GIAOVIEN gv1, BOMON bm1
										  WHERE gv1.MABM = bm1.MABM AND bm1.TENBM = N'Hệ thống thông tin')

--Q61. Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD. 
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT MADT FROM DETAI WHERE MACD = 'QLGD')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV)) 
----NOT EXCEPT - phép chia
-- tìm các giáo viên 
-- mà không có đề tài của chủ để QLGD 
-- mà đề tài QLGD đó không có gv trên tham gia
-- Nghĩ là: tìm các giáo viên mà không có đề tài nào là không tham gia
SELECT tg1.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT * FROM DETAI dt 
                 WHERE MACD = 'QLGD' 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = dt.MADT AND tg2.MAGV=tg1.MAGV))
---- NOT IN
SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS((SELECT * FROM DETAI DT
				  WHERE DT.MACD = 'QLGD' AND DT.MADT 
				  NOT IN (SELECT TG.MADT FROM THAMGIADT TG
					      WHERE TG.MAGV = GV.MAGV)))
----COUNT - gom nhóm
SELECT tg1.MAGV , gv.HOTEN 
FROM THAMGIADT tg1 , GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT MADT FROM DETAI 
                                          WHERE MACD='QLGD') 
										  GROUP BY tg1.MAGV , gv.HOTEN 
										  HAVING COUNT(DISTINCT tg1.MADT) = 
										  (SELECT COUNT(MADT) FROM DETAI 
										  WHERE MACD = 'QLGD')

--Q62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia. 
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT dt.MADT FROM DETAI dt, THAMGIADT tg, GIAOVIEN gv
                WHERE dt.MADT = tg.MADT AND tg.MAGV = gv.MAGV AND gv.HOTEN = N'Trần Trà Hương')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV))
----NOT EXCEPT - phép chia
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT dt.* FROM DETAI dt, THAMGIADT tg, GIAOVIEN gv
                WHERE dt.MADT = tg.MADT AND tg.MAGV = gv.MAGV AND gv.HOTEN = N'Trần Trà Hương' 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = dt.MADT AND tg2.MAGV=tg1.MAGV))
---- NOT IN
SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT * FROM THAMGIADT TG, GIAOVIEN GV1
				  WHERE TG.MAGV = GV1.MAGV AND GV1.HOTEN = N'Trần Trà Hương'
				  AND TG.MADT 
				  NOT IN( SELECT TG1.MADT FROM THAMGIADT TG1
				  WHERE TG1.MAGV = GV.MAGV  AND GV.HOTEN <>N'Trần Trà Hương'))
----COUNT - gom nhóm
SELECT tg1.MAGV, gv.HOTEN 
FROM THAMGIADT tg1 , GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT dt.MADT FROM DETAI dt, THAMGIADT tg, GIAOVIEN gv
                                          WHERE dt.MADT = tg.MADT AND tg.MAGV = gv.MAGV 
										  AND gv.HOTEN = N'Trần Trà Hương') 
										  GROUP BY tg1.MAGV , gv.HOTEN 
										  HAVING COUNT(DISTINCT tg1.MADT) = 
										  (SELECT COUNT(dt.MADT) FROM DETAI dt, THAMGIADT tg, GIAOVIEN gv
                                          WHERE dt.MADT = tg.MADT AND tg.MAGV = gv.MAGV 
										  AND gv.HOTEN = N'Trần Trà Hương')

--Q63. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa Hữu Cơ tham gia.
----EXCEPT - phép trừ
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( 
                (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm
				 WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Hóa Hữu Cơ')   
                EXCEPT 
				(SELECT tg2.MAGV FROM THAMGIADT tg2 
				 WHERE tg1.MADT = tg2.MADT))
----NOT EXCEPT - phép chia
SELECT DISTINCT tg1.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( 
               SELECT * FROM GIAOVIEN gv, BOMON bm
			   WHERE gv.MABM = bm.MABM AND BM.TENBM = N'Hóa Hữu Cơ'
			   AND NOT EXISTS (SELECT *
			                     FROM THAMGIADT tg2
								 WHERE tg2.MADT = tg1.MADT
								 AND gv.MAGV = tg2.MAGV)) 
---- NOT IN
SELECT DT.TENDT 
FROM DETAI DT
WHERE NOT EXISTS ( SELECT * FROM GIAOVIEN GV, BOMON BM
				   WHERE GV.MABM = BM.MABM AND BM.TENBM = N'HOÁ HỮU CƠ'
				   AND GV.MAGV NOT IN (SELECT TG.MAGV FROM THAMGIADT TG
									   WHERE TG.MADT = DT.MADT))
--COUNT - gom nhóm
SELECT DISTINCT tg1.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT AND tg1.MAGV IN (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm
                                          WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Hóa Hữu Cơ')
										  GROUP BY tg1.MADT, dt.TENDT
										  HAVING COUNT(DISTINCT tg1.MAGV) = 
										  (SELECT COUNT(gv1.MAGV) FROM GIAOVIEN gv1, BOMON bm1
										  WHERE gv1.MABM = bm1.MABM AND bm1.TENBM = N'Hóa Hữu Cơ')

--Q64. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006. 
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT MADT FROM CONGVIEC 
                WHERE MADT = '006')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV)) 
----NOT EXCEPT - phép chia
SELECT DISTINCT tg1.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT cv.* FROM CONGVIEC cv 
                 WHERE cv.MADT = '006' 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = cv.MADT AND tg2.MAGV=tg1.MAGV))

---- NOT IN
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (
				  SELECT * FROM CONGVIEC CV
				  WHERE CV.MADT = '006' AND CV.SOTT NOT IN (SELECT TG.STT FROM THAMGIADT TG
															WHERE TG.MAGV = GV.MAGV AND TG.MADT = '006'))
----COUNT - gom nhóm
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV AND TG.MADT = '006'
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(TG.STT) = (SELECT COUNT(*)
						FROM CONGVIEC
						WHERE MADT = '006')

--Q65. Cho biết giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT dt.MADT FROM DETAI dt, CHUDE cd 
                WHERE dt.MACD = cd.MACD AND cd.TENCD = 'Ứng dụng công nghệ')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV)) 
----NOT EXCEPT - phép chia
SELECT DISTINCT tg1.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT * FROM DETAI dt, CHUDE cd 
                WHERE dt.MACD = cd.MACD AND cd.TENCD = 'Ứng dụng công nghệ' 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = dt.MADT AND tg2.MAGV=tg1.MAGV))

---- NOT IN
SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT * FROM DETAI DT, CHUDE CD
				  WHERE DT.MACD = CD.MACD AND CD.TENCD = N'Ứng dụng công nghệ' 
				  AND DT.MADT NOT IN (SELECT TG.MADT FROM THAMGIADT TG
									  WHERE TG.MAGV = GV.MAGV))
----COUNT - gom nhóm
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV AND TG.MADT IN (SELECT DT.MADT FROM DETAI DT, CHUDE CD
										WHERE DT.MACD = CD.MACD AND CD.TENCD = N'Ứng dụng công nghệ')
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) = (SELECT COUNT(*) FROM DETAI DT1, CHUDE CD1
								  WHERE DT1.MACD = CD1.MACD AND CD1.TENCD = N'Ứng dụng công nghệ')

--Q66. Cho biết tên giáo viên nào đã tham gia tất cả các đề tài của do Trần Trà Hương làm chủ nhiệm
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT dt.MADT FROM DETAI dt, GIAOVIEN gv
                WHERE dt.GVCNDT = gv.MAGV AND gv.HOTEN = N'Trần Trà Hương')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV))
----NOT EXCEPT - phép chia
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT dt.* FROM DETAI dt, GIAOVIEN gv
                 WHERE dt.GVCNDT = gv.MAGV AND gv.HOTEN = N'Trần Trà Hương' 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = dt.MADT AND tg2.MAGV=tg1.MAGV))

---- NOT IN
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (
				    SELECT * FROM DETAI DT, GIAOVIEN GV1
					WHERE DT.GVCNDT = GV1.MAGV AND GV1.HOTEN = N'Trần Trà Hương'
					AND DT.MADT NOT IN (SELECT TG.MADT FROM THAMGIADT TG
										WHERE TG.MAGV = GV.MAGV))
----COUNT - gom nhóm
SELECT tg1.MAGV, gv.HOTEN 
FROM THAMGIADT tg1 , GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT dt.MADT FROM DETAI dt, GIAOVIEN gv
                                          WHERE dt.GVCNDT = gv.MAGV AND gv.HOTEN = N'Trần Trà Hương')
										  GROUP BY tg1.MAGV , gv.HOTEN 
										  HAVING COUNT(DISTINCT tg1.MADT) = 
										  (SELECT COUNT(dt.MADT) FROM DETAI dt, GIAOVIEN gv
                                           WHERE dt.GVCNDT = gv.MAGV AND gv.HOTEN = N'Trần Trà Hương')

--Q67. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia.
----EXCEPT - phép trừ
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( 
                (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm
				 WHERE gv.MABM = bm.MABM AND bm.MAKHOA = 'CNTT')   
                EXCEPT 
				(SELECT tg2.MAGV FROM THAMGIADT tg2 
				 WHERE tg1.MADT = tg2.MADT))
----NOT EXCEPT - phép chia
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( 
               SELECT * FROM GIAOVIEN gv, BOMON bm
			   WHERE gv.MABM = bm.MABM AND bm.MAKHOA = 'CNTT'
			   AND NOT EXISTS (SELECT *
			                     FROM THAMGIADT tg2
								 WHERE tg2.MADT = tg1.MADT
								 AND gv.MAGV = tg2.MAGV)) 
---- NOT IN
SELECT DT.MADT, DT.TENDT
FROM DETAI DT
WHERE NOT EXISTS (
					SELECT * FROM GIAOVIEN GV, BOMON BM
					WHERE GV.MABM = BM.MABM AND BM.MAKHOA = 'CNTT'
							AND GV.MAGV NOT IN (SELECT TG.MAGV FROM THAMGIADT TG
												WHERE TG.MADT = DT.MADT))
----COUNT - gom nhóm
SELECT DISTINCT tg1.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT AND tg1.MAGV IN (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm
				                          WHERE gv.MABM = bm.MABM AND bm.MAKHOA = 'CNTT')
										  GROUP BY tg1.MADT, dt.TENDT
										  HAVING COUNT(DISTINCT tg1.MAGV) = 
										 (SELECT COUNT(gv.MAGV) FROM GIAOVIEN gv, BOMON bm
				                          WHERE gv.MABM = bm.MABM AND bm.MAKHOA = 'CNTT')

--Q68. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc.
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT cv.MADT FROM CONGVIEC cv, DETAI dt
                WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Nghiên cứu tế bào gốc')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2, CONGVIEC cv2 
			    WHERE tg2.MADT = cv2.MADT AND tg2.STT = cv2.SOTT AND tg2.MAGV = tg1.MAGV)) 
----NOT EXCEPT - phép chia
SELECT DISTINCT tg1.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT cv.* FROM CONGVIEC cv, DETAI dt
                 WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Nghiên cứu tế bào gốc'
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = cv.MADT AND tg2.MAGV=tg1.MAGV))
---- NOT IN
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT * FROM CONGVIEC CV, DETAI DT
				  WHERE CV.MADT = DT.MADT AND DT.TENDT = N'Nghiên cứu tế bào gốc'
				  AND CV.SOTT NOT IN (SELECT TG.STT FROM THAMGIADT TG
									  WHERE TG.MADT = CV.MADT AND TG.STT = CV.SOTT AND TG.MAGV = GV.MAGV))
----COUNT - gom nhóm
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV AND TG.MADT = (SELECT DT.MADT FROM DETAI DT
									   WHERE DT.TENDT = N'Nghiên cứu tế bào gốc')
GROUP BY GV.MAGV, GV.HOTEN, TG.MADT
HAVING COUNT(TG.STT) = (SELECT COUNT(*) FROM CONGVIEC CV, DETAI DT
						WHERE CV.MADT = DT.MADT AND DT.TENDT = N'Nghiên cứu tế bào gốc')

--Q69. Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu?
----TEST 100 ko ra ket qua nen em thu 300 
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT dt.MADT FROM DETAI dt
                WHERE dt.KINHPHI > 300)
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV))
----NOT EXCEPT - phép chia
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT dt.* FROM DETAI dt
                 WHERE dt.KINHPHI > 300 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = dt.MADT AND tg2.MAGV=tg1.MAGV))

---- NOT IN
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE NOT EXISTS (SELECT * FROM DETAI DT
	              WHERE DT.KINHPHI > 100 AND DT.MADT NOT IN (SELECT TG.MADT FROM THAMGIADT TG
															 WHERE TG.MAGV = GV.MAGV))
----COUNT - gom nhóm
SELECT DISTINCT gv.MAGV, gv.HOTEN 
FROM GIAOVIEN gv, THAMGIADT tg1
WHERE gv.MAGV = tg1.MAGV 
AND tg1.MADT IN(SELECT dt.MADT FROM DETAI dt WHERE dt.KINHPHI > 300)
                GROUP BY gv.MAGV, gv.HOTEN 
                HAVING COUNT(DISTINCT tg1.MADT) = 
			   (SELECT COUNT (dt.MADT) 
                FROM DETAI dt
                WHERE dt.KINHPHI > 300)

--Q70. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa Sinh Học tham gia. 
----EXCEPT - phép trừ
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( 
                (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm, KHOA k
				 WHERE gv.MABM = bm.MABM AND bm.MAKHOA = k.MAKHOA AND k.TENKHOA = N'Sinh học')   
                EXCEPT 
				(SELECT tg2.MAGV FROM THAMGIADT tg2 
				 WHERE tg1.MADT = tg2.MADT))
----NOT EXCEPT - phép chia
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( 
               SELECT * FROM GIAOVIEN gv, BOMON bm, KHOA k
			   WHERE gv.MABM = bm.MABM AND bm.MAKHOA = k.MAKHOA AND k.TENKHOA = N'Sinh học'
			   AND NOT EXISTS (SELECT *
			                     FROM THAMGIADT tg2
								 WHERE tg2.MADT = tg1.MADT
								 AND gv.MAGV = tg2.MAGV)) 
---- NOT IN

----COUNT - gom nhóm
SELECT DISTINCT tg1.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT AND tg1.MAGV IN (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm, KHOA k
				                          WHERE gv.MABM = bm.MABM AND bm.MAKHOA = k.MAKHOA 
										  AND k.TENKHOA = N'Sinh học')
										  GROUP BY tg1.MADT, dt.TENDT
										  HAVING COUNT(DISTINCT tg1.MAGV) = 
										 (SELECT COUNT(gv.MAGV) FROM GIAOVIEN gv, BOMON bm, KHOA k
				                          WHERE gv.MABM = bm.MABM AND bm.MAKHOA = k.MAKHOA
										  AND k.TENKHOA = N'Sinh học')
--Q71. Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài “Ứng dụng hóa học xanh”. 
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN, gv.NGSINH
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV
AND NOT EXISTS((SELECT cv.MADT FROM CONGVIEC cv, DETAI dt
                WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Ứng dụng hóa học xanh')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2, CONGVIEC cv2 
			    WHERE tg2.MADT = cv2.MADT AND tg2.STT = cv2.SOTT AND tg2.MAGV = tg1.MAGV)) 
----NOT EXCEPT - phép chia
SELECT DISTINCT tg1.MAGV, gv.HOTEN, gv.NGSINH
FROM THAMGIADT tg1, GIAOVIEN gv 
WHERE tg1.MAGV = gv.MAGV 
AND NOT EXISTS ( SELECT cv.* FROM CONGVIEC cv, DETAI dt
                 WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Ứng dụng hóa học xanh'
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = cv.MADT AND tg2.MAGV=tg1.MAGV))
---- NOT IN

----COUNT - gom nhóm
SELECT GV.MAGV, GV.HOTEN, GV.NGSINH
FROM GIAOVIEN GV, THAMGIADT TG, DETAI DT
WHERE GV.MAGV = TG.MAGV AND TG.MADT = DT.MADT AND DT.TENDT = N'Ứng dụng hóa học xanh'
GROUP BY GV.MAGV, GV.HOTEN, GV.NGSINH
HAVING COUNT(DISTINCT TG.STT) = (SELECT COUNT(*) FROM CONGVIEC CV, DETAI DT1
						WHERE CV.MADT = DT1.MADT AND DT1.TENDT = N'Ứng dụng hóa học xanh')

--Q72. Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên tham gia tất cả các đề tài thuộc chủ đề “Nghiên cứu phát triển”.
----EXCEPT - phép trừ
SELECT DISTINCT gv.MAGV, gv.HOTEN, bm.TENBM, (SELECT gv1.HOTEN 
                                              FROM GIAOVIEN gv1 
											  WHERE gv.GVQLCM = gv1.MAGV) AS CHUNHIEM_CM  
FROM THAMGIADT tg1, GIAOVIEN gv, BOMON bm
WHERE tg1.MAGV = gv.MAGV AND bm.MABM = gv.MABM
AND NOT EXISTS((SELECT dt.MADT FROM DETAI dt, CHUDE cd 
                WHERE dt.MACD = cd.MACD AND cd.TENCD = 'Nghiên cứu phát triển')
                EXCEPT
			   (SELECT tg2.MADT FROM THAMGIADT tg2 
			    WHERE tg2.MAGV = tg1.MAGV)) 
----NOT EXCEPT - phép chia
SELECT DISTINCT gv.MAGV, gv.HOTEN, bm.TENBM, (SELECT gv1.HOTEN 
                                              FROM GIAOVIEN gv1 
											  WHERE gv.GVQLCM = gv1.MAGV) AS CHUNHIEM_CM 
FROM THAMGIADT tg1, GIAOVIEN gv, BOMON bm
WHERE tg1.MAGV = gv.MAGV AND bm.MABM = gv.MABM 
AND NOT EXISTS ( SELECT * FROM DETAI dt, CHUDE cd 
                 WHERE dt.MACD = cd.MACD AND cd.TENCD = 'Nghiên cứu phát triển' 
				 AND NOT EXISTS (SELECT * FROM THAMGIADT tg2
				                 WHERE tg2.MADT = dt.MADT AND tg2.MAGV=tg1.MAGV))
---- NOT IN

----COUNT - gom nhóm
SELECT DISTINCT GV1.MAGV,GV1.HOTEN,GV1.NGSINH 
FROM GIAOVIEN GV,GIAOVIEN GV1,CHUDE CD, DETAI DT, THAMGIADT TGDT 
WHERE GV1.MAGV=GV.GVQLCM  AND DT.MACD=CD.MACD AND TGDT.MAGV=GV.MAGV AND TGDT.MADT=DT.MADT AND DT.MACD=CD.MACD AND CD.TENCD=N'Nghiên cứu phát triển'
GROUP BY GV1.MAGV,GV1.HOTEN,GV1.NGSINH
HAVING COUNT(DISTINCT DT.MADT) =
(SELECT COUNT(DISTINCT DT1.MADT)
FROM DETAI DT1, CHUDE CD1 
WHERE DT1.MACD=CD1.MACD AND CD1.TENCD=N'Nghiên cứu phát triển')
