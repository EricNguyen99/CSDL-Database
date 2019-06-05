-------------------------------------------------------------------------
--Cau Q35: Cho biết mức lượng cao nhất của các giảng viên
SELECT LUONG
FROM GIAOVIEN
WHERE LUONG >=ALL(SELECT LUONG FROM GIAOVIEN)
--Cau Q36: Cho biết những giáo viên có lương lớn nhất
SELECT *
FROM GIAOVIEN
WHERE LUONG >=ALL(SELECT LUONG FROM GIAOVIEN)
--Cau Q37: Cho biết mức lương cao nhất trong bộ môn "HTTT"
SELECT *
FROM GIAOVIEN
WHERE LUONG >=ALL(
SELECT LUONG 
FROM GIAOVIEN
WHERE MABM = 'HTTT'
)
--Cau Q38: Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin
SELECT HOTEN
FROM GIAOVIEN
WHERE YEAR(NGSINH) <=ALL(
SELECT YEAR(NGSINH)
FROM GIAOVIEN
WHERE MABM = 'HTTT'
)
--Cau Q39: Cho biết tên giáo viên nhỏ tuổi nhất khoa CNTT
SELECT HOTEN
FROM GIAOVIEN
WHERE YEAR(NGSINH) <=ALL(
SELECT YEAR(NGSINH)
FROM GIAOVIEN GV, KHOA K
WHERE GV.MAGV = K.TRUONGKHOA AND K.TENKHOA = N'Công nghệ thông tin'
)
--Cau Q40: Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất
SELECT GV.HOTEN, K.TENKHOA
FROM GIAOVIEN GV, KHOA K
WHERE GV.MAGV = K.TRUONGKHOA 
AND LUONG >=ALL(SELECT LUONG FROM GIAOVIEN)
--Cau Q41: Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ 
SELECT *
FROM GIAOVIEN
WHERE LUONG <=ALL(
SELECT GV.LUONG
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MAGV = BM.TRUONGBM 
)
--Cau Q42: Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia
SELECT DISTINCT dt.TENDT
FROM DETAI dt,GIAOVIEN gv,THAMGIADT tg
WHERE gv.MAGV = tg.MAGV AND gv.HOTEN = N'Nguyễn Hoài An' AND NOT EXISTS(
SELECT*
FROM CONGVIEC cv
WHERE cv.MADT = tg.MADT AND cv.SOTT = tg.STT AND dt.MADT = cv.MADT
) 
--Cau Q43: Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. 
--Xuất ra tên đề tài, tên người chủ nhiệm đề tài.
SELECT DISTINCT dt.TENDT,(SELECT gv1.HOTEN FROM GIAOVIEN gv1 WHERE gv1.MAGV = dt.GVCNDT)
FROM DETAI dt,GIAOVIEN gv,THAMGIADT tg
WHERE gv.MAGV = tg.MAGV AND gv.HOTEN = N'Nguyễn Hoài An' AND NOT EXISTS(
SELECT*
FROM CONGVIEC cv
WHERE cv.MADT = tg.MADT AND cv.SOTT = tg.STT AND dt.MADT = cv.MADT
) 
--Cau Q44: Cho biết tên những giáo viên khoa CNTT mà chưa tham gia đề tài nào 
SELECT GV.HOTEN
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MABM = BM.MABM AND BM.MAKHOA = 'CNTT' AND NOT EXISTS(
SELECT *
FROM THAMGIADT TGDT
WHERE TGDT.MAGV = GV.MAGV
)
--Cau Q45: Tìm những giao viên không tham gia bất kì đề tài nào
SELECT GV.*
FROM GIAOVIEN GV
WHERE NOT EXISTS(
SELECT *
FROM THAMGIADT TGDT
WHERE TGDT.MAGV = GV.MAGV
)
--Cau Q46: Cho biết giáo viên có lương lớn hơn lương của giáo viên "Nguyễn Hoài An" 
SELECT GV1.*
FROM GIAOVIEN GV1
WHERE GV1.LUONG > (SELECT GV2.LUONG
FROM GIAOVIEN GV2
WHERE GV2.HOTEN = N'Nguyễn Hoài An'
)
--Cau Q47: Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài 
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv, BOMON bm, THAMGIADT tg
WHERE bm.TRUONGBM = gv.MAGV AND tg.MAGV = gv.MAGV
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(DISTINCT tg.MAGV)>=1

--Cau Q48: Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
--SELECT gv.*
--FROM GIAOVIEN gv, GIAOVIEN gv1
--WHERE gv.PHAI = gv1.PHAI AND gv.MABM = gv1.MABM  AND gv.HOTEN = gv1.HOTEN
--GROUP BY gv.MABM

--Cau Q49: Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn "Công nghệ tri thức"
SELECT gv.* 
FROM GIAOVIEN gv 
WHERE gv.LUONG > SOME( --or ANY
                     SELECT gv1.LUONG 
					 FROM GIAOVIEN gv1,BOMON bm
					 WHERE  gv1.MABM = bm.MABM AND bm.TENBM = N'Công nghệ tri thức' --(test)N'Hệ thống thông tin' 
					 ) 
--Cau Q50: Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn "Hệ thống thông tin"
SELECT gv.* 
FROM GIAOVIEN gv 
WHERE gv.LUONG > ALL ( --test >= thì ra 2 nhân viên có lương 2500
                     SELECT gv1.LUONG 
					 FROM GIAOVIEN gv1,BOMON bm
					 WHERE  gv1.MABM = bm.MABM AND bm.TENBM = N'Hệ thống thông tin' 
					 )
--Cau Q51: Cho biết tên khoa có đông giáo viên nhất       = >KQ: CNTT 
SELECT k.TENKHOA 
FROM KHOA k , BOMON bm
WHERE k.MAKHOA = bm.MAKHOA AND bm.MABM = (SELECT MABM
                                          FROM GIAOVIEN
                                          GROUP BY MABM
                                          HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                                                                 FROM GIAOVIEN gv
                                                                 GROUP BY gv.MABM))
-------------ERROR

--Cau Q52: Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
SELECT gv.HOTEN
FROM GIAOVIEN gv, DETAI dt
WHERE gv.MAGV = dt.GVCNDT
GROUP BY gv.HOTEN  
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM DETAI dt1,GIAOVIEN gv1
					   WHERE dt1.GVCNDT = gv1.MAGV  
                       GROUP BY gv1.HOTEN)          
                        
--Cau Q53: Cho biết mã bộ môn có nhiều giáo viên nhất
SELECT MABM
FROM GIAOVIEN
GROUP BY MABM
HAVING COUNT(*) >= ALL( SELECT COUNT(*)
                        FROM GIAOVIEN gv
                        GROUP BY gv.MABM)
--Cau Q54: Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất
SELECT gv.HOTEN, bm.TENBM 
FROM GIAOVIEN gv, THAMGIADT tg, BOMON bm
WHERE gv.MAGV = tg.MAGV AND bm.MABM = gv.MABM
GROUP BY gv.HOTEN, bm.TENBM  
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM THAMGIADT tg1,GIAOVIEN gv1
					   WHERE tg1.MAGV = gv1.MAGV  
                       GROUP BY gv1.HOTEN) 
--Cau Q55: Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT
SELECT gv.HOTEN 
FROM GIAOVIEN gv, THAMGIADT tg
WHERE gv.MAGV = tg.MAGV AND gv.MABM = 'HTTT' 
GROUP BY gv.HOTEN  
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM THAMGIADT tg1,GIAOVIEN gv1
					   WHERE tg1.MAGV = gv1.MAGV AND gv1.MABM = 'HTTT' 
                       GROUP BY gv1.HOTEN) 
--Cau Q56: Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất
SELECT gv.HOTEN, bm.TENBM 
FROM GIAOVIEN gv, NGUOITHAN nt, BOMON bm
WHERE gv.MAGV = nt.MAGV AND bm.MABM = gv.MABM
GROUP BY gv.HOTEN, bm.TENBM  
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM NGUOITHAN nt1,GIAOVIEN gv1
					   WHERE nt1.MAGV = gv1.MAGV  
                       GROUP BY gv1.HOTEN)
--Cau Q57: Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất
SELECT gv.HOTEN
FROM GIAOVIEN gv, DETAI dt, BOMON bm
WHERE gv.MAGV = dt.GVCNDT AND gv.MAGV =bm.TRUONGBM
GROUP BY gv.HOTEN  
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM DETAI dt1,GIAOVIEN gv1, BOMON bm1
					   WHERE dt1.GVCNDT = gv1.MAGV AND gv1.MAGV =bm1.TRUONGBM 
                       GROUP BY gv1.HOTEN) 