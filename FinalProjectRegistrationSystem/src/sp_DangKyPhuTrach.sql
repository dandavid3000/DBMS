create proc sp_DangKyPhuTrach
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
