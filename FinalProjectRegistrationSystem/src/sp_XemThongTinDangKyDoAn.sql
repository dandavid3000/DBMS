create proc sp_XemThongTinDangKyDoAn
@Ma_DA int
as 
begin tran
begin 
	Select * from DangKiDoAn where MaDoAn=@Ma_DA
end
commit
