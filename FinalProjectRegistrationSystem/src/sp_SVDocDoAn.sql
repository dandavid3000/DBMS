alter proc sp_SVDocDoAn
@Ma_DA int
as begin
begin tran

	if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA))
	begin
		print 'Do an co ton tai, xin doi trong giay lat'
		waitfor delay '00:00:05'
		select DA.SoLuongNhomToiDa, DA.SoLuongNhomDaDangKy from DoAn DA where DA.MaDoAn = @Ma_DA
	end
	else print 'Do an ko ton tai'
commit tran
end
