SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GiaoVien]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GiaoVien](
	[MaGiaoVien] [int] NOT NULL,
	[TenGiaoVien] [nvarchar](50) NULL,
	[DienThoai] [int] NULL,
	[Email] [nvarchar](50) NULL,
 CONSTRAINT [PK_GiaoVien] PRIMARY KEY CLUSTERED 
(
	[MaGiaoVien] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SinhVien]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SinhVien](
	[MaSinhVien] [int] NOT NULL,
	[TenSinhVien] [nvarchar](50) NULL,
	[DienThoai] [int] NULL,
	[Email] [nvarchar](50) NULL,
 CONSTRAINT [PK_SinhVien] PRIMARY KEY CLUSTERED 
(
	[MaSinhVien] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QuiDinh]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[QuiDinh](
	[SoLuongSinhVienToiDaCuaMotNhom] [int] NULL,
	[SoLuongGVToiDaPhuTrachDoAn] [int] NULL,
	[SoLuongDAToiDa1GVPhuTrach] [int] NULL,
	[SoLuongNhomToiDaPhuTrachMotDoAn] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HinhThuc]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HinhThuc](
	[MaHT] [int] NOT NULL,
	[TenHT] [nvarchar](50) NULL,
 CONSTRAINT [PK_HinhThuc] PRIMARY KEY CLUSTERED 
(
	[MaHT] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChiTietDoAn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ChiTietDoAn](
	[MaCTDA] [int] NOT NULL,
	[MaDoAn] [int] NULL,
	[MaGiaoVien] [int] NULL,
 CONSTRAINT [PK_ChiTietDoAn] PRIMARY KEY CLUSTERED 
(
	[MaCTDA] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChiTietNhom]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ChiTietNhom](
	[MaCTNhom] [int] NOT NULL,
	[MaNhom] [int] NULL,
	[MaSinhVien] [int] NULL,
 CONSTRAINT [PK_ChiTietNhom] PRIMARY KEY CLUSTERED 
(
	[MaCTNhom] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Nhom]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Nhom](
	[MaNhom] [int] NOT NULL,
	[TenNhom] [nvarchar](50) NULL,
	[SoLuongSV] [int] NULL,
	[MaNhomTruong] [int] NOT NULL,
 CONSTRAINT [PK_Nhom] PRIMARY KEY CLUSTERED 
(
	[MaNhom] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DangKiDoAn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DangKiDoAn](
	[MaDKDA] [int] NOT NULL,
	[MaDoAn] [int] NULL,
	[MaNhom] [int] NULL,
	[NgayDangKy] [datetime] NULL,
 CONSTRAINT [PK_DangKiDoAn] PRIMARY KEY CLUSTERED 
(
	[MaDKDA] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DoAn]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DoAn](
	[MaDoAn] [int] NOT NULL,
	[TenDoAn] [nvarchar](50) NULL,
	[DeadLine] [datetime] NULL,
	[YeuCau] [nvarchar](500) NULL,
	[MaHT] [int] NULL,
	[SoLuongNhomToiDa] [int] NULL,
	[SoLuongNhomDaDangKy] [int] NULL,
	[SoLuongGiaoVienToiDa] [int] NULL,
	[SoLuongGiaoVienDaPhuTrach] [int] NULL,
 CONSTRAINT [PK_DoAn] PRIMARY KEY CLUSTERED 
(
	[MaDoAn] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DangKyDA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[sp_DangKyDA]
@Ma_DA int ,@Ma_Nhom int ,@NgayDangKy datetime
as 
begin 
begin tran
set tran isolation level READ UNCOMMITTED

--buoc 1 : kiem tra do an co ton tai ko
if(not exists (select * from DoAn as DA where DA.MaDoAn=@Ma_DA))
begin	
	print N''Do an ko ton tai''
	return
end
--waitfor delay ''00:00:30''
-- Neu Do an ton tai
--Kiem tra do an nay cho con duoc phep dang ky khong
if( (select DA.SoLuongNhomToiDa - DA.SoLuongNhomDaDangKy from DoAn As DA where DA.MaDoAn=@Ma_DA )<1 )
	print N''Do an da du nhom dang ky''
	rollback tran
	return
--buoc 2: Kiem tra Nhom co ton tai ko
if(not exists (select * from Nhom  as N where N.MaNhom=@Ma_Nhom))
	begin
	print N''Nhom nay chua duoc dang ky''
	return	
end
--Neu nhom da duoc dang ky
--buoc 3: Tien hanh dang ky do an
declare @Ma_DK as int 
set @Ma_DK=1
while(exists (select * from DangKyDoAn as DKDA where DKDA.MaDKDA=@Ma_DK))
	set @Ma_DK=@Ma_DK+1
insert into DangKyDoAn values(@Ma_DK,@Ma_DA,@Ma_Nhom,@NgayDangKy)
commit 
end' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DoAn]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  proc [dbo].[sp_DoAn] 
@TenDoAn smallint,@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int , @SoLuongGiaoVienDaPhuTrach int 
as
begin	
declare @Ma_DA int 
set @Ma_DA=1
while (exists (select * from DoAn DA where DA.MaDoAn = @Ma_DA))--Phat sinh ma do an
set @Ma_DA=@Ma_DA+1
insert into DoAn values(@Ma_DA,@TenDoAn,@dead_Line,@yeu_cau,@MaHT,@SoLuongNhomToiDa,@SoLuongNhomDaDangKy,@SoLuongGiaoVienToiDa,@SoLuongGiaoVienDaPhuTrach)
end' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateDA]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc [dbo].[sp_UpdateDA] 
@Ma_DA int ,@TenDoAn nvarchar(50),@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int ,@SoLuongGiaoVienDaPhuTrach int 
as begin
begin tran 
--set isolation level read UNCOMMITTED
--select * from DoAn 	waitfor delay ''00:00:30''	
update DoAn set TenDoAn=@TenDoAn,DeadLine=@dead_Line,YeuCau=@yeu_cau,MaHT=@MaHT,@SoLuongNhomToiDa= @SoLuongNhomToiDa,SoLuongNhomDaDangKy=@SoLuongNhomDaDangKy,SoLuongGiaoVienToiDa=@SoLuongGiaoVienToiDa,@SoLuongGiaoVienDaPhuTrach=SoLuongGiaoVienDaPhuTrach where(DoAn.MaDoAn=@Ma_DA)		
waitfor delay ''00:00:30''
rollback tran 
end ' 
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChiTietDoAn_DoAn]') AND parent_object_id = OBJECT_ID(N'[dbo].[ChiTietDoAn]'))
ALTER TABLE [dbo].[ChiTietDoAn]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietDoAn_DoAn] FOREIGN KEY([MaDoAn])
REFERENCES [dbo].[DoAn] ([MaDoAn])
GO
ALTER TABLE [dbo].[ChiTietDoAn] CHECK CONSTRAINT [FK_ChiTietDoAn_DoAn]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChiTietDoAn_GiaoVien]') AND parent_object_id = OBJECT_ID(N'[dbo].[ChiTietDoAn]'))
ALTER TABLE [dbo].[ChiTietDoAn]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietDoAn_GiaoVien] FOREIGN KEY([MaGiaoVien])
REFERENCES [dbo].[GiaoVien] ([MaGiaoVien])
GO
ALTER TABLE [dbo].[ChiTietDoAn] CHECK CONSTRAINT [FK_ChiTietDoAn_GiaoVien]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChiTietNhom_Nhom]') AND parent_object_id = OBJECT_ID(N'[dbo].[ChiTietNhom]'))
ALTER TABLE [dbo].[ChiTietNhom]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietNhom_Nhom] FOREIGN KEY([MaNhom])
REFERENCES [dbo].[Nhom] ([MaNhom])
GO
ALTER TABLE [dbo].[ChiTietNhom] CHECK CONSTRAINT [FK_ChiTietNhom_Nhom]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ChiTietNhom_SinhVien]') AND parent_object_id = OBJECT_ID(N'[dbo].[ChiTietNhom]'))
ALTER TABLE [dbo].[ChiTietNhom]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietNhom_SinhVien] FOREIGN KEY([MaSinhVien])
REFERENCES [dbo].[SinhVien] ([MaSinhVien])
GO
ALTER TABLE [dbo].[ChiTietNhom] CHECK CONSTRAINT [FK_ChiTietNhom_SinhVien]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Nhom_SinhVien]') AND parent_object_id = OBJECT_ID(N'[dbo].[Nhom]'))
ALTER TABLE [dbo].[Nhom]  WITH CHECK ADD  CONSTRAINT [FK_Nhom_SinhVien] FOREIGN KEY([MaNhomTruong])
REFERENCES [dbo].[SinhVien] ([MaSinhVien])
GO
ALTER TABLE [dbo].[Nhom] CHECK CONSTRAINT [FK_Nhom_SinhVien]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DangKiDoAn_DoAn]') AND parent_object_id = OBJECT_ID(N'[dbo].[DangKiDoAn]'))
ALTER TABLE [dbo].[DangKiDoAn]  WITH CHECK ADD  CONSTRAINT [FK_DangKiDoAn_DoAn] FOREIGN KEY([MaDoAn])
REFERENCES [dbo].[DoAn] ([MaDoAn])
GO
ALTER TABLE [dbo].[DangKiDoAn] CHECK CONSTRAINT [FK_DangKiDoAn_DoAn]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DangKiDoAn_Nhom]') AND parent_object_id = OBJECT_ID(N'[dbo].[DangKiDoAn]'))
ALTER TABLE [dbo].[DangKiDoAn]  WITH CHECK ADD  CONSTRAINT [FK_DangKiDoAn_Nhom] FOREIGN KEY([MaNhom])
REFERENCES [dbo].[Nhom] ([MaNhom])
GO
ALTER TABLE [dbo].[DangKiDoAn] CHECK CONSTRAINT [FK_DangKiDoAn_Nhom]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DoAn_HinhThuc]') AND parent_object_id = OBJECT_ID(N'[dbo].[DoAn]'))
ALTER TABLE [dbo].[DoAn]  WITH CHECK ADD  CONSTRAINT [FK_DoAn_HinhThuc] FOREIGN KEY([MaHT])
REFERENCES [dbo].[HinhThuc] ([MaHT])
GO
ALTER TABLE [dbo].[DoAn] CHECK CONSTRAINT [FK_DoAn_HinhThuc]
