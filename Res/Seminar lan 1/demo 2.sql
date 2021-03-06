Create proc sp_ThemDocGiaNguoiLon 
	@ngaysinh DATETIME
as 

--buoc 1 : xác định mã độc giả 
  declare @madg INT  
  set  @madg = 1
   
  begin transaction 
  while exists (select * from DocGia where ma_docgia = @madg) 
         set @madg = @madg +1 
  
  if ( @@error <>0 ) 
  begin  
		rollback TRAN	--ko có tác dụng return 
		RETURN	 
  end 
  
-- buoc 2 : insert vao bang docgia 
  insert into DocGia values(…) 
  if ( @@error <>0 ) 
  begin  
        rollback tran 
        return 
  end 

-- buoc 3 : kiem tra tuoi 
 if  datediff(yy, @ngaysinh, getdate()) <18 
 begin 
		RAISERROR(‘Tuoi  nho hon 18’,16,1)
		rollback tran 
		return 
 end 
commit transaction        