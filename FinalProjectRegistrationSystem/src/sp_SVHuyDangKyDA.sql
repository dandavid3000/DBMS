create proc sp_SVHuyDangKyDA
@Ma_DA int ,@Ma_Nhom int 
as 
begin tran
begin 

	 --buoc 1 : Kiem tra xem nhom co dang ky do an hay chua
	 if(not exists (select * from DangKiDoAn where DangKiDoAn.MaDoAn=@Ma_DA and DangKiDoAn.MaNhom=@Ma_Nhom))
	 begin 
		  print N'Nhóm chưa đăng ký đồ án này.'
		  rollback
		  return
	 end

	 -- Neu Do an ton tai
	  waitfor delay '00:00:10'

	-- Buoc 2 : Phải trước deadline mới đc hủy đăng ký
		
	select @NgayDangKy = Deadline from DoAn as DA where DA.MaDoAn=@Ma_DA

		if datediff(dd, @NgayDangKy, getdate()) <0
		begin
			print N'Đã hết hạn đăng ký đồ án.'
			rollback
			return	
		end

	
	--buoc 3: Tien hanh huy dang ky do an
	 update DoAn  set DoAn.SoLuongNhomDaDangKy=DoAn.SoLuongNhomDaDangKy-1 where DoAn.MaDoAn = @Ma_DA
	 delete from DangKiDoAn where MaDoAn = @Ma_DA and MaNhom=@Ma_Nhom
 
end
commit
