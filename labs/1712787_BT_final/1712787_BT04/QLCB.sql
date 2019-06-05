USE master
GO

USE QLCB
GO

--Cau Q17: Với mỗi sân bay (SBDEN), cho biết số lượng chuyến bay hạ cánh xuống sân bay đó.
--Kết quả được sắp xếp theo thứ tự tăng dần của sân bay đến.
SELECT SBDEN, COUNT(MACB) AS SL_MB
FROM CHUYENBAY
GROUP BY SBDEN
ORDER BY SBDEN ASC

--Cau Q18: Vời mối sân bay (SBDI), cho biết số lượng chuyến bay xuất phát từ sân bay đó,
--sắp xếp theo thứ tăng dần của sân bay xuất phát.
SELECT SBDI, COUNT(MACB) AS SL_CB
FROM CHUYENBAY
GROUP BY SBDI 
ORDER BY SBDI ASC

--Cau Q19: Với mỗi sân bay (SBDI), cho biết số lượng chuyến bay xuất phát theo từng ngày.
--Xuất ra mã sân bay đi, ngày và số lượng.
SELECT CB.SBDI, LB.NGAYDI, COUNT(CB.MACB) AS SL_CHUYENBAY_XP
FROM CHUYENBAY CB, LICHBAY LB
WHERE CB.MACB = LB.MACB
GROUP BY CB.SBDI, LB.NGAYDI

--Cau Q20: Với mỗi sân bay (SBDEN), cho biết số lượng chuyến bay hạ cánh theo từng ngày.
--Xuất ra mã sân bay đi, ngày và số lượng.
SELECT CB.SBDEN, LB.NGAYDI, COUNT(CB.MACB) AS SL_CHUYENBAY_HC
FROM CHUYENBAY CB, LICHBAY LB
WHERE CB.MACB = LB.MACB
GROUP BY CB.SBDEN, LB.NGAYDI

--Cau Q21: Với mỗi lịch bay, cho biết mã chuyến bay, ngày đi cùng với số lượng nhân viên không
-- phải là phi công của chuyến bay đó.
SELECT LB.MACB, LB.NGAYDI, COUNT(NV.MANV) AS SL_NV
FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB
WHERE NV.LOAINV = 0 AND LB.MACB = PC.MACB AND PC.MANV = NV.MANV
GROUP BY LB.MACB, LB.NGAYDI

--Cau Q22: Số lượng chuyến bay xuất phát từ sân bay MIA vào ngày 11/01/2000
SELECT CB.SBDI, LB.NGAYDI, COUNT(CB.MACB) AS SL_CHUYENBAY
FROM CHUYENBAY CB, LICHBAY LB
WHERE CB.SBDI = 'MIA' AND LB.NGAYDI = '11-01-2000' AND CB.MACB = LB.MACB
GROUP BY CB.SBDI, LB.NGAYDI

--Cau Q23: Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, số lượng nhân viên được phân công
--trên chuyến bay đó, sắp theo thứ tự giảm dần của số lượng.
SELECT PC.MACB, PC.NGAYDI, COUNT(PC.MANV) AS SL_NV
FROM PHANCONG PC
GROUP BY PC.MACB, PC.NGAYDI
ORDER BY SL_NV DESC

--Cau Q24: Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, cùng với số lượng hành khách đã đặt chỗ
-- của chuyến bay đó, sắp theo thứ tự giảm dần của số lượng.
SELECT MACB, NGAYDI, COUNT(MAKH) AS SL_HK
FROM DATCHO
GROUP BY MACB, NGAYDI
ORDER BY COUNT(MAKH) DESC

--Cau Q25: Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, tổng lương của phi hành đoàn (các nhân viên được
--phân công trong chuyến bay), sắp xếp theo thứ tự tăng dần của tổng lương
SELECT PC.MACB, PC.NGAYDI, SUM(NV.LUONG) AS TONG_LUONG
FROM NHANVIEN NV, PHANCONG PC
WHERE NV.MANV = PC.MANV
GROUP BY PC.MACB, PC.NGAYDI
ORDER BY SUM(NV.LUONG) ASC

--Cau Q26: Cho biết lương trung bình của các nhân viên không phải là phi công.
SELECT AVG(NV.LUONG) AS LUONG_TB
FROM NHANVIEN NV
WHERE NV.LOAINV = 0

--Cau Q27: Cho biết mức lương trung bình của các phi công
SELECT AVG(LUONG) AS LUONG_TB
FROM NHANVIEN
WHERE LOAINV = 1

--Cau Q28: Với mỗi loại máy bay, cho biết số lượng chuyến bay đã bay trên loại máy bay đó hạ cánh xuống sân bay QRD
--Xuất ra mã loại máy bay, số lượng chuyến bay.
SELECT LB.MALOAI, COUNT(LB.MACB) AS SL_CB
FROM CHUYENBAY CB, LICHBAY LB
WHERE LB.MACB = CB.MACB AND CB.SBDEN = 'ORD'
GROUP BY LB.MALOAI

--Cau Q29: Cho biết sân bay (SBDI) và số lượng chuyến bay có nhiều hơn 2 chuyến bay xuất phát trong khoảng 10 giờ đến 22 giờ
SELECT SBDI, COUNT(*) AS SL_CB
FROM CHUYENBAY
WHERE GIODI BETWEEN '10:00:00' AND '22:00:00'
GROUP BY SBDI
HAVING COUNT(*) > 2

--Cau Q30: Cho biết tên phi công được phân công vào ít nhất 2 chuyến bay trong cùng một ngày.
SELECT PC.NGAYDI, NV.TEN, COUNT(PC.MACB) AS SL_CB
FROM NHANVIEN NV, PHANCONG PC
WHERE NV.MANV = PC.MANV
GROUP BY NV.TEN, PC.NGAYDI
HAVING COUNT(PC.MACB) >= 2

--Cau Q31: Cho biết mã chuyến bay và ngày đi của những chuyến bay có ít hơn 3 hành khách đặt chỗ.
SELECT MACB, NGAYDI, COUNT(*) AS SL_HK
FROM DATCHO 
GROUP BY MACB, NGAYDI
HAVING COUNT(*) < 3


--Cau Q32: Cho biết số hiệu máy bay và loại máy bay mà phi công có mã 1001 được phân công lái trên 2 lần.
SELECT LB.SOHIEU, LB.MALOAI, COUNT(*) AS SL_LAI
FROM PHANCONG PC, LICHBAY LB
WHERE PC.MANV = '1001' AND PC.MACB = LB.MACB AND PC.NGAYDI = LB.NGAYDI
GROUP BY LB.SOHIEU, LB.MALOAI
HAVING COUNT(*) > 2
--HAVING COUNT(*) = 1 (Test)

--Cau Q33: Với mỗi hãng sản xuất, cho biết số lượng loại máy bay mà hãng đó đã sản xuất. Xuất ra hãng sản xuất và số lượng.
SELECT HANGSX, COUNT(*) AS SL_MB
FROM LOAIMB
GROUP BY HANGSX

