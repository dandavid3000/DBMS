
----cau 4.1 liet ke thong tin doc gia
drop proc sp_ThongTinDocGia
create proc sp_ThongTinDocGia 
@ma_docgia smallint
as
	begin tran
		begin
			if(exists (select * from nguoilon nl where nl.ma_docgia = @ma_docgia))--doc gia nguoi lon
			begin
				select * from docgia , nguoilon 
				where docgia.ma_docgia = nguoilon.ma_docgia
				and docgia.ma_docgia = @ma_docgia
			end
			if (@@error <>0)
				begin
					raiserror ('Khong lay duoc thong tin',16,1)
					rollback
					return 
				end

			if(exists (select * from treem  where treem.ma_docgia = @ma_docgia))
			begin
				select * from docgia , treem 
				where treem.ma_docgia = docgia.ma_docgia
				and docgia.ma_docgia = @ma_docgia
			end
			if (@@error <>0)
				begin
					raiserror ('Khong lay duoc thong tin',16,1)
					rollback
					return 
				end

		end
	commit tran
go

--

--drop proc sp_ThongTinDocGia 

-- Bai 4.2

Create proc sp_ThongTinDauSach @ISBN int 
As 
	Begin tran
		Begin
			select ds.isbn, ts.ma_tuasach,ts.tuasach, count(*) as TongCong
			from dausach ds, tuasach ts, cuonsach cs
			where ds.isbn = @isbn and ds.isbn = cs.isbn and cs.tinhtrang = 'Y'
			and ts.ma_tuasach = ds.ma_tuasach
			group by ds.isbn, ts.ma_tuasach,ts.tuasach

			if @@error !=0
				begin
					raiserror ('Khong lay duoc thong tin',16,1)
					rollback
					return 
				end
		End
	Commit tran

Exec sp_ThongTinDauSach 11
Drop proc sp_ThongTinDauSach

--Bai 4.3

Create proc sp_ThongTinNguoiLonDangMuon 
As 
	Begin tran
		Begin
			Select * from NguoiLon NL,DocGia DG  where exists (Select * from Muon M where NL.ma_docgia = M.ma_docgia and NL.ma_docgia = DG.ma_docgia)
			if @@error !=0
				begin
					raiserror ('Khong lay duoc thong tin',16,1)
					rollback
					return 
				end
			
		End 
	Commit tran
Exec sp_ThongTinNguoiLonDangMuon 

Drop proc sp_ThongTinNguoiLonDangMuon 

--4.4. liet ke doc gia nguoi lon dang muon sach qua han

create proc sp_ThongTinNguoiLonQuaHan
as
	begin tran
		begin
			select  * from nguoilon nl, docgia dg
				where nl.ma_docgia = dg.ma_docgia
					and dg.ma_docgia in (select m.ma_docgia from muon m
					where m.ma_docgia = nl.ma_docgia and datediff(day,m.ngaygio_muon,getdate())>14)  
			
					if @@error !=0
						begin
							raiserror ('Khong lay duoc thong tin',16,1)
							rollback
							return 
						end
		end
	commit tran
go


---drop proc sp_ThongTinNguoiLonQuaHan

-- Bai 4.5

Create proc sp_DocGiaCoTreEmMuon
As
	Begin tran
		Begin
			Select * from NguoiLon NL,DocGia DG,TreEm TE  where exists (Select * from Muon M,Muon M1 
									where NL.ma_docgia = M.ma_docgia and NL.ma_docgia = DG.ma_docgia
									and TE.ma_docgia_nguoilon=NL.ma_docgia and TE.ma_docgia=M1.ma_docgia)
		
			if @@error !=0
				begin
					raiserror ('Khong lay duoc thong tin',16,1)
					rollback
					return 
				end
		End
	Commit tran

Exec sp_DocGiaCoTreEmMuon

Drop proc sp_DocGiaCoTreEmMuon


---cau 4.6 cap nhat trang thai cua dau sach
create proc sp_CapNhatTrangThaiDauSach
@isbn int
as 
begin tran
	begin

		if( (select count(*) 
			from dausach ds,cuonsach cs
			where ds.isbn = @isbn
					and ds.isbn = cs.isbn
			and cs.tinhtrang = N'Y')=0)
			if @@error !=0
				begin
					raiserror ('Khong lay duoc thong tin',16,1)
					rollback
					return 
			end		

			Update Dausach
			set trangthai = N'N'
			where isbn = @isbn

			IF @@error <> 0
			begin
				print 'Loi roi'
				Rollback tran
				Return
			end
		else
			Update Dausach
			set trangthai = N'Y'
			where isbn = @isbn

			IF (@@error <> 0)
			begin
				print 'Loi roi'
				Rollback tran
				Return
			end
	end
commit tran
Go

--drop proc  sp_CapNhatTrangThaiDauSach

--4.7 them tua sach moi
create proc sp_ThemTuaSach
@tuasach nvarchar(63),@tacgia nvarchar(31),@tomtat ntext
as
begin tran
begin
	if(not exists (select * from tuasach ts1 
			where ts1.tuasach like @tuasach 
			and ts1.tacgia like @tacgia 
			and ts1.tomtat like @tomtat))
	begin		
		declare @i int
		set @i = 1
		while (exists (select * from TuaSach ts where ts.ma_tuasach = @i))
			set @i = @i + 1
		Insert into Tuasach
		values(@i,@tuasach,@tacgia,@tomtat)
		IF (@@error <> 0)
			begin
				print 'Loi roi'
				Rollback tran
				Return
			end
	end
	else
		print 'Khong them duoc'
end
commit tran
go
exec sp_themtuasach N'Le3',N'nhan2',N'hoi khung'
exec sp_themtuasach N'Le9',N'nhan10',N'hoi khung wa'

--4.8 them cuon sach moi
---------------------------------------------------------------------------------------
create proc sp_ThemCuonSach
@isbn int
as
begin tran
begin
		declare @i int
		set @i = 1
		while (exists (select * from CuonSach cs where cs.ma_cuonsach = @i ))
			set @i = @i + 1
			if(Insert into cuonsach
		values(@isbn,@i,N'Y'))
		IF (@@error <> 0)
			begin
				print 'Loi roi'
				Rollback tran
				Return
			end

		begin
			update Dausach
			set trangthai = N'Y'
			where isbn = @isbn
			
			IF (@@error <> 0)
				begin
					print 'Loi roi'
					Rollback tran
					Return
				end
		end
		
end
commit tran
--cau 4.9 them doc gia nguoi lon

create proc sp_ThemNguoiLon 
@sonha nvarchar(20),
@duong nvarchar(20),
@quan nvarchar(10),
@dienthoai nvarchar(15),
@han_sd datetime,					
@ho nvarchar(15),
@tenlot nvarchar(10),
@ten nvarchar(20),
@ngaysinh datetime
as
	declare @ma_docgia int 
		set @ma_docgia  = 1
begin tran		
begin 
		while exists (select * from docgia where ma_docgia = @ma_docgia)
			set @ma_docgia = @ma_docgia + 1
		
		if(datediff(year,@ngaysinh,getdate())>=18)
		begin
			insert into NguoiLon values(@ma_docgia,@sonha,@duong,@quan,@dienthoai,@han_sd)
			IF (@@error <> 0)
				begin
					print 'Loi ko them duoc'
					Rollback tran
					Return
				end

			insert into DocGia values(@ma_docgia,@ho,@tenlot,@ten,@ngaysinh)
			IF (@@error <> 0)
				begin
					print 'Loi ko them duoc'
					Rollback tran
					Return
				end
		end
		else
			 raiserror (' Loi khong du tuoi',0,1)
		
end
commit tran
go

--drop proc  sp_ThemNguoiLon 

--4.10 them doc gia tre em
--drop proc sp_themtreem

create proc sp_Themtreem 


@duong nvarchar(63),
@quan nvarchar(2),
@dienthoai nvarchar(13),
@ho nvarchar(15),
@tenlot nvarchar(1),
@ten nvarchar(15),
@ngaysinh smalldatetime,
@han_sd smalldatetime,
@ma_docgia_nguoilon	int
as
	declare @ma_docgia int 
		set @ma_docgia  = 2
begin tran
	begin 
		while exists (select * from docgia where ma_docgia = @ma_docgia)
			set @ma_docgia = @ma_docgia + 2
		insert into DocGia values(@ma_docgia,@ho,@tenlot,@ten,@ngaysinh)
		/*kiem tra ma doc gia nguoi lon*/
		declare @SLTreEmBaoLanh int
		set @SLTreEmBaoLanh= (select count(*) from Treem where Ma_DocGia_NguoiLon=@Ma_DocGia_NguoiLon)
		if(@SLTreEmBaoLanh>=2)
	    begin
			raiserror ('Khong them vo duoc bi doc gia da bao lanh tren 2 tre em roi',0,1)
			rollback
			return
	    end
	    insert into TreEm values(@Ma_DocGia,@Ma_DocGia_NguoiLon)
		if(@@error!=0)
			begin
				raiserror (' Loi khong the them vao bang nguoi lon',0,1)
				rollback
				return
			end
	end
commit tran
go

---cau 11:xoa mot doc gia LUU Y PHAI CHAY DAY DU HAM CAN THIET TRUOC KHI CHAY CREATE PROC
---kiem tra doc gia co ton tai ko?

create proc sp_xoadocgia 
@ma_docgia smallint
as 
begin tran
begin
	
	if ( not exists(select * from docgia where ma_docgia=@ma_docgia)
 )--ko co doc gia nay
	begin
		print 'khong co doc gia nay'
		return
	end
	if ( exists(select * from muon  where ma_docgia=@ma_docgia) )
	--doc gia dang muon sach
	begin 
		print 'doc gia dang muon sach ko the xoa'
		return
	end

		if exists(select * from nguoilon  where ma_docgia=@ma_docgia)--day la doc gia nguoi lon

		begin
			if not exists(select * from treem  where ma_docgia_nguoilon=@ma_docgia)
--doc gia ko bao lanh tre em
				begin
					
					delete from nguolon where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from quatrinhmuon where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from dangky where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from docgia where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
				end
		
			else --co bao lanh tre em
				begin
					delete from treem where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from nguolon where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from quatrinhmuon where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from dangky where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
					delete from docgia where ma_docgia=@ma_docgia
					if(@@error!=0)
						begin
							raiserror (' Loi khong the xoa doc gia',0,2)
							rollback
							return
						end
				end
		end
	else--day la doc gia tre em
		begin 
			delete from treem where ma_docgia=@ma_docgia
			if(@@error!=0)
				begin
					raiserror (' Loi khong the xoa doc gia',0,2)
					rollback
					return
				end
			delete from quatrinhmuon where ma_docgia=@ma_docgia
			if(@@error!=0)
				begin
					raiserror (' Loi khong the xoa doc gia',0,2)
					rollback
					return
				end
			delete from dangky where ma_docgia=@ma_docgia
			if(@@error!=0)
				begin
					raiserror (' Loi khong the xoa doc gia',0,2)
					rollback
					return
				end
			delete from docgia where ma_docgia=@ma_docgia
			if(@@error!=0)
				begin
					raiserror (' Loi khong the xoa doc gia',0,2)
					rollback
					return
				end
		end
			

	
end
commit tran
go
--drop proc sp_xoadocgia 


-------


-------------------------------
--cau 4.12 kiem tra cuon sach cung loai nay co bi muon boi doc gia nay hay ko
-----kiem tra doc gia co muon sach cung loai ko co tra ve 1 ko tra ve 0
create proc sp_muonsach
@isbn int,@ma_docgia smallint
as 
begin
	declare @docgia_nguoilon int
	exec @docgia_nguoilon=dbo.docgia_nguoilon @ma_docgia--goi ham kiem tra co phai la doc gia nuoi lon
	if(@isbn in (select isbn from muon where ma_docgia=@ma_docgia))
		begin

			print 'ban da muon sach nay rui ko cho muon nua'
			return

		end
	if exists(select * from nguoilon  where ma_docgia=@ma_docgia)--day la doc gia nguoi lon
	begin
		if((select count (*) from muon where ma_docgia=@ma_docgia)>5 )
		begin
			print 'muon du sach ko cho muon them'
			return
		end
	end
	else--doc gia la tre em
		begin
			if((select count (*) from muon where ma_docgia=@ma_docgia)<1 )
				begin
					--lay may doc gia nguo lon bao lanh cho tre em
					declare @manguoilon nvarchar(20)
					set @manguoilon = (select ma_docgia_nguoilon from treem where ma_docgia=@ma_docgia)
					if((select count (*) from muon where ma_docgia=@manguoilon)=5 )
						begin

							print 'vi pham ko cho muon'
							return
						end

				end
			else
				begin
					print'ko cho muon'
					return
				end
		end  select * from dausach
---kiem tra sach trong thu vien con ko
	if((select count (*) from cuonsach where isbn = @isbn and tinhtrang='N')>=1)
		begin
			--lay ma cuon sach cho muon ra
			declare @ngayhethan datetime
			--set @ngayhethan=getdate()+
			declare @masachchomuon nvarchar(20)
			set @masachchomuon = (select ma_cuonsach from cuonsach where isbn=@isbn)
			insert into muon values(@isbn,@masachchomuon,@ma_docgia,getdate(),@ngayhethan)
			if(@@error!=0)
				begin
					raiserror (' Loi khong the update',0,3)
					rollback
					return
				end
			--cap nhat tinh trang cuon sach 

			update cuonsach set tinhtrang='Y' where ma_cuonsach=@masachchomuon
			if(@@error!=0)
				begin
					raiserror (' Loi khong the update',0,3)
					rollback
					return
				end
			---up date trang thai dau sach
			if((select count (*) from cuonsach where isbn = @isbn and tinhtrang='N')=0)
				update dausach set trangthai='N' where isbn=@isbn  
				if(@@error!=0)
				begin
					raiserror (' Loi khong the update',0,3)
					rollback
					return
				end
			else 
				update dausach set trangthai='N' where isbn=@isbn 
				if(@@error!=0)
				begin
					raiserror (' Loi khong the update',0,3)
					rollback
					return
				end 
			print 'muon sach thanh cong chuc mung ban nho tra som nhe :D'
		end
	else--ko cuon quyen sach nao cho muon them vao ban dang ky
		begin
			print'Sach nay da het vui long cho'
			insert into dangky values(@isbn,@ma_docgia,getdate(),'can gap')
			if(@@error!=0)
				begin
					raiserror (' Loi khong the insert',0,3)
					rollback
					return
				end
		end

	
	
end
go
--drop proc sp_muonsach


---cau 4.13 tra sach
create proc sp_trasach
@ma_cuonsach nvarchar(20) , @madocgia nvarchar(20),@isbn int
as 

begin
declare @ngay_hethan datetime
declare @sotienphat int
declare @ngaygiomuon datetime
declare @ngayhethong datetime
set @ngayhethong=getdate()
---tinh tien phat
set @ngay_hethan = (select ngay_hethan from muon where isbn=@isbn and ma_cuonsach=@ma_cuonsach and @madocgia=ma_docgia)
set @sotienphat=datediff(day,@ngayhethong,@ngay_hethan)*1000
set @ngaygiomuon = (select ngaygio_muon from muon where isbn=@isbn and ma_cuonsach=@ma_cuonsach and @madocgia=ma_docgia)
insert into quatrinhmuon values(@isbn,@ma_cuonsach,@ngaygiomuon,@madocgia,@ngay_hethan,getdate(),5000+@sotienphat,0,0,'ko gi')
if(@@error!=0)
	begin
		raiserror (' Loi khong the update',0,3)
		rollback
		return
	end
delete from muon where isbn=@isbn and ma_docgia=@madocgia and ma_cuonsach=@ma_cuonsach
if(@@error!=0)
	begin
		raiserror (' Loi khong the delete',0,2)
		rollback
		return
	end
end
go
--drop proc sp_trasach
--cau 5.1
--tg_delMuon:
--Nß╗Öi dung: Cß║¡p nhß║¡t t├¼nh trß║íng cß╗ºa cuß╗æn s├ích l├á yes.
CREATE TRIGGER tg_delMuon ON muon 
FOR delete
 AS 
Begin 
	DECLARE @isbn int, @ma_cuonsach smallint 
	SELECT @isbn = isbn, @ma_cuonsach = ma_cuonsach 
	FROM deleted 

	UPDATE cuonsach 
	SET tinhtrang = 'y'
	WHERE isbn = @isbn AND ma_cuonsach = @ma_cuonsach 
End
Go
--drop TRIGGER tg_delMuon
----cau 5.2
--tg_insMuon:
--Nß╗Öi dung: Cß║¡p nhß║¡t t├¼nh trß║íng cß╗ºa cuß╗æn s├ích l├á no.
CREATE TRIGGER tg_insMuon ON muon 
FOR insert
 AS 
Begin 
	DECLARE @isbn int, @ma_cuonsach smallint 
	SELECT @isbn = isbn, @ma_cuonsach = ma_cuonsach 
	FROM inserted 

	UPDATE cuonsach 
	SET tinhtrang = 'n'
	WHERE isbn = @isbn AND ma_cuonsach = @ma_cuonsach 
End
go
--drop TRIGGER tg_insMuon
--cau 5.3
--tg_updCuonSach:
--Nß╗Öi dung: Khi thuß╗Öc t├¡nh t├¼nh trß║íng tr├¬n bß║úng cuß╗æn s├ích ─æ╞░ß╗úc cß║¡p nhß║¡t th├¼ trß║íng th├íi cß╗ºa ─æß║ºu s├ích c┼⌐ng ─æ╞░ß╗úc cß║¡p nhß║¡t theo.
CREATE TRIGGER tg_upcuonsach ON cuonsach
FOR update
 AS 
Begin 
	DECLARE @isbn int, @ma_cuonsach smallint 
	SELECT @isbn = isbn, @ma_cuonsach = ma_cuonsach 
	FROM updated 

if((select count (*) from cuonsach where isbn = @isbn and tinhtrang='N' )=0)
	UPDATE dausach 
	SET trangthai = 'n'
	WHERE isbn = @isbn  
else
	UPDATE dausach 
	set trangthai = 'y'
	WHERE isbn = @isbn  
End
Go
--drop TRIGGER tg_upcuonsach
