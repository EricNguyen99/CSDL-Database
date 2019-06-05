USE master
GO

IF DB_ID('QLCB') IS NOT NULL
DROP DATABASE QLCB
GO
--Tạo database quản lý chuyến bay
CREATE DATABASE QLCB
GO

USE QLCB
GO
------------------------------------------------
--Tạo bảng KHACHHANG
CREATE TABLE KHACHHANG(
    MAKH NCHAR(15),
    TEN  NCHAR(50),
    DCHI NCHAR(50),
    DTHOAI NCHAR(12),

	CONSTRAINT PK_KHACHHANG PRIMARY KEY(MAKH)
);
--Tạo bảng NHANVIEN
CREATE TABLE NHANVIEN(
    MANV NCHAR(15),
    TEN  NCHAR(50),
    DCHI NCHAR(50),
    DTHOAI NCHAR(12),
    LUONG FLOAT,
    LOAINV BIT,

	CONSTRAINT PK_NHANVIEN PRIMARY KEY(MANV)
);
--Tạo bảng LOAIMB
CREATE TABLE LOAIMB(
    MALOAI NCHAR(15),
    HANGSX NCHAR(15),

	CONSTRAINT PK_LOAIMB PRIMARY KEY(MALOAI)
);
--Tạo bảng MAYBAY
CREATE TABLE MAYBAY(
    SOHIEU INT,
    MALOAI NCHAR(15),

	CONSTRAINT PK_MAYBAY PRIMARY KEY(SOHIEU, MALOAI)
)
--Tạo bảng CHUYENBAY
CREATE TABLE CHUYENBAY(
    MACB  NCHAR(15),
    SBDI  NCHAR(3),
    SBDEN NCHAR(3),
    GIODI TIME,
    GIODEN TIME,

	CONSTRAINT PK_CHUYENBAY PRIMARY KEY(MACB)
);
--Tạo bảng LICHBAY
CREATE TABLE LICHBAY(
    NGAYDI DATE,
    MACB   NCHAR(15),
    SOHIEU INT,
    MALOAI NCHAR(15)

	CONSTRAINT PK_LICHBAY PRIMARY KEY(NGAYDI, MACB)
);
--Tạo bảng DATCHO
CREATE TABLE DATCHO(
    MAKH NCHAR(15),
    NGAYDI DATE,
    MACB   NCHAR(15),

	CONSTRAINT PK_DATCHO PRIMARY KEY(MAKH, NGAYDI, MACB)
);

--Tạo bảng KHANANG
CREATE TABLE KHANANG(
    MANV NCHAR(15),
    MALOAI NCHAR(15),


	CONSTRAINT PK_KHANANG PRIMARY KEY(MANV, MALOAI)
);
--Tạo bảng PHANCONG
CREATE TABLE PHANCONG(
    MANV NCHAR(15),
    NGAYDI DATE,
    MACB NCHAR(15),

	CONSTRAINT PK_PHANCONG PRIMARY KEY(MANV, NGAYDI, MACB)
);

--------------------------------------------------------------------
--Tạo khóa ngoại từ bảng DATCHO tham chiếu đến bảng KHACHHANG
ALTER TABLE DATCHO
ADD CONSTRAINT FK_DATCHO_KHACHHANG
FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
--Tạo khóa ngoại từ bảng DATCHO tham chiếu đến bảng LICHBAY
ALTER TABLE DATCHO
ADD CONSTRAINT FK_DATCHO_LICHBAY
FOREIGN KEY (NGAYDI, MACB) REFERENCES LICHBAY(NGAYDI, MACB)
--Tạo khóa ngoại từ bảng LICHBAY tham chiếu đến bảng CHUYENBAY
ALTER TABLE LICHBAY
ADD CONSTRAINT FK_LICHBAY_CHUYENBAY
FOREIGN KEY (MACB) REFERENCES CHUYENBAY(MACB)
--Tạo khóa ngoại từ bảng LICHBAY tham chiếu đến bảng MAYBAY
ALTER TABLE LICHBAY
ADD CONSTRAINT FK_LICHBAY_MAYBAY
FOREIGN KEY (SOHIEU, MALOAI) REFERENCES MAYBAY(SOHIEU, MALOAI)
--Tạo khóa ngoại từ bảng MAYBAY tham chiếu đến bảng LOAIMB
ALTER TABLE MAYBAY
ADD CONSTRAINT FK_MAYBAY_LOAIMB
FOREIGN KEY (MALOAI) REFERENCES LOAIMB(MALOAI)
--Tạo khóa ngoại từ bảng PHANCONG tham chiếu đến bảng LICHBAY
ALTER TABLE PHANCONG
ADD CONSTRAINT FK_PHANCONG_LICHBAY
FOREIGN KEY (NGAYDI, MACB) REFERENCES LICHBAY(NGAYDI, MACB)
--Tạo khóa ngoại từ bảng PHANCONG tham chiếu đến bảng NHANVIEN
ALTER TABLE PHANCONG
ADD CONSTRAINT FK_PHANCONG_NHANVIEN
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
--Tạo khóa ngoại từ bảng KHANANG tham chiếu đến bảng NHANVIEN
ALTER TABLE KHANANG
ADD CONSTRAINT FK_KHANANG_NHANVIEN
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
--Tạo khóa ngoại từ bảng KHANANG tham chiếu đến bảng LOAIMB
ALTER TABLE KHANANG
ADD CONSTRAINT FK_KHANANG_LOAIMB
FOREIGN KEY (MALOAI) REFERENCES LOAIMB(MALOAI)
------------------------------------------------------------------------
--Insert giá trị vào bảng NHANVIEN
INSERT INTO NHANVIEN VALUES
('1006', 'CHI', '12/6 NGUYEN KIEM', '8120012', '150000', '0'),
('1005','GIAO','65 NGUYEN THAI SON','8324467','500000','0'),
('1001','HUONG','8 DIEN BIEN PHU','8330733','500000','1'),
('1002','PHONG','1 LY THUONG KIET','8308117','450000','1'),
('1004','PHUONG','351 LAC LONG QUAN','8308155','250000','0'),
('1003','QUANG','78 TRUONG DINH','8324461','350000','1'),
('1007','TAM','36 NGUYEN VAN CU','8458188','500000','0')
--Insert giá trị vào bảng LOAIMB
INSERT INTO LOAIMB VALUES
('A310','AIRBUS'),
('A320','AIRBUS'),
('A330','AIRBUS'),
('A340','AIRBUS'),
('B727','BOEING'),
('B747','BOEING'),
('B757','BOEING'),
('DC10','MD'),
('DC9','MD')
--Insert giá trị vào bảng KHACHHANG
INSERT INTO KHACHHANG VALUES
('0009','NGA','223 NGUYEN TRAI','8932320'),
('0101','ANH','567 TRAN PHU','8826729'),
('0045','THU','285 LE LOI','8932203'),
('0012','HA','435 QUANG TRUNG','8933232'),
('0238','HUNG','456 PASTEUR','9812101'),
('0397','THANH','234 LE VAN SI','8952943'),
('0582','MAI','789 NGUYEN DU',''),
('0934','MINH','678 LE LAI',''),
('0091','HAI','345 HUNG VUONG','8893223'),
('0314','PHUONG','395 VO VAN TAN','8232320'),
('0613','VU','348 CMT8','8343232'),
('0586','SON','123 BACH DANG','8556223'),
('0422','TIEN','75 NGUYEN THONG','8332222')
--Insert giá trị vào bảng KHANANG
INSERT INTO KHANANG VALUES
('1001','B727'),
('1001','B747'),
('1001','DC10'),
('1001','DC9'),
('1002','A320'),
('1002','A340'),
('1002','B757'),
('1002','DC9'),
('1003','A310'),
('1003','DC9')
--Insert giá trị vào bảng MAYBAY
INSERT INTO MAYBAY VALUES
('11','B727'),
('13','B727'),
('10','B747'),
('13','B747'),
('22','B757'),
('93','B757'),
('21','DC9'),
('22','DC9'),
('23','DC9'),
('24','DC9'),
('21','DC10'),
('70','A310'),
('80','A310')
--Insert giá trị vào bảng CHUYENBAY
INSERT INTO CHUYENBAY VALUES
('100','SLC','BOS','08:00:00','17:50:00'),
('112','DCA','DEN','14:00:00','18:07:00'),
('121','STL','SLC','07:00:00','09:13:00'),
('122','STL','YYV','08:30:00','10:19:00'),
('206','DFW','STL','09:00:00','11:40:00'),
('330','JFK','YYV','16:00:00','18:53:00'),
('334','ORD','MIA','12:00:00','14:14:00'),
('335','MIA','ORD','15:00:00','17:14:00'),
('336','ORD','MIA','18:00:00','20:14:00'),
('337','MIA','ORD','20:30:00','23:53:00'),
('394','DFW','MIA','19:00:00','21:30:00'),
('395','MIA','DFW','21:00:00','23:43:00'),
('449','CDG','DEN','10:00:00','19:29:00'),
('930','YYV','DCA','13:00:00','16:10:00'),
('931','DCA','YYV','17:00:00','18:10:00'),
('932','DCA','YYV','18:00:00','19:10:00'),
('991','BOS','ORD','17:00:00','18:22:00')
--Insert giá trị vào bảng LICHBAY
INSERT INTO LICHBAY VALUES 
('2000/11/1','100','80','A310'),
('2000/11/1','112','21','DC10'),
('2000/11/1','206','22','DC9'),
('2000/11/1','334','10','B747'),
('2000/11/1','395','23','DC9'),
('2000/11/1','991','22','B757'),
('2000/11/1','337','10','B747'),
('2000/10/31','100','11','B727'),
('2000/10/31','112','11','B727'),
('2000/10/31','206','13','B727'),
('2000/10/31','334','10','B747'),
('2000/10/31','335','10','B747'),
('2000/10/31','337','24','DC9'),
('2000/10/31','449','70','A310')
--Insert giá trị vào bảng DATCHO
INSERT INTO DATCHO VALUES
('0009','11/1/2000','100'),
('0009','2000/10/31','449'),
('0045','11/1/2000','991'),
('0012','2000/10/31','206'),
('0238','2000/10/31','334'),
('0582','11/1/2000','991'),
('0091','11/1/2000','100'),
('0314','2000/10/31','449'),
('0613','11/1/2000','100'),
('0586','11/1/2000','991'),
('0586','2000/10/31','100'),
('0422','2000/10/31','449')
--Insert giá trị vào bảng PHANCONG
INSERT INTO PHANCONG VALUES
('1001','2000/11/1','100'),
('1001','2000/10/31','100'),
('1002','2000/11/1','100'),
('1002','2000/10/31','100'),
('1003','2000/10/31','100'),
('1003','2000/10/31','337'),
('1004','2000/10/31','100'),
('1004','2000/10/31','337'),
('1005','2000/10/31','337'),
('1006','2000/11/1','991'),
('1006','2000/10/31','337'),
('1007','2000/11/1','112'),
('1007','2000/11/1','991'),
('1007','2000/10/31','206')

SELECT * FROM CHUYENBAY
SELECT * FROM KHACHHANG
SELECT * FROM DATCHO
SELECT * FROM KHANANG 
SELECT * FROM LICHBAY
SELECT * FROM LOAIMB
SELECT * FROM MAYBAY
SELECT * FROM NHANVIEN
SELECT * FROM PHANCONG

----------------------------------------------------
----Truy vấn
----Cau Q1: Cho biết mã số, tên phi công, địa chỉ, điện thoại của các phi công đã từng lái máy bay loại B747
--SELECT NV.MANV, NV.TEN, NV.DCHI, NV.DTHOAI
--FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB
--WHERE NV.MANV = PC.MANV AND PC.MACB = LB.MACB
--AND LB.MALOAI = 'B747'

----Cau Q2: Cho biết mã số và ngày đi của các chuyến bay xuất phát từ sân bay DCA trong khoảng thời gian từ 14 giờ đến 18 giờ
--SELECT CB.MACB, LB.NGAYDI
--FROM LICHBAY LB, CHUYENBAY CB
--WHERE LB.MACB = CB.MACB 
--AND CB.SBDI = 'DCA'
--AND CB.GIODI BETWEEN '14:00:00' AND '18:00:00'

----Cau Q3: Cho biết tên những NV được phân công trên chuyến bay có mã số 100 xuất phát tại sân bay SLC.
----Các dòng dữ liệu xuất ra ko được phép trùng lặp
--SELECT DISTINCT NV.TEN
--FROM NHANVIEN NV,CHUYENBAY CB, PHANCONG PC 
--WHERE CB.MACB = '100' 
--AND CB.SBDI = 'SLC'
--AND NV.MANV = PC.MANV 
--AND PC.MACB = CB.MACB

----Cau Q4: Cho biết mã loại và số hiệu máy bay đã từng xuất phát từ sân bay MIA
--SELECT DISTINCT lb.MALOAI, LB.SOHIEU
--FROM LICHBAY LB
--JOIN CHUYENBAY CB
--ON CB.MACB = LB.MACB AND CB.SBDI = 'MIA'

----Cau Q5: Cho biết mã chuyến bay, ngày đi, cùng với tên,, địa chỉ, điện thoại của tất cả các hành khách đi trên chuyên bay đó
----Sắp xếp theo thứ tự tăng dần của mã chuyến bay và theo ngày đi giảm dần
--SELECT DISTINCT  DC. MACB, DC.NGAYDI, KH.TEN, KH.DCHI, KH.DTHOAI
--FROM KHACHHANG KH, DATCHO DC
--WHERE KH.MAKH = DC.MAKH
--ORDER BY DC.MACB ASC, DC.NGAYDI DESC

----Cau Q6: Cho biết mã chuyến bay, ngày đi, cùng với tên, địa chỉ, địa chỉ, điện thoại của tất cả những nhân viên được phân công trong chuyến bay đó.
----Sắp xếp theo thứ tự tăng dần của mã chuyến bay và theo ngày đi giảm dần
--SELECT  PC.MACB, PC.NGAYDI, NV.TEN, NV.DCHI, NV.DTHOAI
--FROM PHANCONG PC, NHANVIEN NV
--WHERE  PC.MANV = NV.MANV
--ORDER BY PC.MACB ASC, PC.NGAYDI DESC

----Cau Q7: Cho biết mã chuyến bay, ngày đi, mã số và tên của những phi công được phân công vào chuyến bay hạ cánh xuống sân bay QRD
--SELECT  PC.MACB, PC.NGAYDI, NV.MANV, NV.TEN
--FROM PHANCONG PC, NHANVIEN NV, CHUYENBAY CB
--WHERE  NV.LOAINV = 1 AND CB.SBDEN = 'ORD' AND NV.MANV = PC.MANV
--AND PC.MACB = CB.MACB

----Cau Q8: Cho biết các chuyến bay (Mã số chuyến bay, ngày đi và tên của phi công) trong đó phi công có mã 1001 được phân công lái
--SELECT PC.MACB, PC.NGAYDI, NV.TEN
--FROM NHANVIEN NV, PHANCONG PC
--WHERE PC.MANV = NV.MANV 
--AND NV.MANV = '1001'

----Cau Q9: Cho biết thông tin (Mã chuyến bay, sân bay đi, giờ đi, giờ đến, ngày đi) của những chuyến bay hạ cánh xuống DEN.
----Các chuyến bay được liệt kê theo ngày đi giảm dần và sân bay xuất phát (SBDI) tăng dần
--SELECT CB.MACB, CB.SBDI, CB.GIODI, CB.GIODEN, LB.NGAYDI
--FROM CHUYENBAY CB, LICHBAY LB
--WHERE CB.SBDEN = 'DEN' AND CB.MACB = LB.MACB
--ORDER BY LB.NGAYDI DESC, CB.SBDI ASC

----Cau Q10: Với mỗi phi công, cho biết hãng SX và mã loại máy bay mà phi công này có khả năng bay được.
----Xuất ra tên phi công, hãng sản xuất và mã loại máy bay.
--SELECT  NV.TEN, LMB.HANGSX, KN.MALOAI
--FROM NHANVIEN NV, KHANANG KN, LOAIMB LMB
--WHERE NV.MANV = KN.MANV AND LMB.MALOAI = KN.MALOAI

----Cau Q11: Cho biết mã phi công, tên phi công đã lái máy bay trong chuyến bay mã số 100 vào ngày 11/01/2000
--SELECT NV.MANV, NV.TEN
--FROM NHANVIEN NV, LICHBAY LB, PHANCONG PC
--WHERE LB.MACB = '100' AND LB.NGAYDI = '11-01-2000'
--AND NV.MANV = PC.MANV AND PC.MACB = LB.MACB AND LB.NGAYDI = PC.NGAYDI
 

----Cau Q12: Cho biết mã chuyến bay, mã nhân viên, tên nhân viên được phân công vào chuyến bay xuất phát ngày 
----10/31/2000 tại sân bay MIA vào lúc 20:30
--SELECT CB.MACB, NV.MANV, NV.TEN
--FROM NHANVIEN NV, CHUYENBAY CB, PHANCONG PC
--WHERE PC.NGAYDI = '10-31-2000' AND CB.SBDI = 'MIA' AND CB.GIODI = '20:30:00'
--AND NV.MANV = PC.MANV AND PC.MACB = CB.MACB

----Cau Q13: Cho biết thông tin về chuyến bay (mã chuyến bay, số hiệu, mã loại, hãng sản xuất) mà phi công "Quang" đã lái
--SELECT PC.MACB, LB.SOHIEU, LB.MALOAI, LMB.HANGSX
--FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB, LOAIMB LMB
--WHERE NV.TEN = 'Quang' AND NV.MANV = PC.MANV AND PC.MACB = LB.MACB
--AND LMB.MALOAI = LB.MALOAI

----Cau Q14: Cho biết tên của những phi công chưa được phân công lái máy bay nào
--SELECT DISTINCT NV.TEN
--FROM NHANVIEN NV, PHANCONG PC
--WHERE NV.MANV = PC.MANV AND PC.MANV <> NV.MANV

----Cau Q15: Cho biết tên khách hàng đã đi chuyến bay trên máy bay của hãng "Boeing"
--SELECT DISTINCT KH.TEN
--FROM KHACHHANG KH, LICHBAY LB, DATCHO DC, LOAIMB LMB
--WHERE LMB.HANGSX = 'Boeing' AND KH.MAKH = DC.MAKH
--AND DC.MACB = LB.MACB AND LMB.MALOAI = LB.MALOAI

----Cau Q16: Cho biết mã các chuyến bay chỉ bay với máy bay số hiệu 10 và mã loại B747
--SELECT LB.MACB
--FROM LICHBAY LB
--WHERE LB.SOHIEU = 10 AND LB.MALOAI = 'B747'

----Cau Q17: Với mỗi sân bay (SBDEN), cho biết số lượng chuyến bay hạ cánh xuống sân bay đó.
----Kết quả được sắp xếp theo thứ tự tăng dần của sân bay đến.
--SELECT SBDEN, COUNT(MACB) AS SL_MB
--FROM CHUYENBAY
--GROUP BY SBDEN
--ORDER BY SBDEN ASC

----Cau Q18: Vời mối sân bay (SBDI), cho biết số lượng chuyến bay xuất phát từ sân bay đó,
----sắp xếp theo thứ tăng dần của sân bay xuất phát.
--SELECT SBDI, COUNT(MACB) AS SL_CB
--FROM CHUYENBAY
--GROUP BY SBDI 
--ORDER BY SBDI ASC

----Cau Q19: Với mỗi sân bay (SBDI), cho biết số lượng chuyến bay xuất phát theo từng ngày.
----Xuất ra mã sân bay đi, ngày và số lượng.
--SELECT CB.SBDI, LB.NGAYDI, COUNT(CB.MACB) AS SL_CHUYENBAY_XP
--FROM CHUYENBAY CB, LICHBAY LB
--WHERE CB.MACB = LB.MACB
--GROUP BY CB.SBDI, LB.NGAYDI

----Cau Q20: Với mỗi sân bay (SBDEN), cho biết số lượng chuyến bay hạ cánh theo từng ngày.
----Xuất ra mã sân bay đi, ngày và số lượng.
--SELECT CB.SBDEN, LB.NGAYDI, COUNT(CB.MACB) AS SL_CHUYENBAY_HC
--FROM CHUYENBAY CB, LICHBAY LB
--WHERE CB.MACB = LB.MACB
--GROUP BY CB.SBDEN, LB.NGAYDI

----Cau Q21: Với mỗi lịch bay, cho biết mã chuyến bay, ngày đi cùng với số lượng nhân viên không
---- phải là phi công của chuyến bay đó.
--SELECT LB.MACB, LB.NGAYDI, COUNT(NV.MANV) AS SL_NV
--FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB
--WHERE NV.LOAINV = 0 AND LB.MACB = PC.MACB AND PC.MANV = NV.MANV
--GROUP BY LB.MACB, LB.NGAYDI

----Cau Q22: Số lượng chuyến bay xuất phát từ sân bay MIA vào ngày 11/01/2000
--SELECT CB.SBDI, LB.NGAYDI, COUNT(CB.MACB) AS SL_CHUYENBAY
--FROM CHUYENBAY CB, LICHBAY LB
--WHERE CB.SBDI = 'MIA' AND LB.NGAYDI = '11-01-2000' AND CB.MACB = LB.MACB
--GROUP BY CB.SBDI, LB.NGAYDI

----Cau Q23: Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, số lượng nhân viên được phân công
----trên chuyến bay đó, sắp theo thứ tự giảm dần của số lượng.
--SELECT PC.MACB, PC.NGAYDI, COUNT(PC.MANV) AS SL_NV
--FROM PHANCONG PC
--GROUP BY PC.MACB, PC.NGAYDI
--ORDER BY SL_NV DESC

----Cau Q24: Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, cùng với số lượng hành khách đã đặt chỗ
---- của chuyến bay đó, sắp theo thứ tự giảm dần của số lượng.
--SELECT MACB, NGAYDI, COUNT(MAKH) AS SL_HK
--FROM DATCHO
--GROUP BY MACB, NGAYDI
--ORDER BY COUNT(MAKH) DESC

----Cau Q25: Với mỗi chuyến bay, cho biết mã chuyến bay, ngày đi, tổng lương của phi hành đoàn (các nhân viên được
----phân công trong chuyến bay), sắp xếp theo thứ tự tăng dần của tổng lương
--SELECT PC.MACB, PC.NGAYDI, SUM(NV.LUONG) AS TONG_LUONG
--FROM NHANVIEN NV, PHANCONG PC
--WHERE NV.MANV = PC.MANV
--GROUP BY PC.MACB, PC.NGAYDI
--ORDER BY SUM(NV.LUONG) ASC

----Cau Q26: Cho biết lương trung bình của các nhân viên không phải là phi công.
--SELECT AVG(NV.LUONG) AS LUONG_TB
--FROM NHANVIEN NV
--WHERE NV.LOAINV = 0

----Cau Q27: Cho biết mức lương trung bình của các phi công
--SELECT AVG(LUONG) AS LUONG_TB
--FROM NHANVIEN
--WHERE LOAINV = 1

----Cau Q28: Với mỗi loại máy bay, cho biết số lượng chuyến bay đã bay trên loại máy bay đó hạ cánh xuống sân bay QRD
----Xuất ra mã loại máy bay, số lượng chuyến bay.
--SELECT LB.MALOAI, COUNT(LB.MACB) AS SL_CB
--FROM CHUYENBAY CB, LICHBAY LB
--WHERE LB.MACB = CB.MACB AND CB.SBDEN = 'ORD'
--GROUP BY LB.MALOAI

----Cau Q29: Cho biết sân bay (SBDI) và số lượng chuyến bay có nhiều hơn 2 chuyến bay xuất phát trong khoảng 10 giờ đến 22 giờ
--SELECT SBDI, COUNT(*) AS SL_CB
--FROM CHUYENBAY
--WHERE GIODI BETWEEN '10:00:00' AND '22:00:00'
--GROUP BY SBDI
--HAVING COUNT(*) > 2

----Cau Q30: Cho biết tên phi công được phân công vào ít nhất 2 chuyến bay trong cùng một ngày.
--SELECT PC.NGAYDI, NV.TEN, COUNT(PC.MACB) AS SL_CB
--FROM NHANVIEN NV, PHANCONG PC
--WHERE NV.MANV = PC.MANV
--GROUP BY NV.TEN, PC.NGAYDI
--HAVING COUNT(PC.MACB) >= 2

----Cau Q31: Cho biết mã chuyến bay và ngày đi của những chuyến bay có ít hơn 3 hành khách đặt chỗ.
--SELECT MACB, NGAYDI, COUNT(*) AS SL_HK
--FROM DATCHO 
--GROUP BY MACB, NGAYDI
--HAVING COUNT(*) < 3


----Cau Q32: Cho biết số hiệu máy bay và loại máy bay mà phi công có mã 1001 được phân công lái trên 2 lần.
--SELECT LB.SOHIEU, LB.MALOAI, COUNT(*) AS SL_LAI
--FROM PHANCONG PC, LICHBAY LB
--WHERE PC.MANV = '1001' AND PC.MACB = LB.MACB AND PC.NGAYDI = LB.NGAYDI
--GROUP BY LB.SOHIEU, LB.MALOAI
--HAVING COUNT(*) > 2
----HAVING COUNT(*) = 1 (Test)

--Cau Q33: Với mỗi hãng sản xuất, cho biết số lượng loại máy bay mà hãng đó đã sản xuất. Xuất ra hãng sản xuất và số lượng.
--SELECT HANGSX, COUNT(*) AS SL_MB
--FROM LOAIMB
--GROUP BY HANGSX

----Q34: Cho biết hãng sản xuất, mã loại và số hiệu của máy bay đã được sử dụng nhiều nhất
--SELECT lmb.HANGSX, mb.MALOAI,mb.SOHIEU 
--FROM MAYBAY mb, LOAIMB lmb,LICHBAY lb
--WHERE mb.MALOAI = lmb.MALOAI AND mb. MALOAI =lb.MALOAI AND mb.SOHIEU = lb.SOHIEU
--GROUP BY lmb.HANGSX, mb.MALOAI,mb.SOHIEU  
--HAVING COUNT(*) >= ALL(SELECT COUNT(*)
--                       FROM LICHBAY lb1, MAYBAY mb1
--					   WHERE mb1. MALOAI =lb1.MALOAI AND mb1.SOHIEU = lb1.SOHIEU
--                       GROUP BY mb1.SOHIEU)
----Q35. Cho biết tên nhân viên được phân công đi nhiều chuyến bay nhất.
--SELECT nv.TEN 
--FROM NHANVIEN nv,PHANCONG pc
--WHERE nv.MANV = pc.MANV AND nv.LOAINV = 0
--GROUP BY nv.TEN
--HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
--                       FROM NHANVIEN nv1,PHANCONG pc1 
--					   WHERE nv1.MANV = pc1.MANV AND nv1.LOAINV = 0
--					   GROUP BY nv1.TEN) 
----Q36. Cho biết thông tin của phi công (tên, địachỉ, điệnthoại) lái nhiều chuyến bay nhất.
--SELECT nv.TEN, nv.DCHI, nv.DTHOAI 
--FROM NHANVIEN nv,PHANCONG pc
--WHERE nv.MANV = pc.MANV AND nv.LOAINV = 1
--GROUP BY nv.TEN, nv.DCHI, nv.DTHOAI 
--HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
--                       FROM NHANVIEN nv1,PHANCONG pc1 
--					   WHERE nv1.MANV = pc1.MANV AND nv1.LOAINV = 1
--					   GROUP BY nv1.TEN) 
----Q37. Cho biết sân bay (SBDEN) và số lượng chuyến bay của sân bay có ít chuyến bay đáp xuống nhất.
--SELECT cb.SBDEN, COUNT(cb.MACB) AS SL_CHUYENBAY 
--FROM CHUYENBAY cb
--GROUP BY cb.SBDEN 	
--HAVING COUNT(*) <= ALL(SELECT COUNT(*) 
--                       FROM CHUYENBAY cb1 
--					   GROUP BY cb1.SBDEN) 
----Q38. Cho biết sân bay (SBDI) và số lượng chuyến bay của sân bay có nhiều chuyến bay xuất phát nhất.
--SELECT cb.SBDI, COUNT(cb.MACB) AS SL_CHUYENBAY 
--FROM CHUYENBAY cb
--GROUP BY cb.SBDI 	
--HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
--                       FROM CHUYENBAY cb1 
--					   GROUP BY cb1.SBDI) 
----Q39. Cho biết tên, địa chỉ, và điện thoại của khách hàng đã đi trên nhiều chuyến bay nhất.
--SELECT kh.TEN, kh.DCHI, kh.DTHOAI 
--FROM KHACHHANG kh,DATCHO dc
--WHERE kh.MAKH = dc.MAKH
--GROUP BY kh.TEN, kh.DCHI, kh.DTHOAI	
--HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
--                       FROM KHACHHANG kh1,DATCHO dc1 
--					   WHERE kh1.MAKH = dc1.MAKH
--					   GROUP BY kh1.TEN)
----Q40. Cho biết mã số, tên và lương của các phi công có khả năng lái nhiều loại máy bay nhất.
--SELECT nv.MANV, nv.TEN, nv.LUONG 
--FROM NHANVIEN nv,KHANANG kn
--WHERE nv.MANV = kn.MANV AND nv.LOAINV = 1
--GROUP BY nv.MANV, nv.TEN, nv.LUONG 
--HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
--                       FROM NHANVIEN nv1,KHANANG kn1
--                       WHERE nv1.MANV = kn1.MANV AND nv1.LOAINV = 1
--					   GROUP BY nv1.MANV) 
----Q41. Cho biết	thông tin (mã nhân viên, tên, lương) của nhân viên có mức lương cao nhất.
--SELECT nv.MANV, nv.TEN, nv.LUONG 
--FROM NHANVIEN nv
--WHERE nv.LOAINV = 0 AND nv.LUONG >= ALL(SELECT MAX(nv1.LUONG) 
--                                        FROM NHANVIEN nv1
--										WHERE nv.LOAINV = 0) 
----Q42. Cho biết	tên, địa chỉ của các nhân viên có lương cao nhất trong phi hành đoàn (các nhân viên được phân công trong một chuyến bay) mà người đó tham gia.
----VD: Trong chuyến bay 337 có 1004, 1005, 1006 thì có max là 1005
----VD: Trong chuyến bay 991 có 1006, 1007 thì có max là 1007
--SELECT DISTINCT nv.MANV, nv.TEN, nv.LUONG 
--FROM NHANVIEN nv, PHANCONG pc
--WHERE nv.LOAINV = 0 AND nv.MANV = pc.MANV
--GROUP BY pc.MACB, nv.MANV, nv.TEN, nv.LUONG 
--HAVING nv.LUONG >= ALL(SELECT MAX(nv1.LUONG)
--                       FROM NHANVIEN nv1, PHANCONG pc1
--					   WHERE nv1.LOAINV = 0 AND nv1.MANV = pc1.MANV
--                       GROUP BY pc1.MACB)                      

----Q43. Cho biết mã chuyến bay,	giờ đi và giờ đến của chuyến bay bay sớm nhất trong ngày.
--SELECT cb.MACB, cb.GIODI, cb.GIODEN
--FROM CHUYENBAY cb 
--WHERE cb.GIODI <= ALL(SELECT MIN(cb1.GIODI)
--                      FROM CHUYENBAY cb1)
----Q44. Cho biết mã chuyến bay có thời gian bay dài nhất. Xuất ra mã chuyến bay và thời gian bay	(tính bằng phút).
--SELECT cb.MACB, DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN) AS THOIGIANBAY
--FROM CHUYENBAY cb
--WHERE DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN)>=ALL(SELECT DATEDIFF(MINUTE,cb1.GIODI,cb1.GIODEN)
--                                               FROM CHUYENBAY cb1)
----Q45. Cho biết mã chuyến bay có thời gian bay ít nhất. Xuất ra	mã chuyến bay và thời gian bay.
--SELECT cb.MACB, DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN) AS THOIGIANBAY
--FROM CHUYENBAY cb
--WHERE DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN)<=ALL(SELECT DATEDIFF(MINUTE,cb1.GIODI,cb1.GIODEN)
--                                               FROM CHUYENBAY cb1)
----Q46. Cho biết mã chuyến bay và ngày đi của những chuyến bay bay trên loại máy bay B747 nhiều nhất.
--SELECT lb.MACB, lb.NGAYDI 
--FROM LICHBAY lb
--WHERE lb.MALOAI = 'B747'
--GROUP BY lb.MACB, lb.NGAYDI 
--HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
--                       FROM LICHBAY lb1
--                       WHERE lb1.MALOAI = 'B747'
--                       GROUP BY lb1.MACB,lb1.NGAYDI)
----Q47. Với mỗi chuyến bay có trên 3 hành khách, cho biết mã chuyến bay và số lượng nhân viên trên chuyến bay đó.	
----Xuất ra mã chuyến bay	và số lượng nhân viên.
--SELECT DISTINCT pc.MACB, COUNT(pc.MANV)
--FROM PHANCONG pc, NHANVIEN nv, DATCHO dc, LICHBAY lb
--WHERE nv.MANV = pc.MANV AND nv.LOAINV = 0 AND pc.MACB = lb.MACB AND pc.NGAYDI = lb.NGAYDI AND dc.NGAYDI = lb.NGAYDI AND dc.MACB = lb.MACB
--GROUP BY pc.MACB
--HAVING COUNT(dc.MAKH) >= 3

----Q48. Với mỗi loại nhân viên có tổng lương trên 600000, cho biết số lượng nhân	viên trong từng	loại nhân viên đó.
---- Xuất ra loại nhân viên, và số lượng nhân viên tương ứng.
--SELECT nv.LOAINV, COUNT(nv.MANV)
--FROM NHANVIEN nv
--GROUP BY nv.LOAINV
--HAVING SUM(nv.LUONG)> 600000
----Q49. Với mỗi chuyến bay có trên 3 nhân viên, cho biết mã chuyến bay và số lượng khách hàng đã đặt chỗ trên chuyến bay đó.
--SELECT DISTINCT dc.MACB, (SELECT COUNT(dc1.MAKH)FROM DATCHO dc1 WHERE dc.MACB = dc1.MACB) AS SO_HK
--FROM DATCHO dc, PHANCONG pc
--WHERE dc.MACB = pc.MACB
--GROUP BY dc.MACB
--HAVING COUNT(pc.MANV) >= 3

--Q50. Với mỗi loại máy	bay có nhiều hơn một chiếc, cho biết số lượng chuyến bay đã được bố trí bay bằng loại máy bay đó. 
--Xuất ra mã loại và số lượng.
SELECT DISTINCT mb.MALOAI , (SELECT COUNT(mb1.SOHIEU)FROM MAYBAY mb1 WHERE mb1.MALOAI = mb.MALOAI) AS SOLUONG
FROM MAYBAY mb, LICHBAY lb
WHERE mb.MALOAI = lb.MALOAI
GROUP BY mb.MALOAI
HAVING COUNT(mb.SOHIEU) > 1

--Q51. Cho biết mã những chuyến bay đã bay tất cả các máy bay của hãng "Boeing".
----EXCEPT - phép trừ
SELECT DISTINCT lb.MACB
FROM LICHBAY lb, MAYBAY mb
WHERE lb.MALOAI = mb.MALOAI
AND NOT EXISTS( 
                (SELECT MALOAI FROM LOAIMB 
				 WHERE HANGSX = 'Boeing')   
                EXCEPT 
				(SELECT mb1.MALOAI FROM MAYBAY mb1
				 WHERE mb.MALOAI = mb1.MALOAI))
----NOT EXISTS - phép chia
SELECT DISTINCT lb.MACB
FROM LICHBAY lb, MAYBAY mb
WHERE lb.MALOAI = mb.MALOAI
AND NOT EXISTS(  
               SELECT * FROM LOAIMB lmb
			   WHERE lmb.HANGSX = 'Boeing'
			   AND NOT EXISTS (SELECT *
			                     FROM MAYBAY mb1
				                 WHERE mb.MALOAI = mb1.MALOAI
								 AND lmb.MALOAI = mb1.MALOAI))
---- NOT IN
SELECT DISTINCT LB1.MACB
FROM LICHBAY LB1
WHERE NOT EXISTS (
				  SELECT MALOAI FROM LOAIMB 
				  WHERE HANGSX = 'Boeing' AND
						MALOAI NOT IN (SELECT LB2.MALOAI FROM LICHBAY LB2
									   WHERE LB1.MACB = LB2.MACB))  
----COUNT - gom nhóm
SELECT  DISTINCT LB.MACB 
FROM LICHBAY LB ,LOAIMB LMB, MAYBAY MB 
WHERE LMB.HANGSX ='Boeing' AND MB.MALOAI=LMB.MALOAI AND LB.MALOAI=MB.MALOAI AND LB.SOHIEU = MB.SOHIEU 
GROUP BY LB.MACB
HAVING COUNT (DISTINCT LB.MALOAI) = 
(SELECT COUNT( DISTINCT MB1.MALOAI) 
FROM MAYBAY MB1, LOAIMB LMB1
 WHERE LMB1.HANGSX='Boeing' AND LMB1.MALOAI=MB1.MALOAI)

--Q52. Cho biết mã và tên phi công có khả năng lái tất cả các máy bay của hãng "Airbus". 
-- EXCEPT
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 1 
AND NOT EXISTS ((SELECT MALOAI FROM LOAIMB WHERE HANGSX = 'Airbus')
				 EXCEPT
				(SELECT KN.MALOAI FROM KHANANG KN WHERE NV.MANV = KN.MANV))

---- NOT EXISTS
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 1 AND NOT EXISTS (
									 SELECT LMB.MALOAI FROM LOAIMB LMB
									 WHERE LMB.HANGSX = 'Airbus' AND
										   NOT EXISTS (SELECT KN.MALOAI FROM KHANANG KN 
													   WHERE NV.MANV = KN.MANV AND KN.MALOAI = LMB.MALOAI))
---- NOT IN
SELECT NV.MANV, NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 1 AND NOT EXISTS (
									 SELECT LMB.MALOAI FROM LOAIMB LMB
									 WHERE LMB.HANGSX = 'Airbus' AND
										   LMB.MALOAI NOT IN (SELECT KN.MALOAI FROM KHANANG KN 
															  WHERE NV.MANV = KN.MANV))
---- COUNT
SELECT NV.MANV,NV.TEN 
FROM NHANVIEN NV,KHANANG KN, LOAIMB LMB 
WHERE NV.MANV=KN.MANV AND KN.MALOAI= LMB.MALOAI AND LMB.HANGSX='Airbus'
GROUP BY NV.MANV,NV.TEN
HAVING COUNT (DISTINCT KN.MALOAI)= 
(SELECT COUNT(DISTINCT KN1.MALOAI)  
FROM KHANANG KN1, LOAIMB LMB1 
WHERE KN1.MALOAI=LMB1.MALOAI AND LMB1.HANGSX='Airbus')

--Q53. Cho biết tên nhân viên (không phải là phi công) được phân công bay vào tất cả các chuyến bay có mã 100. 
SELECT NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 0 AND NOT EXISTS (
									(SELECT NGAYDI FROM LICHBAY WHERE MACB = '100')
									 EXCEPT
									(SELECT PC.NGAYDI FROM PHANCONG PC WHERE PC.MACB = '100' AND PC.MANV = NV.MANV))
---- NOT EXISTS
SELECT NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 0 AND NOT EXISTS (
									 SELECT LB.NGAYDI FROM LICHBAY LB
									 WHERE LB.MACB = '100' AND
										   NOT EXISTS (SELECT PC.NGAYDI FROM PHANCONG PC
													   WHERE PC.MACB = '100' AND PC.MANV = NV.MANV AND LB.NGAYDI = PC.NGAYDI))
---- NOT IN
SELECT NV.TEN
FROM NHANVIEN NV
WHERE NV.LOAINV = 0 AND NOT EXISTS (
									 SELECT LB.NGAYDI FROM LICHBAY LB
									 WHERE LB.MACB = '100' AND
										   LB.NGAYDI NOT IN (SELECT PC.NGAYDI FROM PHANCONG PC
															 WHERE PC.MACB = '100' AND PC.MANV = NV.MANV))
----COUNT
SELECT DISTINCT PC.MANV,NV.TEN 
FROM NHANVIEN NV, PHANCONG PC, LICHBAY LB 
WHERE LB.MACB=N'100' AND LB.MACB=PC.MACB AND PC.MANV=NV.MANV AND PC.NGAYDI=LB.NGAYDI AND NV.LOAINV=0
GROUP BY PC.MANV,NV.TEN
HAVING COUNT(DISTINCT PC.NGAYDI) = 
(SELECT COUNT(*) FROM LICHBAY LB1 WHERE LB1.MACB=N'100')
--Q54. Cho biết ngày đi nào mà có tất cả các loại máy bay của hãng "Boeing" tham gia. 
---- EXCEPT
SELECT DISTINCT LB1.NGAYDI
FROM LICHBAY LB1, LOAIMB LMB
WHERE LB1.MALOAI = LMB.MALOAI AND LMB.HANGSX = 'Boeing' AND
	  NOT EXISTS (
				  (SELECT MALOAI FROM LOAIMB WHERE HANGSX = 'Boeing')
				   EXCEPT
				  (SELECT LB2.MALOAI FROM LICHBAY LB2 WHERE LB1.NGAYDI = LB2.NGAYDI))

---- NOT EXISTS
SELECT DISTINCT LB1.NGAYDI
FROM LICHBAY LB1, LOAIMB LMB1
WHERE LB1.MALOAI = LMB1.MALOAI AND LMB1.HANGSX = 'Boeing' AND
	  NOT EXISTS (
				   SELECT LMB2.MALOAI FROM LOAIMB LMB2
				   WHERE LMB2.HANGSX = 'Boeing' AND
						 NOT EXISTS (SELECT LB2.MALOAI FROM LICHBAY LB2
									 WHERE LB1.NGAYDI = LB2.NGAYDI AND LMB2.MALOAI = LB2.MALOAI))

---- NOT IN
SELECT DISTINCT LB1.NGAYDI
FROM LICHBAY LB1, LOAIMB LMB
WHERE LB1.MALOAI = LMB.MALOAI AND LMB.HANGSX = 'Boeing' AND
	  NOT EXISTS (
				   SELECT MALOAI FROM LOAIMB
				   WHERE HANGSX = 'Boeing' AND
						 MALOAI NOT IN (SELECT LB2.MALOAI FROM LICHBAY LB2
											WHERE LB1.NGAYDI = LB2.NGAYDI))
----COUNT
SELECT DISTINCT LB.NGAYDI 
FROM LICHBAY LB,LOAIMB LMB,MAYBAY MB 
WHERE MB.MALOAI=LB.MALOAI AND LMB.MALOAI=MB.MALOAI AND LMB.HANGSX=N'Boeing'
GROUP BY LB.NGAYDI
HAVING COUNT(DISTINCT MB.MALOAI) =
(SELECT COUNT(DISTINCT MB1.MALOAI ) 
FROM MAYBAY MB1, LOAIMB LMB1 
WHERE LMB1.HANGSX=N'Boeing' AND LMB1.MALOAI=MB1.MALOAI )

--Q55. Cho biết loại máy bay của hãng "Boeing" nào có tham gia vào tất cả các ngày đi. 
---- EXCEPT
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX = 'Boeing' AND NOT EXISTS (
										(SELECT DISTINCT NGAYDI FROM LICHBAY)
										 EXCEPT
										(SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB
										 WHERE LB.MALOAI = LMB.MALOAI))

---- NOT EXISTS
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX = 'Boeing' AND NOT EXISTS (
										SELECT DISTINCT LB1.NGAYDI FROM LICHBAY LB1
										WHERE NOT EXISTS (SELECT DISTINCT LB2.NGAYDI FROM LICHBAY LB2
														  WHERE LB2.MALOAI = LMB.MALOAI AND LB1.NGAYDI = LB2.NGAYDI))
---- NOT IN
SELECT LMB.MALOAI
FROM LOAIMB LMB
WHERE HANGSX = 'Boeing' AND NOT EXISTS (
										SELECT DISTINCT LB1.NGAYDI FROM LICHBAY LB1
										WHERE LB1.NGAYDI NOT IN (SELECT DISTINCT LB2.NGAYDI FROM LICHBAY LB2
														  WHERE LB2.MALOAI = LMB.MALOAI))
---- COUNT
SELECT LMB.MALOAI 
FROM LOAIMB LMB, LICHBAY LB
WHERE LMB.HANGSX=N'Boeing' AND LMB.MALOAI=LB.MALOAI 
GROUP BY LMB.MALOAI
HAVING COUNT(DISTINCT LB.NGAYDI) =
(SELECT COUNT(DISTINCT LB1.NGAYDI) FROM LICHBAY LB1)
--Q56. Cho biết mã và tên các khách hàng có đặt chổ trong tất cả các ngày từ 31/10/2000 đến 1/1/2000 
---- EXCEPT
SELECT KH.MAKH, KH.TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
				  (SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB WHERE LB.NGAYDI BETWEEN '10/31/2000' AND '11/1/2000')
				   EXCEPT
				  (SELECT DISTINCT DC.NGAYDI FROM DATCHO DC WHERE DC.MAKH = KH.MAKH))
---- NOT EXISTS
SELECT KH.MAKH, KH.TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
				  SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB
				  WHERE LB.NGAYDI BETWEEN '10/31/2000' AND '11/1/2000' AND
						NOT EXISTS (SELECT DISTINCT DC.NGAYDI FROM DATCHO DC
									WHERE DC.MAKH = KH.MAKH AND DC.NGAYDI = LB.NGAYDI))
---- NOT IN
SELECT KH.MAKH, KH.TEN
FROM KHACHHANG KH
WHERE NOT EXISTS (
				  SELECT DISTINCT LB.NGAYDI FROM LICHBAY LB
				  WHERE LB.NGAYDI BETWEEN '10/31/2000' AND '11/1/2000' AND
						LB.NGAYDI NOT IN (SELECT DISTINCT DC.NGAYDI FROM DATCHO DC
										  WHERE DC.MAKH = KH.MAKH)
				  )
----COUNT
SELECT DISTINCT KH.MAKH,KH.TEN 
FROM KHACHHANG KH, DATCHO DT, LICHBAY LB 
WHERE LB.MACB=DT.MACB AND KH.MAKH=DT.MAKH AND LB.NGAYDI BETWEEN N'2000-01-01' AND N'2000-10-31'
GROUP BY KH.MAKH,KH.TEN
HAVING COUNT (DISTINCT LB.MACB) =
(SELECT COUNT(DISTINCT LB1.MACB) 
FROM LICHBAY LB1,DATCHO DT1 
WHERE DT1.MACB=LB1.MACB AND LB1.NGAYDI BETWEEN N'2000-01-01' AND N'2000-10-31' )

--Q57. Cho biết mã và tên phi công không có khả năng lái được tất cả các máy bay của hãng "Airbus" 
--COUNT có 2 trường hợp là đếm những đứa chỉ biết lái airbus nhưng lái không hết và TH2: đếm những đứa không lái tất cả airbus bao gồm cả những đứa không lái chiếc airbus nào
SELECT NV.MANV,NV.TEN 
FROM NHANVIEN NV,KHANANG KN, LOAIMB LMB 
WHERE NV.MANV=KN.MANV AND KN.MALOAI= LMB.MALOAI AND LMB.HANGSX=N'Airbus'
GROUP BY NV.MANV,NV.TEN
HAVING COUNT (DISTINCT KN.MALOAI) != 
(SELECT COUNT(DISTINCT LMB1.MALOAI)  
FROM  LOAIMB LMB1 WHERE  LMB1.HANGSX=N'Airbus')

--C2
SELECT KN.MANV,NV.TEN 
FROM NHANVIEN NV , KHANANG KN, LOAIMB LMB 
WHERE KN.MANV = NV.MANV AND	LMB.MALOAI = KN.MALOAI AND NV.LOAINV = 1 
GROUP BY KN.MANV,NV.TEN 
HAVING (SELECT COUNT(DISTINCT KN1.MALOAI) 
FROM KHANANG KN1, LOAIMB LMB1 
WHERE LMB1.MALOAI = kn1.MALOAI AND lmb1.HANGSX = 'Airbus' AND kn1.MANV = kn.MANV) != 
(SELECT COUNT(LMB1.MALOAI) FROM LOAIMB LMB1 
WHERE LMB1.HANGSX = 'Airbus') 

--Q58. Cho biết sân bay nào đã có tất cả các loại máy bay của hãng "Boeing" xuất phát.
SELECT DISTINCT CB.SBDI 
FROM CHUYENBAY CB,LICHBAY LB, MAYBAY MB, LOAIMB LMB 
WHERE LMB.HANGSX=N'Boeing' AND LMB.MALOAI=MB.MALOAI AND MB.MALOAI=LB.MALOAI AND CB.MACB=LB.MACB
GROUP BY CB.SBDI
HAVING COUNT(DISTINCT LMB.MALOAI) = 
(SELECT COUNT(DISTINCT LMB1.MALOAI) 
FROM LOAIMB LMB1 WHERE LMB1.HANGSX=N'Boeing'  )
