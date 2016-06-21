create proc sp_SVDangKyDA
@Ma_DA int ,@Ma_Nhom int ,@NgayDangKy datetime
as 
begin tran
begin 

	if(not exists (select * from DoAn where DoAn.MaDoAn=@Ma_DA))
	begin	
		print N'Do an ko ton tai'
		rollback
		return
	end
	
	if(exists (select * from DangKiDoAn where DangKiDoAn.MaNhom=@Ma_Nhom))
	begin	
		print N'Nhom da dang ky roi'
		rollback
		return
	end
	
	if( (select DA.SoLuongNhomToiDa - DA.SoLuongNhomDaDangKy from DoAn As DA where DA.MaDoAn=@Ma_DA ) < 1 )
	begin
		print N'Do an da du nhom dang ky'
		rollback 
		return
	end

--buoc 2: Kiem tra Nhom co ton tai ko
	if(not exists (select * from Nhom  as N where N.MaNhom=@Ma_Nhom))
		begin
			print N'Nhom nay chua duoc dang ky'
			rollback
			return	
		end

--buoc 3: Kiem tra xem da deadline chua.
		
	select @NgayDangKy = Deadline from DoAn as DA where DA.MaDoAn=@Ma_DA

		if datediff(dd, @NgayDangKy, getdate()) <0
		begin
			print N'Đã hết hạn đăng ký đồ án.'
			rollback
			return	
		end


end
	waitfor delay '00:00:10'
	--Neu nhom da duoc dang ky
--buoc 4: Tien hanh dang ky do an
	declare @Ma_DK as int 
	set @Ma_DK=1
	while(exists (select * from DangKiDoAn as DKDA where DKDA.MaDKDA=@Ma_DK))
		set @Ma_DK=@Ma_DK+1

	insert into DangKiDoAn values(@Ma_DK,@Ma_DA,@Ma_Nhom,@NgayDangKy)
	update DoAn  set DoAn.SoLuongNhomDaDangKy=DoAn.SoLuongNhomDaDangKy+1 where DoAn.MaDoAn = @Ma_DA
 
end
commit
