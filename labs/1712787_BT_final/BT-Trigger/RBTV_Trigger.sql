---------BTTL-------

--CAU 1
USE QLDT
GO
--//////////////////////////////////////////////////////////////////////////
--a. Giới tính của Giáo viên phải là Nam hoặc Nữ
--RULE
CREATE RULE PHAI_RULE
AS 
@range = N'Nam' OR @range = N'Nữ'; --range: vi phạm

EXEC sp_bindrule 'PHAI_RULE', 'GIAOVIEN.PHAI'
EXEC sp_unbindrule 'GIAOVIEN.PHAI'
--CHECK
ALTER TABLE GIAOVIEN
   ADD CONSTRAINT myCheckConstraint1 CHECK(PHAI = N'Nam' OR PHAI = N'Nữ')
ALTER TABLE GIAOVIEN
   DROP CONSTRAINT myCheckConstraint1;
--//////////////////////////////////////////////////////////////////////////
--b. Lương của giáo viên phải là một số tròn chục.
--RULE
CREATE RULE LuongTronChuc_Rule
AS
   @range % 10 = 0
sp_bindrule 'LuongTronChuc_rule', 'GIAOVIEN.LUONG'
sp_unbindrule 'GIAOVIEN.LUONG'
DROP LuongTronChuc_Rule
--CHECK
ALTER TABLE GIAOVIEN
   ADD CONSTRAINT myCheckConstraint2 CHECK(LUONG % 10 = 0)
ALTER TABLE GIAOVIEN
   DROP CONSTRAINT myCheckConstraint2;

--//////////////////////////////////////////////////////////////////////////
--c. Tuổi của giáo viên phải từ 18 tuổi đến 60 tuổi.
--RULE
CREATE RULE TuoiGV_rule
AS
	DATEDIFF(yyyy,@range,GETDATE())>=18 AND DATEDIFF(yyyy,@range,GETDATE())<=60;

sp_bindrule 'TuoiGV_rule','GIAOVIEN.NGSINH'

--CHECK
ALTER TABLE GIAOVIEN
   ADD CONSTRAINT myCheckConstraint3 CHECK(DATEDIFF(yyyy,NGSINH,GETDATE())>=18 AND DATEDIFF(yyyy,NGSINH,GETDATE())<=60)
ALTER TABLE GIAOVIEN
   DROP CONSTRAINT myCheckConstraint3

--//////////////////////////////////////////////////////////////////////////
--CAU 2
--//////////////////////////////////////////////////////////////////////////

--R1: Tên tài phải duy nhất 
CREATE TRIGGER UTR_R1
ON DETAI
FOR INSERT, UPDATE
AS
IF UPDATE(TENDT)
BEGIN
	IF(EXISTS(SELECT * FROM INSERTED I, DETAI DT WHERE I.TENDT = DT.TENDT ))
	BEGIN
		RAISERROR(N'lỗi: Tên đề tài phải duy nhất',16,1)
		ROLLBACK
	END
END
--R2. Trưởng bộ môn phải sinh trước 1975.
CREATE TRIGGER UTR_R2
ON GIAOVIEN
FOR INSERT, UPDATE
AS
IF UPDATE(NGSINH)
BEGIN
	IF(EXISTS(SELECT * FROM INSERTED I, BOMON BM 
	                   WHERE I.MAGV = BM.TRUONGBM
					   AND YEAR(I.NGSINH) >1975))
	BEGIN
		RAISERROR(N'lỗi: Trưởng bộ môn phải sinh trước 1975',16,1)
		ROLLBACK
	END
END
--R3. Một bộ môn có tối thiểu 1 giáo viên nữ
CREATE TRIGGER UTR_R3
ON BOMON
FOR INSERT, UPDATE
AS
IF UPDATE(MABM)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   WHERE (SELECT COUNT(*) FROM GIAOVIEN GV
					  WHERE GV.MABM=I.MABM AND GV.PHAI=N'nữ') < 1)
	BEGIN
		RAISERROR (N'lỗi: bộ môn phải có tối thiểu một giáo viên nữ', 16, 1)
		ROLLBACK
	END
END

DROP TRIGGER UTR_R3
--R4. Một giáo viên phải có ít nhất 1 số điện thoại.
CREATE TRIGGER UTR_R4
ON GV_DT
FOR INSERT, UPDATE
AS
IF UPDATE(DIENTHOAI)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   GROUP BY I.MAGV
			   HAVING COUNT(DIENTHOAI) < 1)
	BEGIN
		RAISERROR (N'lỗi:  Một giáo viên phải có ít nhất 1 số điện thoại', 16, 1)
		ROLLBACK
	END
END
--R5. Một giáo viên có tối đa 3 số điện thoại
CREATE TRIGGER UTR_R5
ON GV_DT
FOR INSERT, UPDATE
AS
IF UPDATE(DIENTHOAI)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   GROUP BY I.MAGV
			   HAVING COUNT(DIENTHOAI) > 3)
	BEGIN
		RAISERROR (N'lỗi: mỗi giáo viên chỉ có tối đa 3 số điện thoại', 16, 1)
		ROLLBACK
	END
END

--R6. Một bộ môn phải có tối thiểu 4 giáo viên
CREATE TRIGGER UTR_R6
ON GIAOVIEN
FOR INSERT, UPDATE
AS
IF UPDATE(MAGV)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   GROUP BY I.MABM
			   HAVING COUNT(MAGV) < 4)
	BEGIN
		RAISERROR (N'lỗi: Một bộ môn phải có tối thiểu 4 giáo viên', 16, 1)
		ROLLBACK
	END
END
--R7. Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn.
CREATE TRIGGER UTR_R7
ON BOMON
FOR INSERT, UPDATE
AS
IF UPDATE(TRUONGBM)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   WHERE TRUONGBM <> (SELECT MAX(DATEDIFF(YYYY, NGSINH, GETDATE()))
								  FROM GIAOVIEN GV
								  WHERE GV.MABM=I.MABM))
	BEGIN
		RAISERROR (N'lỗi: Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn', 16, 1)
		ROLLBACK
	END
END
--R8. Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn.
CREATE TRIGGER UTR_R8
ON BOMON
FOR INSERT, UPDATE
AS
IF UPDATE(TRUONGBM)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I, GIAOVIEN GV
			   WHERE I.TRUONGBM=GV.MAGV AND GV.GVQLCM<>I.TRUONGBM)
	BEGIN
		RAISERROR (N'lỗi: Một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn', 16, 1)
		ROLLBACK
	END
END
--R9. Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn.
CREATE TRIGGER UTR_R9
ON GIAOVIEN
FOR INSERT, UPDATE
AS
IF UPDATE(GVQLCM)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I, GIAOVIEN GVQL
			   WHERE I.GVQLCM=GVQL.MAGV AND I.MABM<>GVQL.MABM)
	BEGIN
		RAISERROR (N'lỗi: giáo viên và giáo viên quản lý chuyên môn phải cùng bộ môn', 16, 1)
		ROLLBACK
	END
END
--R10. Mỗi giáo viên chỉ có tối đa 1 vợ chồng
CREATE TRIGGER UTR_R10
ON GIAOVIEN
FOR UPDATE
AS
IF UPDATE(MAGV)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I, NGUOITHAN NT 
	           WHERE I.MAGV = NT.MAGV
			   GROUP BY I.MAGV
			   HAVING COUNT(I.MAGV) > 1)
	BEGIN
		RAISERROR (N'lỗi: Mỗi giáo viên chỉ có tối đa 1 vợ chồng', 16, 1)
		ROLLBACK
	END
END
--R11. Giáo viên là Nam thì chỉ có vợ chồng là Nữ hoặc ngược lại.
CREATE TRIGGER UTR_R11
ON GIAOVIEN
FOR UPDATE
AS
IF UPDATE(PHAI)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   WHERE EXISTS (SELECT * FROM NGUOITHAN NT
							 WHERE NT.MAGV=I.MAGV AND NT.PHAI=I.PHAI))
	BEGIN
		RAISERROR (N'giáo viên là nam thì chỉ có vợ chồng là nữ hoặc ngược lại', 16, 1)
		ROLLBACK
	END
END
--R12. Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân.
CREATE TRIGGER UTR_R12
ON GIAOVIEN
FOR UPDATE
AS
IF UPDATE(MAGV)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I, NGUOITHAN NT 
	           WHERE I.MAGV = NT.MAGV AND NT.QUANHE= N'con gái' OR NT.QUANHE= N'con trai' 
			   AND YEAR(NT.NGSINH)<YEAR(I.NGSINH)
	BEGIN
		RAISERROR (N'lỗi: Năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân', 16, 1)
		ROLLBACK
	END
END
--R13. Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài.
CREATE TRIGGER UTR_R13
ON GIAOVIEN
FOR UPDATE
AS
IF UPDATE(MAGV)
BEGIN
	IF EXISTS (SELECT * FROM INSERTED I
			   WHERE EXISTS (SELECT * FROM DETAI DT
							 WHERE I.MAGV=DT.GVCNDT
							 GROUP BY GVCNDT
							 HAVING COUNT(*)>3))
	BEGIN
		RAISERROR (N'lỗi: một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài', 16, 1)
		ROLLBACK
	END
END
--R14. Một đề tài phải có ít nhất một công việc
CREATE TRIGGER UTR_R14
ON CONGVIEC
FOR DELETE, UPDATE
AS
IF UPDATE(MADT)
BEGIN
	IF EXISTS (SELECT * FROM DELETED D
	           WHERE EXISTS(SELECT *FROM CONGVIEC CV
			                        WHERE CV.MADT = D.MADT
									HAVING COUNT(*) < 1))
	BEGIN
		RAISERROR (N'lỗi: Một đề tài phải có ít nhất một công việc', 16, 1)
		ROLLBACK
	END
END

--R15: Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó
CREATE TRIGGER UTR_R15
ON GIAOVIEN
FOR INSERT, UPDATE
AS
	IF UPDATE (LUONG) OR UPDATE (GVQLCM)
	BEGIN
		-- 
		IF EXISTS (SELECT * FROM INSERTED I, GIAOVIEN GV
				   WHERE I.MAGV = GV.GVQLCM AND GV.LUONG >= I.LUONG)
		BEGIN
		    RAISERROR (N'lỗi: Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó', 16, 1)
			ROLLBACK 
		END
		
		--
		IF EXISTS (SELECT * FROM INSERTED I, GIAOVIEN GV
				   WHERE I.GVQLCM = GV.MAGV AND GV.LUONG <= I.LUONG)
		BEGIN
			ROLLBACK 
		END
	END
GO
 DROP TRIGGER UTR_R15
--R16: Lương của trưởng bộ môn phải lớn hơn lương của các gv trong bộ môn
CREATE TRIGGER UTR_R16BOMON
ON BOMON
FOR INSERT, UPDATE
AS
	IF UPDATE (TRUONGBM)
	BEGIN
		IF EXISTS (SELECT * FROM INSERTED I, GIAOVIEN GV
					WHERE I.TRUONGBM = GV.MAGV AND GV.LUONG < ANY (SELECT LUONG FROM GIAOVIEN WHERE MABM = I.MABM))
		BEGIN
			ROLLBACK 
		END
	END
GO
 
CREATE TRIGGER UTR_R16GIAOVIEN
ON GIAOVIEN
FOR UPDATE
AS
	IF UPDATE (LUONG)
	BEGIN
		IF EXISTS (SELECT * FROM INSERTED I, BOMON BM, GIAOVIEN GV
					WHERE I.MABM = BM.MABM AND BM.TRUONGBM = GV.MAGV AND GV.LUONG < ANY (SELECT LUONG FROM GIAOVIEN WHERE MABM = I.MABM))
		BEGIN
			ROLLBACK 
		END
	END
GO
 
--R17: Bộ môn nào cũng phải có trưởng bộ môn và trưởng bộ môn đó phải là một giáo viên trong trường
 --> YÊU CẦU KHÔNG PHÙ HỢP VỚI DATABASE

--R18. Một giáo viên chỉ quản lý tối đa 3 giáo viên khác.
CREATE TRIGGER UTG_R18
ON GIAOVIEN
FOR INSERT, UPDATE
AS
	IF UPDATE (GVQLCM)
	BEGIN
		IF EXISTS (SELECT * FROM INSERTED I
					WHERE EXISTS(SELECT * FROM GIAOVIEN GV
									WHERE GV.GVQLCM = I.GVQLCM
									HAVING COUNT(*) > 3))
		BEGIN
			RAISERROR(N'Một giáo viên chỉ quản lý tối đa 3 giáo viên khác', 16, 1)
			ROLLBACK TRAN
		END
	END
GO

--R19. Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó
CREATE TRIGGER UTG_R19THAMGIADT
ON THAMGIADT
FOR INSERT, UPDATE
AS
	IF UPDATE(MAGV) OR UPDATE(MADT)
	BEGIN
		IF EXISTS (SELECT * 
					FROM INSERTED I JOIN GIAOVIEN GV ON I.MAGV = GV.MAGV
					WHERE GV.MABM <> (SELECT GV1.MABM
										FROM GIAOVIEN GV1 JOIN DETAI DT ON GV1.MAGV = DT.GVCNDT
										WHERE DT.MADT = I.MADT))
		BEGIN
			RAISERROR (N'Lỗi !!! GIáo viên chủ nhiệm & giáo viên tham gia đề tài phải cùng bộ môn', 16, 0)
			ROLLBACK 
		END 
	END
GO

CREATE TRIGGER UTG_R19DETAI
on DETAI
FOR UPDATE
AS
	IF UPDATE(GVCNDT)
	BEGIN
		IF EXISTS (SELECT * 
					FROM THAMGIADT TG, GIAOVIEN GVTG, INSERTED D, GIAOVIEN GVCN
					WHERE TG.MAGV = GVTG.MAGV AND TG.MADT = D.MADT AND D.GVCNDT = GVCN.MAGV AND 
                            GVTG.MABM <> GVCN.MABM)
		BEGIN
			RAISERROR (N'Lỗi !!! GIáo viên chủ nhiệm & giáo viên tham gia đề tài phải cùng bộ môn', 16, 0)
			ROLLBACK
		END
	END
GO

