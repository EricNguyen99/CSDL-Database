USE [QLLopHoc]
GO
/****** Object:  Table [dbo].[GIAOVIEN]    Script Date: 3/11/2019 9:12:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN](
	[MaGV] [char](10) NOT NULL,
	[HoTen] [nvarchar](40) NULL,
	[GioiTinh] [nchar](3) NULL,
	[NgaySinh] [date] NULL,
	[DiaChi] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOCSINH]    Script Date: 3/11/2019 9:12:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOCSINH](
	[MaHs] [char](10) NOT NULL,
	[HoTen] [nvarchar](40) NULL,
	[GioiTinh] [nchar](3) NULL,
	[NgaySinh] [date] NULL,
	[DiaChi] [nvarchar](100) NULL,
	[MaLop] [char](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHs] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOPHOC]    Script Date: 3/11/2019 9:12:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOPHOC](
	[MaLop] [char](10) NOT NULL,
	[TenLop] [nvarchar](40) NULL,
	[Nam] [char](4) NULL,
	[GVCN] [char](10) NULL,
	[LopTruong] [char](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GIAOVIEN] ([MaGV], [HoTen], [GioiTinh], [NgaySinh], [DiaChi]) VALUES (N'GV01      ', N'Trần Bạch Tuyết', N'Nữ ', CAST(N'1980-05-20' AS Date), N'127 Hùng Vương, Q. Thủ Đức, TP HCM')
INSERT [dbo].[GIAOVIEN] ([MaGV], [HoTen], [GioiTinh], [NgaySinh], [DiaChi]) VALUES (N'GV02      ', N'Nguyễn Lâm Trung', N'Nam', CAST(N'1978-07-01' AS Date), N'234 3/2, TP Biên Hòa')
INSERT [dbo].[GIAOVIEN] ([MaGV], [HoTen], [GioiTinh], [NgaySinh], [DiaChi]) VALUES (N'GV03      ', N'Hoàng Trung Hiếu', N'Nam', CAST(N'1986-03-29' AS Date), N'22/11 Lý Thường Kiệt, Q.1, TP HCM')
INSERT [dbo].[GIAOVIEN] ([MaGV], [HoTen], [GioiTinh], [NgaySinh], [DiaChi]) VALUES (N'GV04      ', N'Trần Hoàng Nhật Nam', N'Nam', CAST(N'1972-05-05' AS Date), N'234 Trấn Não, Q.2, TP HCM')
INSERT [dbo].[GIAOVIEN] ([MaGV], [HoTen], [GioiTinh], [NgaySinh], [DiaChi]) VALUES (N'GV05      ', N'Phạm Thị Thanh Bình', N'Nữ ', CAST(N'1985-01-19' AS Date), N'22 Hùng Vương, Q.5, TP HCM')
INSERT [dbo].[HOCSINH] ([MaHs], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [MaLop]) VALUES (N'1412558   ', N'Phạm Quốc Toàn', N'Nam', CAST(N'1996-07-04' AS Date), N'DC_1', NULL)
INSERT [dbo].[HOCSINH] ([MaHs], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [MaLop]) VALUES (N'1512010   ', N'Nguyễn Bình An', N'Nam', CAST(N'1996-07-05' AS Date), N'DC_2', NULL)
INSERT [dbo].[HOCSINH] ([MaHs], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [MaLop]) VALUES (N'1512219   ', N'Phạm Minh Hùng', N'Nam', CAST(N'1996-07-06' AS Date), N'DC_3', NULL)
INSERT [dbo].[HOCSINH] ([MaHs], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [MaLop]) VALUES (N'1512334   ', N'Lê Văn Nam', N'Nam', CAST(N'1996-07-07' AS Date), N'DC_4', NULL)
INSERT [dbo].[HOCSINH] ([MaHs], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [MaLop]) VALUES (N'1512430   ', N'Lê Văn Quang', N'Nam', CAST(N'1996-07-08' AS Date), N'DC_5', NULL)
INSERT [dbo].[LOPHOC] ([MaLop], [TenLop], [Nam], [GVCN], [LopTruong]) VALUES (N'LOP01     ', N'17CTT1', N'1996', N'GV01      ', N'1412558   ')
INSERT [dbo].[LOPHOC] ([MaLop], [TenLop], [Nam], [GVCN], [LopTruong]) VALUES (N'LOP02     ', N'17CTT2', N'1996', N'GV02      ', N'1512010   ')
INSERT [dbo].[LOPHOC] ([MaLop], [TenLop], [Nam], [GVCN], [LopTruong]) VALUES (N'LOP03     ', N'17CTT3', N'1996', N'GV03      ', N'1512219   ')
INSERT [dbo].[LOPHOC] ([MaLop], [TenLop], [Nam], [GVCN], [LopTruong]) VALUES (N'LOP04     ', N'17CTT4', N'1996', N'GV04      ', N'1412558   ')
INSERT [dbo].[LOPHOC] ([MaLop], [TenLop], [Nam], [GVCN], [LopTruong]) VALUES (N'LOP05     ', N'17CTT5', N'1996', N'GV05      ', N'1412558   ')
ALTER TABLE [dbo].[HOCSINH]  WITH CHECK ADD  CONSTRAINT [FK_HOCSINH_LOPHOC] FOREIGN KEY([MaLop])
REFERENCES [dbo].[LOPHOC] ([MaLop])
GO
ALTER TABLE [dbo].[HOCSINH] CHECK CONSTRAINT [FK_HOCSINH_LOPHOC]
GO
ALTER TABLE [dbo].[LOPHOC]  WITH CHECK ADD  CONSTRAINT [FK_LOPHOC_GIAOVIEN] FOREIGN KEY([GVCN])
REFERENCES [dbo].[GIAOVIEN] ([MaGV])
GO
ALTER TABLE [dbo].[LOPHOC] CHECK CONSTRAINT [FK_LOPHOC_GIAOVIEN]
GO
ALTER TABLE [dbo].[LOPHOC]  WITH CHECK ADD  CONSTRAINT [FK_LOPHOC_HOCSINH] FOREIGN KEY([LopTruong])
REFERENCES [dbo].[HOCSINH] ([MaHs])
GO
ALTER TABLE [dbo].[LOPHOC] CHECK CONSTRAINT [FK_LOPHOC_HOCSINH]
GO
