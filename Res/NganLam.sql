alter proc sp_DangKyPhuTrach
@Ma_DA int ,@Ma_GV int
as 
begin 
begin tran
	set tran isolation level REPEATABLE READ

	--buoc 1 : kiem tra do an co ton tai ko
	if(not exists (select * from DoAn as DA where DA.MaDoAn=@Ma_DA))
	begin	
		print N'Do an ko ton tai'
		rollback
		return
	end

	-- Neu Do an ton tai
	--Kiem tra do an nay cho con duoc phep dang ky phu trach khong
	if( (select DA.SoLuongGiaoVienToiDa - DA.SoLuongGiaoVienDaPhuTrach from DoAn As DA where DA.MaDoAn=@Ma_DA ) < 1 )
	begin
		print N'Do an da du giao vien phu trach.'
		rollback 
		return
	end
	--return
--buoc 2: Kiem tra giao vien co ton tai ko
	if(not exists (select * from GiaoVien  as N where N.MaGiaoVien=@Ma_GV))
		begin
			print N'Giao vien nay khong ton tai.'
			rollback
			return	
		end

	--Neu giao vien ton tai
  waitfor delay '00:00:10'

--buoc 3: Tien hanh dang ky phu trach do an
	declare @Ma_DK as int 
	set @Ma_DK=1
	while(exists (select * from ChiTietDoAn as CTDA where CTDA.MaCTDA=@Ma_DK))
		set @Ma_DK=@Ma_DK+1
if(not exists (select * from ChiTietDoAn as CTDA where CTDA.MaDoAn=@Ma_DA and CTDA.MaGiaoVien=@Ma_GV))
begin
	insert into ChiTietDoAn values(@Ma_DK,@Ma_DA,@Ma_GV)
	update DoAn  set DoAn.SoLuongGiaoVienDaPhuTrach=DoAn.SoLuongGiaoVienDaPhuTrach+1 where DoAn.MaDoAn=@Ma_DA
end
commit 

end
go
exec sp_DangKyPhuTrach 1,2


alter proc sp_HuyDoAn 
@Ma_DA int 
as begin 
set tran isolation level SERIALIZABLE
	if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA)) 
	begin 
		delete from DangKiDoAn where DangKiDoAn.MaDoAn=@Ma_DA 
		
		delete from ChiTietDoAn where ChiTietDoAn.MaDoAn=@Ma_DA
		delete from DoAn  where DoAn.MaDoAn = @Ma_DA 
	end 
end

exec sp_HuyDoAn 1


alter proc sp_CapNhatDoAn
@Ma_DA int, @Ten_DA nvarchar,@Deadline datetime, @YC nvarchar,@MaHT int, @SLNTD int,@SLNDK int,@SLGVTD int,@SLGVPT int
as begin
if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA)) 
waitfor delay '00:00:10'
	begin 
		update DoAn  set DoAn.TenDoAn=@Ten_DA, DoAn.DeadLine=@Deadline, DoAn.YeuCau=@YC, DoAn.MaHT=@MaHT, DoAn.SoLuongNhomToiDa=@SLNTD, DoAn.SoLuongNhomDaDangKy=@SLNDK, DoAn.SoLuongGiaoVienToiDa=@SLGVTD, DoAn.SoLuongGiaoVienDaPhuTrach=@SLGVPT 
		where DoAn.MaDoAn=@Ma_DA
		
	end 
end

exec sp_CapNhatDoAn 1,N'Store procedure','8/20/2010',N'nộp đúng quy định',1,2,1,2,1





----------Câu 7
alter proc sp_HuyDangKyDA
@Ma_DA int ,@Ma_Nhom int 
as 
begin tran
begin 

	
set tran isolation level REPEATABLE READ
	--buoc 1 : kiem tra do an co ton tai ko
	if(not exists (select * from DangKiDoAn as DKDA where DKDA.MaDoAn=@Ma_DA and DKDA.MaNhom=@Ma_Nhom))
	begin	
		print N'Nhóm chưa đăng ký đồ án này.'
		rollback
		return
	end
	--waitfor delay '00:00:30'
	-- Neu Do an ton tai
	waitfor delay '00:00:10'
	
	

--buoc 2: Tien hanh huy dang ky do an
	delete from DangKiDoAn where MaDoAn = @Ma_DA and MaNhom=@Ma_Nhom
	update DoAn  set DoAn.SoLuongNhomDaDangKy=DoAn.SoLuongNhomDaDangKy-1 where DoAn.MaDoAn = @Ma_DA


end
commit 
---Giáo viên xem thông tin đăng ký đồ án
alter proc sp_XemThongTinDangKyDoAn
@Ma_DA int
as 
begin tran
begin 

	--set tran isolation level READ COMMITTED
	Select * from DangKiDoAn where MaDoAn=@Ma_DA

end
commit
exec sp_HuyDangKyDA 1,1
exec sp_XemThongTinDangKyDoAn 1