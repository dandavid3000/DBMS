create proc sp_GVThemDoAn
TenDoAn nvarchar(50),@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int ,@SoLuongGiaoVienDaPhuTrach int 
as begin
begin tran 
	--Buoc 1: Kiểm tra ðồ án ðã tồn tại hay chýa
	if(exists (select * from DoAn as DA where DA.TenDoAn=@TenDoAn)) 
	begin
		print N'Ðồ án ðã tồn tại.'
		rollback
		return
	end
	--Buoc 2: Kiểm tra giáo viên ðã nhập ðúng dữ liệu hay chýa
	if( (@SoLuongNhomToiDa - @SoLuongNhomDaDangKy < 0) and (@SoLuongGiaoVienToiDa - @SoLuongGiaoVienDaPhuTrach <0) )
	begin
		print N'Số lượng tối đa phải lớn hơn số lượng đăng ký.'
		rollback
		return
	end
	--Buoc 3: Thêm một ðồ án mới
	declare @Ma_DA as int
	set @Ma_DA=1
	while(exists (select * from DoAn as DA where DA.MaDoAn=@Ma_DA))
		set @Ma_DA=@Ma_DA+1

	Insert into DoAn values (@Ma_DA,@TenDoAn,@dead_Line,@yeu_cau,@MaHT,@SoLuongNhomToiDa,@SoLuongNhomDaDangKy,@SoLuongGiaoVienToiDa,@SoLuongGiaoVienDaPhuTrach)
commit
end
