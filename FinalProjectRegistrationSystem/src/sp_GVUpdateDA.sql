create proc sp_GVUpdateDA 
@Ma_DA int ,@TenDoAn nvarchar(50),@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int ,@SoLuongGiaoVienDaPhuTrach int 
as begin
begin tran 
	if(not exists (select * from DoAn as DA where DA.MaDoAn=@Ma_DA)) 
	begin
		print 'Khong co do an nay'
rollback
		return
	end
	if( @SoLuongNhomToiDa - (select DA.SoLuongNhomDaDangKy from DoAn As DA where DA.MaDoAn=@Ma_DA ) >= 0 )
	begin
		if( @SoLuongGiaoVienToiDa - (select DA.SoLuongGiaoVienDaPhuTrach from DoAn As DA where DA.MaDoAn=@Ma_DA ) >= 0 )
			update DoAn set TenDoAn=@TenDoAn,DeadLine=@dead_Line,YeuCau=@yeu_cau,MaHT=@MaHT,SoLuongNhomToiDa= @SoLuongNhomToiDa,SoLuongNhomDaDangKy=@SoLuongNhomDaDangKy,SoLuongGiaoVienToiDa=@SoLuongGiaoVienToiDa,SoLuongGiaoVienDaPhuTrach=@SoLuongGiaoVienDaPhuTrach where(DoAn.MaDoAn=@Ma_DA)		
		else print 'Ko update duoc so luong giao vien toi da moi nho hon so luong giao vien da phu trach'
	end
	else print 'Ko update duoc so nhom toi da moi nho hon so luong nhom da dang ky'

	select * from DoAn As DA where DA.MaDoAn=@Ma_DA 
commit
