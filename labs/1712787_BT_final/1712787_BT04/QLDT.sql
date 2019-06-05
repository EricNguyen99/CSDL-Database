USE master
GO

USE QLDT
GO

--Cau Q27: Cho biết số lượng GV và tổng lương của họ
SELECT COUNT(*) AS SoLuongGV, SUM(LUONG) AS TongLuong 
FROM GIAOVIEN

--Cau Q28: Cho biết số lượng GV và lương trung bình của từng bộ môn
SELECT GV.MABM, COUNT(*) AS SoLuongGV, AVG(LUONG)AS _AVG 
FROM GIAOVIEN GV
GROUP BY GV.MABM

--Cau Q29: Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó
SELECT CD.TENCD, COUNT(DT.MADT) AS SOLUONG_DT
FROM CHUDE CD, DETAI DT
WHERE DT.MACD = CD.MACD
GROUP BY CD.TENCD

--Cau Q30: Cho biết tên GV và số lượng đề tài mà GV đó tham gia
SELECT GV.HOTEN, COUNT(TGDT.MADT) AS SL_DT_THAMGIA
FROM GIAOVIEN GV, THAMGIADT TGDT
WHERE GV.MAGV = TGDT.MAGV
GROUP BY GV.HOTEN

--Cau Q31: Cho biết tên GV và số lượng đề tài mà GV đó làm chủ nhiệm
SELECT GV.HOTEN, COUNT(DT.MADT) AS SL_DT_GVCN
FROM GIAOVIEN GV, DETAI DT
WHERE GV.MAGV = DT.GVCNDT
GROUP BY GV.HOTEN

--Cau Q32: Với mỗi giáo viên cho biết tên GV và số lượng người thân của GV đó
SELECT GV.HOTEN, COUNT(NT.MAGV) AS SL_NGUOITHAN
FROM GIAOVIEN GV, NGUOITHAN NT
WHERE GV.MAGV = NT.MAGV
GROUP BY GV.HOTEN

--Cau Q33:Cho biết tên những giáo viên đã tham gai từ 3 đề tài trở lên 
SELECT GV.HOTEN
FROM GIAOVIEN GV, THAMGIADT TGDT
WHERE GV.MAGV = TGDT.MAGV 
GROUP BY GV.MAGV,GV.HOTEN
HAVING COUNT(TGDT.MADT)>=3

--Cau Q34: Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh
SELECT COUNT( TGDT.MAGV) AS SOLUONG
FROM THAMGIADT TGDT
JOIN CONGVIEC CV
ON TGDT.MADT = CV.MADT AND TGDT.STT = CV.SOTT
JOIN DETAI DT
ON CV.MADT = DT.MADT 
--WHERE DT.MADT = '001'
WHERE DT.TENDT = N'Ứng dụng hóa học xanh'
--N'Nghiên cứu tế bào gốc'
