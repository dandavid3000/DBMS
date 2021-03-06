ago
alter proc sp_GVUpdateDA 
@Ma_DA int ,@TenDoAn nvarchar(50),@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int ,@SoLuongGiaoVienDaPhuTrach int 
as begin
begin tran 
	--set tran isolation level read UNCOMMITTED
	--select * from DoAn 	waitfor delay '00:00:30'
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
end   go  alter proc sp_SVDangKyDA
@Ma_DA int ,@Ma_Nhom int ,@NgayDangKy datetime
as 
begin tran
begin 

	--set tran isolation level READ UNCOMMITTED
	--buoc 1 : kiem tra do an co ton tai ko
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
	--waitfor delay '00:00:30'
	-- Neu Do an ton tai
	--Kiem tra do an nay cho con duoc phep dang ky khong
--	if (datediff(dd,@NgayDangKy, getdate()) <0)
--	begin
--		print N'Het thoi gian dang ky'
--		rollback 
--		return
--	end
	if( (select DA.SoLuongNhomToiDa - DA.SoLuongNhomDaDangKy from DoAn As DA where DA.MaDoAn=@Ma_DA ) < 1 )
	begin
		print N'Do an da du nhom dang ky'
		rollback 
		return
	end
	--return
--buoc 2: Kiem tra Nhom co ton tai ko
	if(not exists (select * from Nhom  as N where N.MaNhom=@Ma_Nhom))
		begin
			print N'Nhom nay chua duoc dang ky'
			rollback
			return	
		end
	
	waitfor delay '00:00:10'
	--Neu nhom da duoc dang ky
--buoc 3: Tien hanh dang ky do an
	declare @Ma_DK as int 
	set @Ma_DK=1
	while(exists (select * from DangKiDoAn as DKDA where DKDA.MaDKDA=@Ma_DK))
		set @Ma_DK=@Ma_DK+1

	insert into DangKiDoAn values(@Ma_DK,@Ma_DA,@Ma_Nhom,@NgayDangKy)
	update DoAn  set DoAn.SoLuongNhomDaDangKy=DoAn.SoLuongNhomDaDangKy+1 where DoAn.MaDoAn = @Ma_DA
 
end
commit

exec sp_GVUpdateDA 1,'abc','2/2/2010','abc',1,2,1,4,1
exec sp_SVDangKyDA 1,1,'2/02/2010'
-- Them dieu kien kiem tra dang ky DA, neu da dang ky roi ko cho dang ky nua

--------------------------------------- Cau 1

alter proc sp_GVHuyDoAn 
@Ma_DA int 
as begin
	begin tran
	--set tran isolation level READ UNCOMMITTED
		if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA))
			begin
				delete from ChiTietDoAn where MaDoAn=@Ma_DA
				delete from DangKiDoAn where MaDoAn=@Ma_DA
				delete from DoAn where MaDoAn = @Ma_DA
			end
	
	commit tran
end

alter proc sp_SVDocDoAn
@Ma_DA int
as begin
begin tran
--set tran isolation level REPEATABLE READ
	if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA))
	begin
		print 'Do an co ton tai, xin doi trong giay lat'
		waitfor delay '00:00:05'
		select DA.SoLuongNhomToiDa, DA.SoLuongNhomDaDangKy from DoAn DA where DA.MaDoAn = @Ma_DA
	end
	else print 'Do an ko ton tai'
commit tran
end

exec sp_SVDocDoAn 1
exec sp_GVHuyDoAn 1


-- Khi SV doc do an len thi thay rang do an co ton tai, cho 10s, sau do in ra so nhom da dang ky thi ko thay du lieu
-- vi da bi GV chen ngan vao xoa mat


--------------------------------------- Cau 3

alter proc sp_GVDocSuaDoAn
@Ma_DA int ,@TenDoAn nvarchar(50),@dead_Line datetime , @yeu_cau nvarchar(50),@MaHT int,@SoLuongNhomToiDa int,@SoLuongNhomDaDangKy int,@SoLuongGiaoVienToiDa int ,@SoLuongGiaoVienDaPhuTrach int 
as begin
begin tran
	--set tran isolation level REPEATABLE READ
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

--Giao vien 1 doc thong tin sau do update và kiem tra lai thi thay du lieu minh thay doi bi sai do GV 2 da doi du lieu
exec sp_GVDocSuaDoAn 1,'abc','2/2/2010','abc',1,2,1,5,4

--Giao vien 2 doc thong tin sau do update
exec sp_GVDocSuaDoAn 1,'abcsctẽts','2/2/2010','abc',1,2,1,5,4

--ket qua thi giao vien 1 bi mat du lieu cap nhat

--------------------------------------- Cau 4 dang nghien cuu

alter proc sp_KiemTraDoAn 
@Ma_DA int 
as begin
begin tran
	select * from DoAn DA where DA.MaDoAn =@Ma_DA
	if( (select DA.SoLuongNhomToiDa - DA.SoLuongNhomDaDangKy from DoAn As DA where DA.MaDoAn=@Ma_DA ) < 1 )
		begin
			print 'Do An da du nguoi dang ky, he thong se tu tim do an con chua du nguoi'
			waitfor delay '00:00:10'
			select * from DoAn
			
		end
commit	
end

alter proc sp_SinhVienHuyDangKyDoAn
@Ma_DA int, @Ma_Nhom int
as begin
begin tran
	set tran isolation level READ UNCOMMITTED
	if(exists (select * from DoAn DA where DA.MaDoAn=@Ma_DA))
		begin
		    delete from DangKiDoAn where MaNhom=@Ma_Nhom
			update DoAn set SoLuongNhomDaDangKy = SoLuongNhomDaDangKy -1 where MaDoAn=@Ma_DA
		end
commit
end

exec sp_KiemTraDoAn 1
exec sp_SinhVienHuyDangKyDoAn 1,1


--------------------------------------- Cau 5
--
--alter proc sp_SVDocVaDangKyDA
--@Ma_DA int ,@Ma_Nhom int ,@NgayDangKy datetime
--as begin
--	exec sp_SVDocDoAn @Ma_DA
--	exec sp_DangKyDA @Ma_DA, @MA_Nhom, @NgayDangKy
--end
--
--
--
----SV 1 doc thong tin DA thay con cho de dang ky nen da cho 10s sau do dang ky do an
--exec sp_SVDOcVaDangKyDA 1,1,'4/02/2010'
--
----SV 2 nhay vao dang ky truoc
--exec sp_DangKyDA 1,2,'4/02/2010'

--------------------------------------- Cau 4

exec sp_DangKyDA 1,2,'4/02/2010'
exec sp_UpdateDA 1,'abc','2/2/2010','abc',1,1,1,4,1

------------------------------Câu 7
alter proc sp_SVHuyDangKyDA
@Ma_DA int ,@Ma_Nhom int 
as 
begin tran
begin 

	 --set tran isolation level REPEATABLE READ

	 --buoc 1 : kiem tra do an co ton tai ko
	 if(not exists (select * from DangKiDoAn with (XLOCK) where DangKiDoAn.MaDoAn=@Ma_DA and DangKiDoAn.MaNhom=@Ma_Nhom))
	 begin 
		  print N'Nhóm chưa đăng ký đồ án này.'
		  rollback
		  return
	 end

	
	 --waitfor delay '00:00:30'
	 -- Neu Do an ton tai
	  waitfor delay '00:00:10'
	 
	--Buoc 2 : Kiem tra xem co dang ky hay chua

	 -- Buoc 3 : Phải trước deadline óới đc hủy đăng ký
	
	--buoc 4: Tien hanh huy dang ky do an
	 update DoAn  set DoAn.SoLuongNhomDaDangKy=DoAn.SoLuongNhomDaDangKy-1 where DoAn.MaDoAn = @Ma_DA
	 delete from DangKiDoAn where MaDoAn = @Ma_DA and MaNhom=@Ma_Nhom
 
end
commit 

---Giáo viên xem thông tin đăng ký đồ án
alter proc sp_XemThongTinDangKyDoAn
@Ma_DA int
as 
begin tran
begin 
	Select * from DangKiDoAn where MaDoAn=@Ma_DA
end
commit

exec sp_HuyDangKyDA 1,1
exec sp_XemThongTinDangKyDoAn 1