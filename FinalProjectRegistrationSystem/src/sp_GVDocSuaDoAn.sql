create proc sp_GVDocSuaDoAn
@Ma_DA int ,@TenDoAn nvarchar(50),@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int ,@SoLuongGiaoVienDaPhuTrach int 
as begin
begin tran
	if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA))
	begin	
		select* from DoAn DA where DA.MaDoAn = @Ma_DA
		waitfor delay '00:00:10'
	
		if( @SoLuongNhomToiDa - (select DA.SoLuongNhomDaDangKy from DoAn As DA where DA.MaDoAn=@Ma_DA ) >= 0 )
			begin
				if( @SoLuongGiaoVienToiDa - (select DA.SoLuongGiaoVienDaPhuTrach from DoAn As DA where DA.MaDoAn=@Ma_DA ) >= 0 )
					update DoAn set TenDoAn=@TenDoAn,DeadLine=@dead_Line,YeuCau=@yeu_cau,MaHT=@MaHT,SoLuongNhomToiDa= @SoLuongNhomToiDa,SoLuongNhomDaDangKy=@SoLuongNhomDaDangKy,SoLuongGiaoVienToiDa=@SoLuongGiaoVienToiDa,SoLuongGiaoVienDaPhuTrach=@SoLuongGiaoVienDaPhuTrach where(DoAn.MaDoAn=@Ma_DA)		
				else print 'Ko update duoc so luong giao vien toi da moi nho hon so luong giao vien da phu trach'
			end
		else print 'Ko update duoc so nhom toi da moi nho hon so luong nhom da dang ky'
	end
	select* from DoAn DA where DA.MaDoAn = @Ma_DA

commit
end
