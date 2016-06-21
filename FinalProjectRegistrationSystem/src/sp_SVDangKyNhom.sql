create proc sp_SVDangKyNhom
@TenNhom nvarchar(50),@SoLuongSV int,@MaNhomTruong int
as begin
begin tran 
	--Buoc 1: Kiểm tra xem nhóm ðã ðãng ký chýa
	if(exists (select * from Nhom as N where N.TenNhom=@TenNhom)) 
	begin
		print N'Nhóm ðã ðãng ký.'
		rollback
		return
	end
	--Buoc 2: Kiểm tra xem mã nhóm trýởng có tồn tại không
	if(not exists (select * from SinhVien as SV where SV.MaSinhVien=@MaNhomTruong))
	begin
		print N'Nhóm trưởng này không tồn tại.'
		rollback
		return
	end
	--Buoc 3: Ðãng ký nhóm mới
	declare @Ma_Nhom as int 
	set @Ma_Nhom=1
	while(exists (select * from Nhom as N where N.MaNhom=@Ma_Nhom))
		set @Ma_Nhom=@Ma_Nhom+1

	Insert into Nhom values (@Ma_Nhom,@TenNhom,@SoLuongSV,@MaNhomTruong)
commit
end
