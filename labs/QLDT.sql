USE master
GO
--B1: Create database
IF DB_ID('QLDT') IS NOT NULL
DROP DATABASE QLDT
GO

CREATE DATABASE QLDT
GO

USE QLDT
GO

--B2: CREATE TABLE
CREATE TABLE GIAOVIEN 
(
	MAGV CHAR(5), 
	HOTEN NVARCHAR(40), 
	LUONG FLOAT, 
	PHAI NCHAR(3), 
	NGSINH DATE, 
	DIACHI NVARCHAR(100), 
	GVQLCM CHAR(5), 
	MABM NCHAR(5)

	CONSTRAINT PK_GIAOVIEN
	PRIMARY KEY (MAGV)
)

CREATE TABLE GV_DT 
(
	MAGV CHAR(5), 
	GV_DT CHAR(12),

	CONSTRAINT PK_GV_DT
	PRIMARY KEY (MAGV, GV_DT)
)

CREATE TABLE BOMON 
(
	MABM NCHAR(5),
	TENBM NVARCHAR(40), 	 
	PHONG CHAR(5),
	DIENTHOAI CHAR(12), 
	TRUONGBM CHAR(5), 
	MAKHOA CHAR(4), 	
	NGAYNHANCHUC DATE,

	CONSTRAINT PK_BOMON
	PRIMARY KEY (MABM)
)
CREATE TABLE KHOA 
(
	MAKHOA CHAR(4), 
	TENKHOA NVARCHAR(40), 
	NAMTL INT, 
	PHONG CHAR(5), 
	GV_DT CHAR(12), 	
	TRUONGKHOA CHAR(5), 
	NGAYNHANCHUC DATE,

	CONSTRAINT PK_KHOA
	PRIMARY KEY (MAKHOA)	
)

CREATE TABLE DETAI 
(
	MADT CHAR(3), 
	TENDT NVARCHAR(100), 
	CAPQL NVARCHAR(40), 
	KINHPHI FLOAT, 
	NGAYBD DATE, 
	NGAYKT DATE, 	
	MACD NCHAR(4),
	GVCNDT CHAR(5), 	

	CONSTRAINT PK_DETAI
	PRIMARY KEY (MADT)
)

CREATE TABLE CHUDE 
(
	MACD NCHAR(4), 
	TENCD NVARCHAR(50),

	CONSTRAINT PK_CHUDE
	PRIMARY KEY (MACD)
)
CREATE TABLE CONGVIEC 
(
	MADT CHAR(3), 
	SOTT INT, 
	TENCV NVARCHAR(40), 
	NGAYBD DATE, 
	NGAYKT DATE,

	CONSTRAINT PK_CONGVIEC
	PRIMARY KEY (MADT, SOTT) 
)

CREATE TABLE THAMGIADT 
(
	MAGV CHAR(5), 
	MADT CHAR(3), 
	STT INT, 
	PHUCAP FLOAT , 
	KETQUA NVARCHAR(40),

	CONSTRAINT PK_THAMGIADT
	PRIMARY KEY (MAGV, MADT, STT)
)

CREATE TABLE NGUOITHAN 
(
	MAGV CHAR(5), 
	TEN NVARCHAR(20), 
	NGSINH DATE, 
	PHAI NCHAR(3),

	CONSTRAINT PK_NGUOITHAN
	PRIMARY KEY (MAGV, TEN)
)
-------------------Create Foreign key------------------------
ALTER TABLE GIAOVIEN ADD
	CONSTRAINT FK_GIAOVIEN_BOMON FOREIGN KEY (MABM) REFERENCES BOMON (MABM),
	CONSTRAINT FK_GIAOVIEN_GIAOVIEN FOREIGN KEY (GVQLCM) REFERENCES GIAOVIEN (MAGV)

ALTER TABLE KHOA ADD 
	CONSTRAINT FK_KHOA_GIAOVIEN FOREIGN KEY (TRUONGKHOA) REFERENCES GIAOVIEN (MAGV)

ALTER TABLE BOMON ADD 
	CONSTRAINT FK_BOMON_KHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA),
	CONSTRAINT FK_BOMON_GIAOVIEN FOREIGN KEY (TRUONGBM) REFERENCES GIAOVIEN (MAGV)

ALTER TABLE NGUOITHAN ADD
	CONSTRAINT FK_NGUOITHAN_GIAOVIEN FOREIGN KEY (MAGV)REFERENCES GIAOVIEN (MAGV)

ALTER TABLE THAMGIADT ADD
	CONSTRAINT FK_THAMGIADT_GIAOVIEN FOREIGN KEY (MAGV)REFERENCES GIAOVIEN (MAGV),
	CONSTRAINT FK_THAMGIADT_CONGVIEC FOREIGN KEY (MADT, STT)REFERENCES CONGVIEC(MADT, SOTT)

ALTER TABLE DETAI ADD
	CONSTRAINT FK_DETAI_CHUDE FOREIGN KEY (MACD)REFERENCES CHUDE (MACD)

ALTER TABLE DETAI ADD
	CONSTRAINT FK_DETAI_GIAOVIEN FOREIGN KEY (GVCNDT)REFERENCES GIAOVIEN (MAGV)

ALTER TABLE GV_DT ADD
	CONSTRAINT FK_GV_DT_GIAOVIEN FOREIGN KEY (MAGV)REFERENCES GIAOVIEN (MAGV)

ALTER TABLE CONGVIEC ADD 	
	CONSTRAINT FK_CONGVIEC_DETAI FOREIGN KEY (MADT)REFERENCES DETAI (MADT)
----------------
INSERT INTO KHOA VALUES ('CNTT',N'Công nghệ thông tin',1995,'B11','0838123456',NULL,'02/20/2005')
INSERT INTO KHOA VALUES ('VL',N'Vật lý',1976,'B21','0838223223',NULL,'09/18/2003')
INSERT INTO KHOA VALUES ('SH',N'Sinh học',1980,'B31','0838454545',NULL,'10/11/2000')
INSERT INTO KHOA VALUES ('HH',N'Hóa học',1980,'B41','0838456456',NULL,'10/15/2001')
----------------
INSERT INTO BOMON VALUES (N'HTTT',N'Hệ thống thông tin','B13','0838125125',NULL,'CNTT','09/20/2004')
INSERT INTO BOMON VALUES (N'CNTT',N'Công nghệ tri thức','B15','0838126126',NULL, 'CNTT', NULL)
INSERT INTO BOMON VALUES (N'MMT',N'Mạng máy tính','B16','0838676767 ',NULL,'CNTT','05/15/2005')
INSERT INTO BOMON VALUES (N'VLĐT',N'Vật lý điện tử','B23','0838234234',NULL, 'VL', NULL)	
INSERT INTO BOMON VALUES (N'VLƯD',N'Vật lý ứng dụng','B24','0838454545',NULL,'VL','02/18/2006')
INSERT INTO BOMON VALUES (N'VS',N'Vi sinh','B32','0838909090',NULL,'SH','01/01/2007')
INSERT INTO BOMON VALUES (N'SH',N'Sinh hóa','B33','0838898989',NULL, 'SH', NULL)	
INSERT INTO BOMON VALUES (N'HL',N'Hóa lý','B42','0838878787',NULL, 'HH', NULL)	
INSERT INTO BOMON VALUES (N'HPT',N'Hóa phân tích','B43','0838777777',NULL,'HH','10/15/2007')
INSERT INTO BOMON VALUES (N'HHC',N'Hóa hữu cơ','B44','838222222',NULL, 'HH', NULL)	
----------------
INSERT INTO GIAOVIEN VALUES ('001',N'Nguyễn Hoài An',2000,N'Nam','02/15/1973',N'25/3 Lạc Long Quân, Q.10, TP HCM', NULL, N'MMT')
INSERT INTO GIAOVIEN VALUES ('002',N'Trần Trà Hương',2500,N'Nữ','06/20/1960',N'125	Trần Hưng Đạo, Q.1,TP HCM', NULL, N'HTTT')
INSERT INTO GIAOVIEN VALUES ('003',N'Nguyễn Ngọc Ánh',2200,N'Nữ','05/11/1975',N'12/21	Võ Văn Ngân	Thủ Đức, TP HCM', '002',N'HTTT')
INSERT INTO GIAOVIEN VALUES ('004',N'Trương Nam Sơn',2300,N'Nam','06/20/1959',N'215	Lý Thường Kiệt,TP Biên Hòa',NULL, N'VS')
INSERT INTO GIAOVIEN VALUES ('005',N'Lý Hoàng Hà',2500,N'Nam','10/23/1954',N'22/5	Nguyễn Xí, Q.Bình Thạnh, TP HCM',NULL, N'VLĐT')
INSERT INTO GIAOVIEN VALUES ('006',N'Trần Bạch Tuyết',1500,N'Nữ','05/20/1980',N'127	Hùng Vương, TP Mỹ Tho','004',N'VS')
INSERT INTO GIAOVIEN VALUES ('007',N'Nguyễn An Trung',2100,N'Nam','06/05/1976',N'234 3/2, TP Biên Hòa',NULL, N'HPT')
INSERT INTO GIAOVIEN VALUES ('008',N'Trần Trung Hiếu',1800,N'Nam','08/06/1977',N'22/11 Lý Thường Kiệt, TP Mỹ Tho','007',N'HPT')
INSERT INTO GIAOVIEN VALUES ('009',N'Trần Hoàng Nam',2000,N'Nam','11/22/1975',N'234	Trấn Não, An Phú,TP HCM','001',N'MMT')
INSERT INTO GIAOVIEN VALUES ('010',N'Phạm Nam Thanh',1500,N'Nam','12/12/1980',N'221	Hùng Vương, Q.5, TP HCM','007',N'HPT')
----------------
INSERT INTO GV_DT VALUES ('001','0903123123')
INSERT INTO GV_DT VALUES ('001','0838912112')
INSERT INTO GV_DT VALUES ('002','0913454545')
INSERT INTO GV_DT VALUES ('003','0903656565')
INSERT INTO GV_DT VALUES ('003','0838121212')
INSERT INTO GV_DT VALUES ('003','0937125125')
INSERT INTO GV_DT VALUES ('006','0937888888')
INSERT INTO GV_DT VALUES ('008','0913232323')
INSERT INTO GV_DT VALUES ('008','0653717171')
----------------
INSERT INTO CHUDE VALUES (N'QLGD',N'Quản lý giáo dục')
INSERT INTO CHUDE VALUES (N'NCPT',N'Nghiên cứu phát triển')
INSERT INTO CHUDE VALUES (N'ƯDCN',N'Ứng dụng công nghệ')
----------------
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('001',N'HTTT quản lý các trường ĐH',20,N'ĐHQG','10/20/2007','10/20/2008',N'QLGD','002')
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('002',N'HTTT quản lý giáo vụ cho một Khoa','20',N'Trường','10/12/2000','10/12/2001',N'QLGD','002')
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('003',N'Nghiên cứu chế tạo sợi Nanô Platin','300',N'ĐHQG','05/15/2008','05/15/2010',N'NCPT','005')
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('004',N'Tạo vật liệu sinh học bằng màng ối người','100',N'Nhà nước','01/01/2007','12/31/2009',N'NCPT','004')
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('005',N'Ứng dụng hóa học xanh','200',N'Trường','10/10/2003','12/10/2004',N'ƯDCN','007')
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('006',N'Nghiên cứu tế bào gốc','4000',N'Nhà nước','10/20/2006','10/20/2009',N'NCPT','004')
INSERT INTO DETAI (MADT, TENDT, KINHPHI, CAPQL, NGAYBD, NGAYKT, MACD, GVCNDT) VALUES ('007',N'HTTT quản lý thư viện ở các trường ĐH','20',N'Trường','5/10/2009','05/10/2010',N'QLGD','001')
----------------
SET dateformat dmy

INSERT INTO CONGVIEC VALUES ('001',1,N'Khởi tạo và Lập kế hoạch','20/10/2007','20/12/2008')
INSERT INTO CONGVIEC VALUES ('001',2,N'Xác định yêu cầu','21/12/2008','21/03/2008')
INSERT INTO CONGVIEC VALUES ('001',3,N'Phân tích hệ thống','22/03/2008','22/5/2008')
INSERT INTO CONGVIEC VALUES ('001',4,N'Thiết kế hệ thống','23/05/2008','23/06/2008')
INSERT INTO CONGVIEC VALUES ('001',5,N'Cài đặt thử nghiệm','24/06/2008','20/10/2008')
INSERT INTO CONGVIEC VALUES ('006',1,N'Lấy mẫu','20/10/2006','20/02/2007')
INSERT INTO CONGVIEC VALUES ('006',2,N'Nuôi cấy','21/02/2007','21/08/2008')
INSERT INTO CONGVIEC VALUES ('002',1,N'Khởi tạo và Lập kế hoạch','10/05/2009','10/07/2009')
INSERT INTO CONGVIEC VALUES ('002',2,N'Xác định yêu cầu','11/07/2009','11/10/2009')
INSERT INTO CONGVIEC VALUES ('002',3,N'Phân tích hệ thống','12/10/2009','20/12/2009')
INSERT INTO CONGVIEC VALUES ('002',4,N'Thiết kế hệ thống','21/12/2009','22/03/2010')
INSERT INTO CONGVIEC VALUES ('002',5,N'Cài đặt thử nghiệm','23/03/2010','10/05/2010')
SET dateformat mdy
----------------
INSERT INTO THAMGIADT VALUES ('003','001',1,1,N'Đạt')
INSERT INTO THAMGIADT VALUES ('003','001',2,0,N'Đạt')
INSERT INTO THAMGIADT VALUES ('002','001',4,2,N'Đạt')
INSERT INTO THAMGIADT VALUES ('003','001',4,1,N'Đạt')
INSERT INTO THAMGIADT VALUES ('004','006',1,0,N'Đạt')
INSERT INTO THAMGIADT VALUES ('004','006',2,1,N'Đạt')
INSERT INTO THAMGIADT VALUES ('006','006',2,1.5,N'Đạt')
INSERT INTO THAMGIADT VALUES ('001','002',1,0, NULL)	
INSERT INTO THAMGIADT VALUES ('001','002',2,2, NULL)	
INSERT INTO THAMGIADT VALUES ('003','002',2,0, NULL)	
INSERT INTO THAMGIADT VALUES ('009','002',3,0.5, NULL)	
INSERT INTO THAMGIADT VALUES ('009','002',4,1.5, NULL)	
----------------
UPDATE KHOA SET TRUONGKHOA = '002' WHERE MAKHOA='CNTT'
UPDATE KHOA SET TRUONGKHOA = '005' WHERE MAKHOA='VL'
UPDATE KHOA SET TRUONGKHOA = '004' WHERE MAKHOA='SH'
UPDATE KHOA SET TRUONGKHOA = '007' WHERE MAKHOA='HH'
----------------
UPDATE BOMON SET TRUONGBM = '002' WHERE MABM=N'HTTT'
UPDATE BOMON SET TRUONGBM = '001' WHERE MABM=N'MMT'
UPDATE BOMON SET TRUONGBM = '005' WHERE MABM=N'VLƯD'
UPDATE BOMON SET TRUONGBM = '004' WHERE MABM=N'VS'
UPDATE BOMON SET TRUONGBM = '007' WHERE MABM=N'HPT'

UPDATE GIAOVIEN SET GVQLCM = '002' WHERE MAGV = '003'
UPDATE GIAOVIEN SET GVQLCM = '004' WHERE MAGV = '006'
UPDATE GIAOVIEN SET GVQLCM = '007' WHERE MAGV = '008'
UPDATE GIAOVIEN SET GVQLCM = '001' WHERE MAGV = '009'
UPDATE GIAOVIEN SET GVQLCM = '007' WHERE MAGV = '010'
----------------
INSERT INTO NGUOITHAN VALUES ('001', N'Hùng', '1/14/1990', N'Nam')
INSERT INTO NGUOITHAN VALUES ('001', N'Thủy', '12/8/1994', N'Nữ')
INSERT INTO NGUOITHAN VALUES ('003', N'Thu', '9/3/1998', N'Nữ')
INSERT INTO NGUOITHAN VALUES ('003', N'Hà', '9/3/1998', N'Nữ')
INSERT INTO NGUOITHAN VALUES ('008', N'Nam', '5/6/1991', N'Nam')
INSERT INTO NGUOITHAN VALUES ('010', N'Nguyệt', '1/14/2006', N'Nữ')
INSERT INTO NGUOITHAN VALUES ('007', N'Vy', '2/14/2000', N'Nữ')
INSERT INTO NGUOITHAN VALUES ('007', N'Mai', '3/26/2003', N'Nữ')
INSERT INTO NGUOITHAN VALUES ('009', N'An', '8/19/1996', N'Nam')

SELECT * FROM dbo.BOMON
SELECT * FROM dbo.CHUDE
SELECT * FROM dbo.CONGVIEC
SELECT * FROM dbo.DETAI
SELECT * FROM dbo.GIAOVIEN
SELECT * FROM dbo.GV_DT
SELECT * FROM dbo.KHOA
SELECT * FROM dbo.NGUOITHAN
SELECT * FROM dbo.THAMGIADT

----------------------------------------------------
-*************TRUY VÂN DỮ LIỆU****************------
----------------------------------------------------
--Cau Q1: Cho biết họ tên và mức lương của các GV Nữ
SELECT HOTEN, LUONG
FROM GIAOVIEN
WHERE PHAI = N'Nữ'

--Cau Q2: Cho biết họ tên của các giáo viên và lương của họ sau khi tăng 10%
SELECT HOTEN, LUONG*110/100 AS LUONGTANG
FROM GIAOVIEN

--Cau Q3: Cho biết MaGV, họ tên bắt đầy là "Nguyễn" và lương trên $2000 hoặc giáo viên là trưởng bộ môn nhận chức sau năm 1995
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE GV.HOTEN LIKE N'Nguyễn%' AND GV.LUONG >2000
EXCEPT
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM
ON GV.MAGV = BM.TRUONGBM AND BM.NGAYNHANCHUC > '1995'

--Cau Q4: Cho biết tên những GV khoa Công nghệ thông tin
SELECT HOTEN AS HOTEN_GV_KHOA_CNTT
FROM GIAOVIEN GV, KHOA K
WHERE GV.MAGV = K.TRUONGKHOA
AND K.TENKHOA = N'Công nghệ thông tin'

--Cau Q5: Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
SELECT BM.*, GV.* 
FROM GIAOVIEN GV, BOMON BM
WHERE BM.MABM = GV.MABM AND GV.MAGV = BM.TRUONGBM

--Cau Q6: Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
SELECT GV.*, BM.*
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MABM = BM. MABM

--Cau Q7: Cho biết tên đề tài và giáo viên chủ nhiệm đề tài đó
SELECT DISTINCT  DT.TENDT, GV .HOTEN
FROM GIAOVIEN GV, DETAI DT
WHERE GV.MAGV = DT.GVCNDT

--Cau Q8: Với mỗi khoa cho biết thông tin trưởng khoa
SELECT GV.*
FROM GIAOVIEN GV, KHOA K
WHERE GV.MAGV = K.TRUONGKHOA

--Cau Q9: Cho biết các giáo viên của bộ môn "Vi sinh" có tham gia đề tài 006
SELECT GV.*
FROM GIAOVIEN GV
JOIN BOMON BM
ON GV.MABM = BM.MABM AND BM.TENBM = N'Vi sinh'
JOIN THAMGIADT TGDT
ON GV.MAGV =TGDT.MAGV AND TGDT.MADT = '006'

--Cau Q10: Với những đề tài thuộc cấp quản lý "Thành phố" --> đề sai 
--Cho biết mã đề tài, đề tài thuộc chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh và địa chỉ của người ấy
SELECT DT.MADT, DT.MACD, GV.HOTEN, GV.NGSINH, GV.DIACHI
FROM DETAI DT
JOIN GIAOVIEN GV
ON GV.MAGV = DT.GVCNDT
WHERE DT.CAPQL = N'Nhà nước'

--Cau Q11: Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT GV.HOTEN, QL.HOTEN AS QL_CHUYENMON  
FROM GIAOVIEN GV, GIAOVIEN QL
WHERE GV.GVQLCM = QL.MAGV 

--Cau Q12: Tìm họ tên của những giáo viên được "Nguyễn Thanh Tùng" phụ trách trực tiếp

SELECT GV.HOTEN
FROM GIAOVIEN GV,GIAOVIEN QL 
WHERE GV.GVQLCM = QL.MAGV AND QL.HOTEN = N'Nguyễn Thanh Tùng'
--WHERE GV.GVQLCM = QL.MAGV AND QL.HOTEN = N'Trần Trà Hương'

--Cau Q13: Cho biết tên giáo viên là trưởng bộ môn "Hệ thống thông tin"
SELECT GV.HOTEN
FROM GIAOVIEN GV, BOMON BM
WHERE  BM.TRUONGBM = GV.MAGV AND BM.TENBM = N'Hệ thống thông tin' 

--Cau Q14: Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV
JOIN DETAI DT
ON GV.MAGV = DT.GVCNDT
JOIN CHUDE CD
ON CD.MACD = DT.MACD AND CD.TENCD = N'Quản lý giáo dục'

--Cau Q15: Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008
SELECT  CV.TENCV
FROM CONGVIEC CV, DETAI DT
WHERE CV.MADT = DT.MADT AND DT.TENDT = N'HTTT quản lý các trường ĐH'
AND MONTH(CV.NGAYBD) = 3 AND YEAR(CV.NGAYBD) = 2008

--Cau Q16: Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó.
SELECT GV.HOTEN AS TenGv, QL.HOTEN AS TenQuanLyCM
FROM GIAOVIEN GV
JOIN GIAOVIEN QL
ON GV.GVQLCM = QL.MAGV

--Cau Q17: Cho biết các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
SELECT *
FROM CONGVIEC
WHERE MONTH(NGAYBD) > 1 AND MONTH(NGAYBD) < 8 AND YEAR(NGAYBD) = 2007

--Cau Q18: Cho biết họ tên các giáo viên cùng bộ môn với GV "Trần Trà Hương" 
SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE GV.MABM = (
                 SELECT MABM
                 FROM GIAOVIEN
                 WHERE HOTEN = 'Trần Trà Hương'
)
--Cau Q19: Tìm những giáo viên vừa là trưởng bộ môn, vừa là chủ nhiệm đề tài
SELECT DISTINCT GV.*
FROM GIAOVIEN GV
JOIN BOMON BM
ON GV.MAGV = BM.TRUONGBM
JOIN DETAI DT
ON GV.MAGV = DT.GVCNDT

--Cau Q20: Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV 
JOIN BOMON BM
ON GV.MAGV = BM.TRUONGBM
JOIN KHOA K
ON GV.MAGV = K.TRUONGKHOA

--Cau Q21:Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài
SELECT DISTINCT GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM
ON GV.MAGV = BM.TRUONGBM
JOIN DETAI DT
ON GV.MAGV = DT.GVCNDT

--Cau Q22: Cho biết mã số các trưởng khoa mà vừa chủ nhiệm đề tài
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV
JOIN KHOA K
ON GV.MAGV = K.TRUONGKHOA
JOIN DETAI DT
ON GV.MAGV = DT.GVCNDT

--Cau Q23: Cho biết mã số các giáo viên thuộc bộ môn "HTTT" hoặc tham gia đề tài mã "001"
SELECT DISTINCT GV.MAGV
FROM GIAOVIEN GV, BOMON BM, DETAI DT
WHERE GV.MABM = BM.MABM 
AND BM.MABM = 'HTTT'
OR GV.MAGV = DT.GVCNDT
AND DT.MADT = '001'  

--Cau Q24: Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002
SELECT GV2.*
FROM GIAOVIEN GV1, GIAOVIEN GV2 
WHERE GV1.MABM = GV2.MABM AND GV1.MAGV = '002'
AND GV2.MAGV <> '002'

--Cau Q25: Tìm giáo viên là trưởng bộ môn
SELECT GV.*
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MAGV = BM.TRUONGBM

--Cau Q26: Cho biết họ tên và mức lương của các giáo viên
SELECT HOTEN,LUONG
FROM GIAOVIEN

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
SELECT GV.*
FROM GIAOVIEN GV
WHERE EXISTS (SELECT GV1.HOTEN, GV1.PHAI
			  FROM GIAOVIEN GV1
			  WHERE GV1.MAGV <> GV.MAGV AND GV1.HOTEN = GV.HOTEN AND GV1.PHAI = GV.PHAI AND GV1.MABM = GV.MABM)

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
-----------ERROR
SELECT k1.TENKHOA 
FROM GIAOVIEN gv1, BOMON bm1, KHOA k1
WHERE gv1.MABM = bm1.MABM AND bm1.MAKHOA = k1.MAKHOA
GROUP BY k1.MAKHOA
HAVING COUNT(GV1.MAGV) >= ALL(
                              SELECT COUNT(gv2.MAGV) FROM GIAOVIEN gv2, BOMON bm2, KHOA k2
							  WHERE gv2.MABM = bm2.MABM AND bm2.MAKHOA = k2.MAKHOA
							  GROUP BY k2.MAKHOA)

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
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
                (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm --Tất cả các giáo viên HTTT
				 WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Hệ thống thông tin')   
                EXCEPT 
				(SELECT tg2.MAGV FROM THAMGIADT tg2 --những GV mà tg1.MADT đã được tham gia
				 WHERE tg1.MADT = tg2.MADT))
----NOT EXCEPT - phép chia
SELECT DISTINCT dt.MADT, dt.TENDT 
FROM DETAI dt, THAMGIADT tg1
WHERE dt.MADT = tg1.MADT
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
               SELECT * FROM GIAOVIEN gv, BOMON bm
			   WHERE gv.MABM = bm.MABM AND BM.TENBM = N'Hệ thống thông tin'
			   AND NOT EXISTS (SELECT *
			                     FROM THAMGIADT tg2
								 WHERE tg2.MADT = tg1.MADT
								 AND gv.MAGV = tg2.MAGV)) 
----COUNT - gom nhóm
SELECT DISTINCT tg1.MADT, dt.TENDT 
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
AND NOT EXISTS( --Những GV mà đề tài tg1.MaDT không được tham gia
               SELECT * FROM GIAOVIEN gv, BOMON bm
			   WHERE gv.MABM = bm.MABM AND BM.TENBM = N'Hóa Hữu Cơ'
			   AND NOT EXISTS (SELECT *
			                     FROM THAMGIADT tg2
								 WHERE tg2.MADT = tg1.MADT
								 AND gv.MAGV = tg2.MAGV)) 

----COUNT - gom nhóm
--SELECT DISTINCT tg1.MADT, dt.TENDT 
--FROM DETAI dt, THAMGIADT tg1
--WHERE dt.MADT = tg1.MADT AND tg1.MAGV IN (SELECT gv.MAGV FROM GIAOVIEN gv, BOMON bm
--                                          WHERE gv.MABM = bm.MABM AND bm.TENBM = N'Hóa Hữu Cơ')
--										  GROUP BY tg1.MADT, dt.TENDT
--										  HAVING COUNT(DISTINCT tg1.MAGV) = 
--										  (SELECT COUNT(gv1.MAGV) FROM GIAOVIEN gv1, BOMON bm1
--										  WHERE gv1.MABM = bm1.MABM AND bm1.TENBM = N'Hóa Hữu Cơ')

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

----COUNT - gom nhóm
--SELECT DISTINCT tg1.MAGV , gv.HOTEN 
--FROM THAMGIADT tg1 , GIAOVIEN gv 
--WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT cv.MADT FROM CONGVIEC cv, THAMGIADT tg
--                                          WHERE cv.MADT = tg.MADT AND cv.SOTT = tg.STT AND cv.MADT = '006') 
--										  GROUP BY tg1.MAGV , gv.HOTEN 
--										  HAVING COUNT(DISTINCT tg1.MADT) = 
--										  (SELECT COUNT(cv.MADT) FROM CONGVIEC cv, THAMGIADT tg
--                                          WHERE cv.MADT = tg.MADT AND cv.SOTT = tg.STT AND cv.MADT = '006')

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

----COUNT - gom nhóm
--SELECT tg1.MAGV , gv.HOTEN 
--FROM THAMGIADT tg1 , GIAOVIEN gv 
--WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT dt.MADT FROM DETAI dt, CHUDE cd 
--                                          WHERE dt.MACD = cd.MACD AND cd.TENCD = 'Ứng dụng công nghệ') 
--										  GROUP BY tg1.MAGV , gv.HOTEN 
--										  HAVING COUNT(DISTINCT tg1.MADT) = 
--										  (SELECT COUNT(dt.MADT) FROM DETAI dt, CHUDE cd 
--                                          WHERE dt.MACD = cd.MACD AND cd.TENCD = 'Ứng dụng công nghệ')
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

----COUNT - gom nhóm
--SELECT DISTINCT tg1.MAGV , gv.HOTEN 
--FROM THAMGIADT tg1 , GIAOVIEN gv 
--WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT cv.MADT FROM CONGVIEC cv, DETAI dt
--                                          WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Nghiên cứu tế bào gốc') 
--										  GROUP BY tg1.MAGV , gv.HOTEN 
--										  HAVING COUNT(DISTINCT tg1.MADT) = 
--										 (SELECT COUNT(cv.MADT) FROM CONGVIEC cv, DETAI dt
--                                          WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Nghiên cứu tế bào gốc')
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

----COUNT - gom nhóm
--SELECT DISTINCT tg1.MAGV , gv.HOTEN, gv.NGSINH
--FROM THAMGIADT tg1 , GIAOVIEN gv
--WHERE tg1.MAGV = gv.MAGV AND tg1.MADT IN (SELECT cv.MADT FROM CONGVIEC cv, DETAI dt
--                                          WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Ứng dụng hóa học xanh') 
--										  GROUP BY tg1.MAGV , gv.HOTEN, gv.NGSINH 
--										  HAVING COUNT(DISTINCT tg1.MADT) = 
--										 (SELECT COUNT(cv.MADT) FROM CONGVIEC cv, DETAI dt
--                                          WHERE cv.MADT = dt.MADT AND dt.TENDT = N'Ứng dụng hóa học xanh')

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

----COUNT - gom nhóm
SELECT DISTINCT GV1.MAGV,GV1.HOTEN,GV1.NGSINH 
FROM GIAOVIEN GV,GIAOVIEN GV1,CHUDE CD, DETAI DT, THAMGIADT TGDT 
WHERE GV1.MAGV=GV.GVQLCM  AND DT.MACD=CD.MACD AND TGDT.MAGV=GV.MAGV AND TGDT.MADT=DT.MADT AND DT.MACD=CD.MACD AND CD.TENCD=N'Nghiên cứu phát triển'
GROUP BY GV1.MAGV,GV1.HOTEN,GV1.NGSINH
HAVING COUNT(DISTINCT DT.MADT) =
(SELECT COUNT(DISTINCT DT1.MADT)
FROM DETAI DT1, CHUDE CD1 
WHERE DT1.MACD=CD1.MACD AND CD1.TENCD=N'Nghiên cứu phát triển')
