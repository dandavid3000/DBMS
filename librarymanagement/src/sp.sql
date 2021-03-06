-- Ho ten : Vo Huynh Dan
-- MSSV : 0941037
-- Lop : 09HCA
-- BAI TAP QUAN LY THU VIEN
-- Store - Procedure

--4.1 Xem thong tin doc gia
drop procedure sp_ThongTinDocGia

create proc sp_ThongTinDocGia 
@ma_docgia smallint
	as
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
	go

exec sp_ThongTinDocGia 6


--4.4 Liet ke doc gia nguoi lon dang muon sach qua han

create proc sp_ThongTinNguoiLonQuaHan
as
	begin
		select * from nguoilon nl, muon m
			where nl.ma_docgia = m.ma_docgia
			and datediff(day,m.ngayGio_muon,getdate())>14
			and exists(select * from docgia dg
				where dg.ma_docgia = nl.ma_docgia)  
	end
go

exec sp_ThongTinNguoiLonQuaHan

--4.6 Cap nhat trang thai cua dau sach

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
			and cs.tinhtrang = N'Y')
	if(@soluong = 0)
		Update Dausach
		set trangthai = N'N'
		where isbn = @isbn
	else
		Update Dausach
		set trangthai = N'Y'
		where isbn = @isbn
end
go

exec sp_CapNhatTrangThaiDauSach 5

--4.9 Them doc gia nguoi lon

create proc sp_ThemNguoilon 
@sonha nvarchar(15),
@duong nvarchar(63),
@quan nvarchar(2),
@dienthoai nvarchar(13),
@han_sd smalldatetime,
@ho nvarchar(15),
@tenlot nvarchar(10),
@ten nvarchar(15),
@ngaysinh smalldatetime
				
as
	declare @ma_docgia int 
		set @ma_docgia  = 1
		
	begin 
		while exists (select * from docgia where ma_docgia = @ma_docgia)
			set @ma_docgia = @ma_docgia + 1
		insert into DocGia values(@ma_docgia,@ho,@tenlot,@ten,@ngaysinh)
		if(datediff(year,@ngaysinh,getdate())>=18)
			insert into NguoiLon values(@ma_docgia,@sonha,@duong,@quan,@dienthoai,@han_sd)
		else
			print'Ko du tuoi dang ky'
	end
go

--4.11 Xoa doc gia

drop procedure sp_XoaDocGia

create proc sp_XoaDocGia
@ma_docgia int
as 
	begin

		if exists(select * from docgia where ma_docgia=@ma_docgia)
			if exists(select * from  muon where ma_docgia=@ma_docgia)
				print'Ko the xoa doc gia duoc'
				
			else 
				if(exists (select * from nguoilon nl where nl.ma_docgia = @ma_docgia))
					if(exists (select * from treem te where te.ma_docgia_nguoilon = @ma_docgia))
						begin
							delete from treem  where ma_docgia_nguoilon = @ma_docgia
							delete from nguoilon where ma_docgia = @ma_docgia
							delete from quatrinhmuon where ma_docgia = @ma_docgia
							delete from dangky where ma_docgia = @ma_docgia
							delete from docgia where ma_docgia =@ma_docgia 
						end
					else
						begin 
							delete from nguoilon where ma_docgia = @ma_docgia
							delete from quatrinhmuon where ma_docgia = @ma_docgia
							delete from dangky where ma_docgia = @ma_docgia 
							delete from docgia where ma_docgia =@ma_docgia
						end
				
				if(exists (select * from treem te where te.ma_docgia = @ma_docgia))
					begin
			
						delete from treem where ma_docgia = @ma_docgia
						delete from quatrinhmuon where ma_docgia = @ma_docgia
						delete from  dangky where ma_docgia = @ma_docgia
						delete from docgia where ma_docgia = @ma_docgia
						
					end
					
		else
			print 'Ko ton tai doc gia'

	end
go

--4.12 Muon sach

drop procedure sp_MuonSach


create proc sp_MuonSach
@isbn int, @ma_docgia smallint
as 
	begin
		if exists(select * from muon where ma_docgia=@ma_docgia and isbn = @isbn)
			begin	
				print 'Ban da muon sach nay roi'
				return
			end
		if exists(select * from muon where ma_docgia=@ma_docgia)
			begin 
				if(exists (select * from nguoilon nl where nl.ma_docgia = @ma_docgia))
						if((select count(*) from muon where ma_docgia =@ma_docgia) = 5)
							begin	
								print 'Da muon du sach, ko the muon them'
								return
							end
				if(exists (select * from treem te where te.ma_docgia = @ma_docgia))
					begin	
						select * from treem te, muon m
						where te.ma_docgia = @ma_docgia 
						if((select count(*) from muon where @ma_docgia = ma_docgia) = 1)
						begin	
								print 'Da muon du sach, ko the muon them'
								return
						end
					end
			 end
		--Kiem tra sach co con trong thu vien ko
		if((select count(*)  from cuonsach where isbn = @isbn and tinhtrang='N')>1)
			begin
				declare @ma_cuonsach smallint
					set @ma_cuonsach = (select ma_cuonsach from muon where isbn = @isbn and ma_docgia = @ma_docgia)
					
				declare @ngayGio_muon smalldatetime 
					set @ngayGio_muon = getdate()

				declare @ngay_hethan smalldatetime
					set @ngay_hethan = getdate() + 30
				insert into Muon values(@isbn,@ma_cuonsach,@ma_docgia,@ngayGio_muon,@ngay_hethan)
			end
		else 
			begin
				print 'Sach ko con trong tv, xin cho'

				declare @ngaygio_dk   smalldatetime
					set @ngaygio_dk = getdate()
				declare @ghichu nvarchar(255)
					set @ghichu = 'Ko co gi'

				insert into DangKy values (@isbn,@ma_docgia,@ngaygio_dk,@ghichu)
			end
		end
go

--4.13 Tra sach

drop procedure sp_TraSach

create proc sp_TraSach
@isbn int,@ma_cuonsach smallint,@ma_docgia smallint
as 
	begin
		declare @ngayGio_muon smalldatetime,@ngay_hethan smalldatetime,@ngayGio_tra smalldatetime,@tien_muon money,@tien_datra money,@tien_datcoc money,@ghichu nvarchar(255)
		select @ngayGio_muon=ngayGio_muon,@ngay_hethan=ngay_hethan from Muon where isbn = @isbn and ma_cuonsach = @ma_cuonsach and ma_docgia = @ma_docgia
		set @tien_muon = 0
		set @ngayGio_tra = GETDATE()

		declare @ngay_quahan smalldatetime, @tien_phat money

		set @ngay_quahan = DATEDIFF(day,@ngay_hethan,@ngayGio_tra)

		if(@ngay_quahan > 0)
		begin
			set @tien_phat = 1000*Datediff(day,@ngay_hethan,@ngayGio_tra)
		end
		set @tien_muon = @tien_muon + @tien_phat
		-- Them vao bang qua trinh muon
		insert into QuaTrinhMuon Values(@isbn,@ma_cuonsach,@ngayGio_muon,@ma_docgia,@ngay_hethan,@ngayGio_tra,@tien_muon,@tien_datra,@tien_datcoc,@ghichu)
	
		--Xoa du lieu trong bang muon
		delete from Muon where isbn=@isbn and ma_cuonsach=@ma_cuonsach and ma_docgia=@ma_docgia

		update CuonSach set TinhTrang='N' where isbn=@isbn and Ma_CuonSach=@ma_cuonsach
		exec sp_CapNhatTrangThaiDauSach @isbn
	end
go

-----------------------------------------------------------------------------
-- Trigger

--5.1 Cập nhật tình trạng của cuốn sách là yes

Drop Trigger tg_delMuon

Create Trigger tg_delMuon on muon
for delete 
as 
	begin 
		declare @isbn int, @ma_cuonsach smallint 
		select @isbn = isbn, @ma_cuonsach = ma_cuonsach 
		from deleted 

		update CuonSach
		set tinhtrang = 'yes'
		where isbn = @isbn and ma_cuonsach = @ma_cuonsach 

	end
go

--5.2 Cập nhật tình trạng của cuốn sách là no

Drop Trigger tg_insMuon

Create Trigger tg_insMuon on muon
for insert
as 
	begin 
		declare @isbn int, @ma_cuonsach smallint 
		select @isbn = isbn, @ma_cuonsach = ma_cuonsach 
		from inserted 

		update CuonSach
		set tinhtrang = 'no'
		where isbn = @isbn and ma_cuonsach = @ma_cuonsach 

	end
go

--5.3 Khi thuộc tính tình trạng trên bảng cuốn sách được cập nhật thì trạng thái của đầu sách cũng được cập nhật theo

Drop Trigger tg_updCuonSach

Create Trigger tg_updCuonSach on CuonSach
for update 
as 
	begin
		declare @isbn int, @Ma_CuonSach smallint 
		select @isbn = isbn, @Ma_CuonSach = Ma_CuonSach
		from updated

		if((select count(*) from CuonSach where isbn = @isbn and tinhtrang=N'Y') = 0)
			begin
				update DauSach
				set trangthai = 'no'
				where isbn = @isbn
			end
		else 
			begin
				update DauSach
				set trangthai = 'yes'
				where isbn = @isbn
			end

	end
go