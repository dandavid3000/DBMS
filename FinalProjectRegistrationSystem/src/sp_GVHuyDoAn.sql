create proc sp_GVHuyDoAn 
@Ma_DA int 
as begin
	begin tran
		if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA))
			begin
				delete from ChiTietDoAn where MaDoAn=@Ma_DA
				delete from DangKiDoAn where MaDoAn=@Ma_DA
				delete from DoAn where MaDoAn = @Ma_DA
			end
	
	commit tran
end
