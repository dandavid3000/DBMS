--Cau 4.1 : xem thong tin doc gia
alter proc sp_ThongTinDocGia 
@ma_docgia smallint
as
begin
	if(exists (select * from docgia dg where dg.ma_docgia = @ma_docgia))
	begin	
		if(exists (select * from nguoilon nl where nl.ma_docgia = @ma_docgia))
		begin
			select * from docgia dg, nguoilon nl
			where nl.ma_docgia = dg.ma_docgia
			and nl.ma_docgia = @ma_docgia
		end
		if(exists (select * from treem te where te.ma_docgia = @ma_docgia))
		begin
			select * from docgia dg, treem te
			where te.ma_docgia = dg.ma_docgia
			and te.ma_docgia = @ma_docgia
		end
	end
	else
		print "Ma doc gia nay khong ton tai"
end
go

--Cau 4.2: thong tin dau sach
create proc sp_ThongTinDauSach @ISBN int
as
begin
	select ds.isbn, ts.ma_tuasach,ts.tuasach,ts.tomtat,count(*) as TongCong
	from dausach ds, tuasach ts, cuonsach cs
	where ds.isbn = @isbn and ds.isbn = cs.isbn and cs.tinhtrang = 'Y'
	and ts.ma_tuasach = ds.ma_tuasach
	group by ds.isbn, ts.ma_tuasach,ts.tuasach,ts.tomtat
end
go


--Cau 4.3 : liet ke nhung doc gia nguoi lon dang muon sach
create proc sp_thongtinnguoilondangmuon 
as
begin
	select * from nguoilon nl, muon m
	where nl.ma_docgia = m.ma_docgia
	and exists(select * from docgia dg
		where dg.ma_docgia = nl.ma_docgia) 
end
go


--Cau 4.4: liet ke nhung doc gia nguoi lon dang muon sach
create proc sp_ThongTinNguoiLonQuaHan
as
begin
	select * from nguoilon nl, muon m
		where nl.ma_docgia = m.ma_docgia
		and datediff(day,m.ngay_muon,getdate())>14
		and exists(select * from docgia dg
			where dg.ma_docgia = nl.ma_docgia)  
end
go

--Cau 4.5 liet ke nhung doc gia dang muon sach co tre em cung dang muon sach
create proc sp_DocGiaCoTreEmMuon
as
begin
	select * from nguoilon nl, muon m
	where nl.ma_docgia = m.ma_docgia
	and exists(select * from docgia dg
		where dg.ma_docgia = nl.ma_docgia)
	and exists(select * from treem te,muon m1
		where te.ma_docgia = m1.ma_docgia
		and te.ma_docgia_nguoilon = nl.ma_docgia
		and exists (select * from docgia dg1
			where dg1.ma_docgia = te.ma_docgia)) 
end
go

--Cau 4.6 cap nhat trang tahi cua dau sach
create proc sp_CapNhatTrangThaiDauSach
@isbn int
as 
begin
	declare @soluong int
	set @soluong = (select count(*) 
		from dausach ds,cuonsach cs,tuasach ts
		where ds.isbn = @isbn
		and ds.ma_tuasach = ts.ma_tuasach
		and ds.isbn = cs.isbn
		and cs.tinhtrang = 'Y')
	if(@soluong = 0)
		Update Dausach
		set trangthai = 'N'
		where isbn = @isbn
	else
		Update Dausach
		set trangthai = 'Y'
		where isbn = @isbn
end
go
exec sp_Capnhattrangthaidausach 2

--Cau 4.7 them tua sach moi
create proc sp_ThemTuaSach
@tuasach nvarchar(63),@tacgia nvarchar(31),@tomtat nvarchar(222)
as
begin
	declare @i int
	set @i = 1
	while (exists (select * from TuaSach ts where ts.ma_tuasach = @i))
			set @i = @i + 1
	if(not exists (select * from tuasach ts1 
			where ts1.tuasach = @tuasach 
			and ts1.tacgia = @tacgia 
			and ts1.tomtat like @tomtat))
	begin		
		Insert into Tuasach
		values(@i,@tuasach,@tacgia,@tomtat)
	end
	else
		print 'Khong them duoc'
end
go


--Cau 4.8 : them cuon sach moi
create proc sp_ThemCuonSach
@isbn int
as
begin
		declare @i int
		set @i = 1
		while (exists (select * from CuonSach cs where cs.ma_cuonsach = @i ))
			set @i = @i + 1
		if(Insert into cuonsach
		values(@isbn,@i,'Y'))
		begin
			update Dausach
			set trangthai = 'Y'
			where isbn = @isbn
		end				
end
go


----------------------------******-----------------------
Bui Huynh Thanh Son
06K120