--Q34: Cho biết hãng sản xuất, mã loại và số hiệu của máy bay đã được sử dụng nhiều nhất
SELECT lmb.HANGSX, mb.MALOAI,mb.SOHIEU 
FROM MAYBAY mb, LOAIMB lmb,LICHBAY lb
WHERE mb.MALOAI = lmb.MALOAI AND mb. MALOAI =lb.MALOAI AND mb.SOHIEU = lb.SOHIEU
GROUP BY lmb.HANGSX, mb.MALOAI,mb.SOHIEU  
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                       FROM LICHBAY lb1, MAYBAY mb1
					   WHERE mb1. MALOAI =lb1.MALOAI AND mb1.SOHIEU = lb1.SOHIEU
                       GROUP BY mb1.SOHIEU)
--Q35. Cho biết tên nhân viên được phân công đi nhiều chuyến bay nhất.
SELECT nv.TEN 
FROM NHANVIEN nv,PHANCONG pc
WHERE nv.MANV = pc.MANV AND nv.LOAINV = 0
GROUP BY nv.TEN
HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
                       FROM NHANVIEN nv1,PHANCONG pc1 
					   WHERE nv1.MANV = pc1.MANV AND nv1.LOAINV = 0
					   GROUP BY nv1.TEN) 
--Q36. Cho biết thông tin của phi công (tên, địachỉ, điệnthoại) lái nhiều chuyến bay nhất.
SELECT nv.TEN, nv.DCHI, nv.DTHOAI 
FROM NHANVIEN nv,PHANCONG pc
WHERE nv.MANV = pc.MANV AND nv.LOAINV = 1
GROUP BY nv.TEN, nv.DCHI, nv.DTHOAI 
HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
                       FROM NHANVIEN nv1,PHANCONG pc1 
					   WHERE nv1.MANV = pc1.MANV AND nv1.LOAINV = 1
					   GROUP BY nv1.TEN) 
--Q37. Cho biết sân bay (SBDEN) và số lượng chuyến bay của sân bay có ít chuyến bay đáp xuống nhất.
SELECT cb.SBDEN, COUNT(cb.MACB) AS SL_CHUYENBAY 
FROM CHUYENBAY cb
GROUP BY cb.SBDEN 	
HAVING COUNT(*) <= ALL(SELECT COUNT(*) 
                       FROM CHUYENBAY cb1 
					   GROUP BY cb1.SBDEN) 
--Q38. Cho biết sân bay (SBDI) và số lượng chuyến bay của sân bay có nhiều chuyến bay xuất phát nhất.
SELECT cb.SBDI, COUNT(cb.MACB) AS SL_CHUYENBAY 
FROM CHUYENBAY cb
GROUP BY cb.SBDI 	
HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
                       FROM CHUYENBAY cb1 
					   GROUP BY cb1.SBDI) 
--Q39. Cho biết tên, địa chỉ, và điện thoại của khách hàng đã đi trên nhiều chuyến bay nhất.
SELECT kh.TEN, kh.DCHI, kh.DTHOAI 
FROM KHACHHANG kh,DATCHO dc
WHERE kh.MAKH = dc.MAKH
GROUP BY kh.TEN, kh.DCHI, kh.DTHOAI	
HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
                       FROM KHACHHANG kh1,DATCHO dc1 
					   WHERE kh1.MAKH = dc1.MAKH
					   GROUP BY kh1.TEN)
--Q40. Cho biết mã số, tên và lương của các phi công có khả năng lái nhiều loại máy bay nhất.
SELECT nv.MANV, nv.TEN, nv.LUONG 
FROM NHANVIEN nv,KHANANG kn
WHERE nv.MANV = kn.MANV AND nv.LOAINV = 1
GROUP BY nv.MANV, nv.TEN, nv.LUONG 
HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
                       FROM NHANVIEN nv1,KHANANG kn1
                       WHERE nv1.MANV = kn1.MANV AND nv1.LOAINV = 1
					   GROUP BY nv1.MANV) 
--Q41. Cho biết	thông tin (mã nhân viên, tên, lương) của nhân viên có mức lương cao nhất.
SELECT nv.MANV, nv.TEN, nv.LUONG 
FROM NHANVIEN nv
WHERE nv.LOAINV = 0 AND nv.LUONG >= ALL(SELECT MAX(nv1.LUONG) 
                                        FROM NHANVIEN nv1
										WHERE nv.LOAINV = 0) 
--Q42. Cho biết	tên, địa chỉ của các nhân viên có lương cao nhất trong phi hành đoàn (các nhân viên được phân công trong một chuyến bay) mà người đó tham gia.
--VD: Trong chuyến bay 337 có 1004, 1005, 1006 thì có max là 1005
--VD: Trong chuyến bay 991 có 1006, 1007 thì có max là 1007
SELECT DISTINCT nv.MANV, nv.TEN, nv.LUONG 
FROM NHANVIEN nv, PHANCONG pc
WHERE nv.LOAINV = 0 AND nv.MANV = pc.MANV
GROUP BY pc.MACB, nv.MANV, nv.TEN, nv.LUONG 
HAVING nv.LUONG >= ALL(SELECT MAX(nv1.LUONG)
                       FROM NHANVIEN nv1, PHANCONG pc1
					   WHERE nv1.LOAINV = 0 AND nv1.MANV = pc1.MANV
                       GROUP BY pc1.MACB)                      

--Q43. Cho biết mã chuyến bay,	giờ đi và giờ đến của chuyến bay bay sớm nhất trong ngày.
SELECT cb.MACB, cb.GIODI, cb.GIODEN
FROM CHUYENBAY cb 
WHERE cb.GIODI <= ALL(SELECT MIN(cb1.GIODI)
                      FROM CHUYENBAY cb1)
--Q44. Cho biết mã chuyến bay có thời gian bay dài nhất. Xuất ra mã chuyến bay và thời gian bay	(tính bằng phút).
SELECT cb.MACB, DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN) AS THOIGIANBAY
FROM CHUYENBAY cb
WHERE DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN)>=ALL(SELECT DATEDIFF(MINUTE,cb1.GIODI,cb1.GIODEN)
                                               FROM CHUYENBAY cb1)
--Q45. Cho biết mã chuyến bay có thời gian bay ít nhất. Xuất ra	mã chuyến bay và thời gian bay.
SELECT cb.MACB, DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN) AS THOIGIANBAY
FROM CHUYENBAY cb
WHERE DATEDIFF(MINUTE,cb.GIODI,cb.GIODEN)<=ALL(SELECT DATEDIFF(MINUTE,cb1.GIODI,cb1.GIODEN)
                                               FROM CHUYENBAY cb1)
--Q46. Cho biết mã chuyến bay và ngày đi của những chuyến bay bay trên loại máy bay B747 nhiều nhất.
SELECT lb.MACB, lb.NGAYDI 
FROM LICHBAY lb
WHERE lb.MALOAI = 'B747'
GROUP BY lb.MACB, lb.NGAYDI 
HAVING COUNT(*) >= ALL(SELECT COUNT(*) 
                       FROM LICHBAY lb1
                       WHERE lb1.MALOAI = 'B747'
                       GROUP BY lb1.MACB,lb1.NGAYDI)
--Q47. Với mỗi chuyến bay có trên 3 hành khách, cho biết mã chuyến bay và số lượng nhân viên trên chuyến bay đó.	
--Xuất ra mã chuyến bay	và số lượng nhân viên.
SELECT DISTINCT pc.MACB, COUNT(pc.MANV)
FROM PHANCONG pc, NHANVIEN nv, DATCHO dc, LICHBAY lb
WHERE nv.MANV = pc.MANV AND nv.LOAINV = 0 AND pc.MACB = lb.MACB AND pc.NGAYDI = lb.NGAYDI AND dc.NGAYDI = lb.NGAYDI AND dc.MACB = lb.MACB
GROUP BY pc.MACB
HAVING COUNT(dc.MAKH) >= 3

--Q48. Với mỗi loại nhân viên có tổng lương trên 600000, cho biết số lượng nhân	viên trong từng	loại nhân viên đó.
-- Xuất ra loại nhân viên, và số lượng nhân viên tương ứng.
SELECT nv.LOAINV, COUNT(nv.MANV)
FROM NHANVIEN nv
GROUP BY nv.LOAINV
HAVING SUM(nv.LUONG)> 600000
--Q49. Với mỗi chuyến bay có trên 3 nhân viên, cho biết mã chuyến bay và số lượng khách hàng đã đặt chỗ trên chuyến bay đó.
SELECT DISTINCT dc.MACB, (SELECT COUNT(dc1.MAKH)FROM DATCHO dc1 WHERE dc.MACB = dc1.MACB) AS SO_HK
FROM DATCHO dc, PHANCONG pc
WHERE dc.MACB = pc.MACB
GROUP BY dc.MACB
HAVING COUNT(pc.MANV) >= 3

--Q50. Với mỗi loại máy	bay có nhiều hơn một chiếc, cho biết số lượng chuyến bay đã được bố trí bay bằng loại máy bay đó. 
--Xuất ra mã loại và số lượng.
SELECT DISTINCT mb.MALOAI , (SELECT COUNT(mb1.SOHIEU)FROM MAYBAY mb1 WHERE mb1.MALOAI = mb.MALOAI) AS SOLUONG
FROM MAYBAY mb, LICHBAY lb
WHERE mb.MALOAI = lb.MALOAI
GROUP BY mb.MALOAI
HAVING COUNT(mb.SOHIEU) > 1
