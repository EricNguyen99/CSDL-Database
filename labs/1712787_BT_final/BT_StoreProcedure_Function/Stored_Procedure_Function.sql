--***********************************************************
--**------------------BAI TAP TREN LOP --------------------**
--***********************************************************
USE master
GO
--///////////////////////////////////////////////////////////////////////////////////////////
--a. in ra câu chào "Hello world"
CREATE PROCEDURE IN_HELLO
AS
    PRINT 'Hello World'

EXEC IN_HELLO
DROP PROCEDURE IN_HELLO
--///////////////////////////////////////////////////////////////////////////////////////////
--b. in ra tổng 2 số
CREATE PROCEDURE SP_IN_TONG_AB @A INT, @B INT
AS
BEGIN
    SET @A = @A + @B
	PRINT @A
END
EXEC SP_IN_TONG_AB 2, 3
DROP PROC SP_IN_TONG_AB
--///////////////////////////////////////////////////////////////////////////////////////////
--c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về).
CREATE PROC SP_TONG @A INT, @B INT, @TONG INT OUT -- các biến tham số đầu vào
AS
      SET @TONG = @A + @B 
DECLARE @SUM INT
EXEC SP_TONG 1, -2, @SUM OUT
PRINT @SUM

DROP PROCEDURE SP_TONG
--///////////////////////////////////////////////////////////////////////////////////////////
--d. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số).
CREATE PROC SP_TONG_3SO @A INT, @B INT, @C INT
AS
     DECLARE @KETQUA INT
	 EXEC SP_TONG @A, @B, @KETQUA OUT
	 SET @KETQUA = @KETQUA + @C
	 PRINT @KETQUA

EXEC SP_TONG_3SO 1, 2, 3
DROP PROC SP_TONG_3SO
--///////////////////////////////////////////////////////////////////////////////////////////
--e. In ra tổng các số nguyên từ m đến n.
CREATE PROCEDURE SP_INTONGMN @M INT, @N INT
AS
	DECLARE @TONG INT
	DECLARE @I INT
	SET @TONG = 0
	SET @I = @M
	WHILE(@I <= @N)
	BEGIN
		SET @TONG = @TONG + @I
		SET @I = @I + 1
	END
	PRINT @TONG

EXEC SP_INTONGMN 1,5
DROP PROCEDURE SP_INTONGMN
--///////////////////////////////////////////////////////////////////////////////////////////
--f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không.
CREATE PROCEDURE SP_KTNT @X INT, @SOUOC INT OUT
AS
	DECLARE @I INT
	SET @I = 1
	SET @SOUOC = 0
	WHILE(@I <= @X)
	BEGIN
		IF(@X % @I = 0)
			SET @SOUOC = @SOUOC + 1
		SET @I = @I + 1
	END
	
DECLARE @CHECK INT
EXEC SP_KTNT 16, @CHECK OUT
IF(@CHECK=2)
		PRINT N'Là số nguyên tố'
	ELSE
		PRINT N'Không là số nguyên tố'

DROP PROCEDURE SP_KTNT
--///////////////////////////////////////////////////////////////////////////////////////////
--g. In ra tổng các số nguyên tố trong đoạn m, n.
CREATE PROCEDURE SP_SUMNT @M INT, @N INT, @SUMNT INT OUT
AS
	DECLARE @X INT
	DECLARE @CHECK INT
	SET @X = @M
	SET @SUMNT = 0
	WHILE(@X <= @N)
	BEGIN
		EXEC SP_KTNT @X,@CHECK OUT
		BEGIN
			IF(@CHECK=2)
				SET @SUMNT = @SUMNT +@X
			SET @X=@X +1
		END
	END

DECLARE @KQ INT
EXEC SP_SUMNT 2,3,@KQ OUT
PRINT @KQ
DROP PROCEDURE SP_SUMNT
--///////////////////////////////////////////////////////////////////////////////////////////
--h. Tính ước chung lớn nhất của 2 số nguyên.
CREATE PROCEDURE SP_UCLN @A INT, @B INT, @UCLN INT OUT
AS
	SET @UCLN = 0
	WHILE(@A!=@B)
	BEGIN
		IF(@A > @B)
			SET @A = @A - @B
		ELSE
			SET @B = @B - @A
	END
	SET @UCLN = @A

DECLARE @UCLNAB INT
EXEC SP_UCLN 9,6,@UCLNAB OUT
PRINT @UCLNAB
DROP PROCEDURE SP_UCLN 
--///////////////////////////////////////////////////////////////////////////////////////////
--i. Tính bội chung nhỏ nhất của 2 số nguyên.
CREATE PROCEDURE SP_BCNN @A INT, @B INT, @BCNN INT OUT
AS
	DECLARE @UCLN INT
	EXEC SP_UCLN @A, @B, @UCLN OUT
	SET @BCNN = (@A*@B)/@UCLN

DECLARE @BCNNAB INT
EXEC SP_BCNN 3,6,@BCNNAB OUT
PRINT @BCNNAB
DROP PROCEDURE SP_BCNN


USE QLDT
GO
--///////////////////////////////////////////////////////////////////////////////////////////
--j. Xuất ra toàn bộ danh sách giáo viên.
CREATE PROCEDURE SP_DSGV
AS
	SELECT GIAOVIEN.*FROM GIAOVIEN
EXEC SP_DSGV
DROP PROCEDURE SP_DSGV
--///////////////////////////////////////////////////////////////////////////////////////////
--k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
CREATE PROCEDURE SP_TONG_DETAI_GV_THUCHIEN
AS
	SELECT GV.MAGV,COUNT(DISTINCT TGDT.MADT) N'Số lượng đề tài mà GV đang thực hiện'
	FROM GIAOVIEN GV JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
	GROUP BY GV.MAGV

EXEC SP_TONG_DETAI_GV_THUCHIEN
DROP PROCEDURE SP_TONG_DETAI_GV_THUCHIEN
 
--///////////////////////////////////////////////////////////////////////////////////////////
--l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá 
--nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.
CREATE PROCEDURE SP_INTHONGTIN @MAGV CHAR(5)
AS
	IF(@MAGV IN (SELECT MAGV FROM GIAOVIEN))
	BEGIN
		DECLARE @HOTEN NVARCHAR(30)
		DECLARE @PHAI NVARCHAR(5)
		DECLARE @NGSINH DATE
		SET @HOTEN = (SELECT HOTEN FROM GIAOVIEN WHERE @MAGV=MAGV) 
		SET @PHAI = (SELECT PHAI FROM GIAOVIEN  WHERE @MAGV=MAGV)
		SET @NGSINH = (SELECT NGSINH FROM GIAOVIEN  WHERE @MAGV=MAGV)
		DECLARE @SLDETAI INT
		DECLARE @SLTHANNHAN INT
		SET @SLDETAI  = (SELECT COUNT(DISTINCT TGDT.MADT)
						FROM GIAOVIEN GV JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
						WHERE @MAGV=GV.MAGV
						GROUP BY GV.MAGV)
		SET @SLTHANNHAN = (SELECT COUNT(*) 
						   FROM GIAOVIEN JOIN NGUOITHAN ON GIAOVIEN.MAGV = NGUOITHAN.MAGV
						   WHERE @MAGV =GIAOVIEN.MAGV
						   GROUP BY GIAOVIEN.MAGV)
		PRINT @MAGV
		PRINT @HOTEN
		PRINT @PHAI
		PRINT @NGSINH
		PRINT @SLDETAI
		PRINT @SLTHANNHAN
	END

EXEC SP_INTHONGTIN '001'
DROP PROCEDURE  SP_INTHONGTIN
--///////////////////////////////////////////////////////////////////////////////////////////
--m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
CREATE PROCEDURE SP_KT_GV_TONTAI @MAGV VARCHAR(5)
AS
	IF(@MAGV IN (SELECT MAGV FROM GIAOVIEN WHERE @MAGV=MAGV))
		PRINT N'Giáo viên tồn tại'
	ELSE
		PRINT N'Giáo viên không tồn tại'

EXEC SP_KT_GV_TONTAI '00789'
DROP PROCEDURE SP_KT_GV_TONTAI
--///////////////////////////////////////////////////////////////////////////////////////////
--n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ môn của giáo viên đó làm chủ nhiệm.

--///////////////////////////////////////////////////////////////////////////////////////////
--o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài
-- Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc 
-- phải tồn tại, thời gian tham gia phải >0
-- Kiểm tra quy định ở câu n.

--///////////////////////////////////////////////////////////////////////////////////////////
--p. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan 
--(Có thân nhân, có làm đề tài, …) thì báo lỗi.
CREATE PROCEDURE SP_XOA_GV_THEO_MA @MAGV VARCHAR(5)
AS
	IF(EXISTS(SELECT*FROM GIAOVIEN WHERE MAGV = @MAGV)) --KTR GV CÓ TỒN TẠI
	BEGIN
		IF((@MAGV IN (SELECT MAGV FROM NGUOITHAN)) OR (@MAGV IN (SELECT MAGV FROM THAMGIADT)))
			PRINT N'Error... Không thể xóa GV do có thông tin về người thân & tham gia đề tài'
		ELSE
			DELETE FROM GIAOVIEN WHERE @MAGV = MAGV
	END
	ELSE
		PRINT N'Giáo viên không tồn tại nên không thực thi xóa được'

EXEC SP_XOA_GV_THEO_MA '001'
DROP PROCEDURE SP_XOA_GV_THEO_MA
--///////////////////////////////////////////////////////////////////////////////////////////
--q. In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề
-- tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản lý nếu có, …
CREATE PROCEDURE SP_DSGV_PHONG_BAN @MAGV VARCHAR(5)
AS
	--Xét magv tồn tại
	IF(EXISTS (SELECT * FROM GIAOVIEN WHERE @MAGV = MAGV))
	--Magv đó phảo thuộc về 1 phòng ban
	BEGIN
		IF(@MAGV IN (SELECT MAGV FROM (GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM) JOIN KHOA KH ON BM.MAKHOA = KH.MAKHOA))
			DECLARE @HOTEN NVARCHAR(30)
			SET @HOTEN = (SELECT HOTEN FROM GIAOVIEN WHERE @MAGV = MAGV)
			DECLARE @SLDETAI INT
			DECLARE @SLTHANNHAN INT
			DECLARE @SLGV_GVQL INT
			SET @SLDETAI  = (SELECT COUNT(DISTINCT TGDT.MADT)
						FROM GIAOVIEN GV JOIN THAMGIADT TGDT ON GV.MAGV = TGDT.MAGV
						WHERE @MAGV=GV.MAGV
						GROUP BY GV.MAGV)
			SET @SLTHANNHAN = (SELECT COUNT(*) 
						   FROM GIAOVIEN JOIN NGUOITHAN ON GIAOVIEN.MAGV = NGUOITHAN.MAGV
						   WHERE @MAGV =GIAOVIEN.MAGV
						   GROUP BY GIAOVIEN.MAGV)
			SET @SLGV_GVQL = (SELECT COUNT(GVQL.MAGV)
							 FROM GIAOVIEN GV, GIAOVIEN GVQL 
							 WHERE GV.GVQLCM= GVQL.MAGV AND @MAGV=GVQL.MAGV
							 GROUP BY GVQL.MAGV)
	--Xuất thông tin: sldetai tham gia, slthannhan, slgv_gvql
			PRINT @MAGV
			PRINT @HOTEN
			PRINT N'Số lượng đề tài: '
			PRINT @SLDETAI
			PRINT N'Số lượng thân nhân: '
			PRINT @SLTHANNHAN
			PRINT N'Số lượng giáo viên ma gv đó quản lý: '
			PRINT @SLGV_GVQL
	END
	ELSE
		PRINT N'Gv không tồn tại '

EXEC SP_DSGV_PHONG_BAN'007'

--///////////////////////////////////////////////////////////////////////////////////////////
--r. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b thì lương của a phải cao hơn lương của b. (a, b: mã giáo viên)


--///////////////////////////////////////////////////////////////////////////////////////////
--s. Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18, lương > 0

--///////////////////////////////////////////////////////////////////////////////////////////
--t. Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có giáo viên 001, 002, 003 thì MAGV của giáo viên mới sẽ là 004.
-- Nếu đã có giáo viên 001, 002, 005 thì MAGV của giáo viên mới là 003.



--***********************************************************
--**--------------------BAI TAP VE NHA --------------------**
--***********************************************************

CREATE DATABASE QL_DATPHONG 
CREATE TABLE PHONG
(
	MAPHONG		VARCHAR(5),
	TINHTRANG	NVARCHAR(10) CHECK (TINHTRANG IN('Rãnh','Bận')),
	LOAIPHONG	NVARCHAR(10),
	DONGIA		MONEY

	CONSTRAINT PK_MAPHONG PRIMARY KEY(MAPHONG)
)
CREATE TABLE KHACHHANG
(
	MAKH	VARCHAR(5),
	HOTEN	NVARCHAR(30),
	DIACHI	NVARCHAR(50),
	DTH		VARCHAR(12)

	CONSTRAINT PK_MAKH PRIMARY KEY(MAKH)
)
CREATE TABLE DATPHONG
(
	MADP	INT,
	MAKH	VARCHAR(5),
	MAPHONG	VARCHAR(5),
	NGAYDP	DATE,
	NGAYTRA	DATE,
	THANHTIEN	MONEY

	CONSTRAINT PK_MADP PRIMARY KEY(MADP)
)

ALTER TABLE DATPHONG  ADD CONSTRAINT FK_MAKH FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
ALTER TABLE DATPHONG ADD CONSTRAINT FK_MAPHONG FOREIGN KEY (MAPHONG) REFERENCES PHONG(MAPHONG)
 

 USE QL_DATPHONG 
 GO
 -------------------CÂU 1: PROCEDURE ĐẶT PHÒNG----------------------------------------------------------------------------
 --Kiểm tra MaKH hợp lệ
 CREATE PROCEDURE SP_KTMAKHHOPLE @MAKH VARCHAR(5), @FLAG INT OUT
 AS
	SET @FLAG = 0
	IF(@MAKH IN (SELECT MAKH FROM KHACHHANG WHERE @MAKH = MAKH))
		SET @FLAG = 1
 --Kiểm tra MaPhong hợp lệ
 CREATE PROCEDURE SP_KTMAPHONGHOPLE @MAPHONG VARCHAR(5), @FLAG INT OUT
 AS
	SET @FLAG = 0
	IF(@MAPHONG IN (SELECT MAPHONG FROM PHONG WHERE @MAPHONG = MAPHONG))
		SET @FLAG = 1
 --Kiểm tra trạng thái phòng: rãnh hoặc bận :: Phòng rãnh flag = 1
 CREATE PROCEDURE SP_KTTRANGTHAIPHONG @MAPHONG VARCHAR(5), @FLAG INT OUT
 AS
	DECLARE @TRANGTHAI NVARCHAR(10)
	IF(@TRANGTHAI = (SELECT TINHTRANG FROM PHONG WHERE @MAPHONG = MAPHONG))
	BEGIN
		IF(@TRANGTHAI = N'Rãnh')
			SET @FLAG = 1
		ELSE
			SET @FLAG = 0
	END
--Nhận biết thông qua biến flag, Nếu biến flag trong 3 hàm trên đều = 1 => Khách hàng đủ tiêu chí để đặt phòng
 CREATE PROCEDURE SP_DATPHONG @MAKH VARCHAR(5), @MAPHONG VARCHAR(5), @NGAYDAT DATE
 AS
	DECLARE @FLAG1 INT
	DECLARE @FLAG2 INT
	DECLARE @FLAG3 INT
	EXEC SP_KTMAKHHOPLE @MAKH, @FLAG1 OUT
	EXEC SP_KTMAPHONGHOPLE @MAPHONG, @FLAG2 OUT
	EXEC SP_KTTRANGTHAIPHONG @MAPHONG, @FLAG3 OUT
	IF(@FLAG1 = 1 AND @FLAG2 = 1 AND @FLAG3 = 1)
	BEGIN
		DECLARE @MADP INT
		SET @MADP = (SELECT MAX(MADP) FROM DATPHONG) + 1
		INSERT INTO DATPHONG VALUES(@MADP, @MAKH, @MAPHONG, @NGAYDAT, NULL, NULL)
		UPDATE PHONG SET TINHTRANG = N'Bận' WHERE @MAPHONG = MAPHONG
		PRINT N'Đặt phòng thành công'
	END
	ELSE
		PRINT N'Đặt phòng không thành công'
-------------------CÂU 2: PROCEDURE TRẢ PHÒNG----------------------------------------------------------------------------
--Makh & Maphong là hợp lệ
--Chắc chắn rằng khách hàng đã đặt phòng
CREATE PROCEDURE SP_KTKHACHHANG_DATPHONG @MAKH VARCHAR(5), @FLAG INT OUT
AS
	SET @FLAG = 0
	IF(@MAKH = (SELECT MAKH FROM DATPHONG WHERE @MAKH = MAKH))
		SET @FLAG = 1

CREATE PROCEDURE SP_TRAPHONG @MAKH VARCHAR(5), @MADATPHONG INT, @FLAG INT OUT
AS
	DECLARE @FLAG1 INT
	DECLARE @FLAG2 INT
	DECLARE @FLAG3 INT
	EXEC SP_KTMAKHHOPLE @MAKH, @FLAG1 OUT -- Ktr mã khách hàng hợp lệ(1)
	DECLARE @MAPHONG VARCHAR(5)
	SET @MAPHONG = (SELECT MAPHONG FROM DATPHONG WHERE @MAPHONG = MAPHONG)
	EXEC SP_KTMAPHONGHOPLE @MAPHONG, @FLAG2 OUT -- Ktr mã phòng hợp lệ(2)
	EXEC SP_KTKHACHHANG_DATPHONG @MAKH, @FLAG3 OUT -- Đảm bảo khách hàng đã đặt phòng(3)
	IF(@FLAG1 = 1 AND @FLAG2 = 1 AND @FLAG3 = 1) -- Thỏa mãn 3 đk trên
	BEGIN
		DECLARE @NGAYTRA DATE
		DECLARE @NGAYMUON DATE
		SET @NGAYMUON = (SELECT NGAYDP FROM DATPHONG WHERE @MADATPHONG = MADP)
		SET @NGAYTRA =GETDATE() -- ngày trả là ngày hiện tại
		DECLARE @THANHTIEN MONEY
		SET @THANHTIEN = DATEDIFF(D, @NGAYMUON, @NGAYTRA) * (SELECT DONGIA FROM PHONG WHERE @MAPHONG = MAPHONG)
		
		UPDATE DATPHONG SET THANHTIEN = @THANHTIEN WHERE @MADATPHONG = MADP
		UPDATE DATPHONG SET NGAYTRA = @NGAYTRA WHERE  @MADATPHONG = MADP
		UPDATE PHONG SET TINHTRANG = N'rãnh' WHERE @MAPHONG = MAPHONG

		PRINT N'Trả phòng thành công'
	END
	ELSE
		PRINT N'Trả phòng không thành công'

