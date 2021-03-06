--giả sử lúc đầu @@TRANCOUNT = 0
ROLLBACK --dam bao ko có giao tác đang thực hiện

begin tran --(T1) @@Trancount = ? 
SELECT @@TRANCOUNT
update Tuasach set Tacgia = 'xxx'   where MaTS = 1 
update TuaSach set TacGia = 'yyy'  where MaTS =2 
 
update TuaSach set TacGia = 'zzz'   where MaTS =3  
Commit tran --(T1)
SELECT @@TRANCOUNT


--@@trancount cho biết số giao tác đang thực hiện của connection
--hiện tại mà chưa commit hay rollback
-------------------------------------------
--transaction lồng nhau

create proc sp_test 
as 
  begin tran --T1 
   --do something 
  commit TRAN


--T2 gọi sp_test
begin tran --T2 
	exec sp_test 
	--do something  
commit tran 
--------------------------------------
--Lệnh commit transaction của transaction con chỉ giảm
--@@trancount đi 1,không có tác dụng yêu cầu hệ quản trị 
--ghi nhận chắc chắn những thay đổi trên CSDL mà transaction này đã làm. 
--
--Chỉ có lệnh commit transaction của transaction ngoài cùng 
--mới thực sự có tác dụng này 
--(như vậy nếu có n transaction lồng nhau thì lệnh commit transaction 
--thứ n mới thực sự commit toàn bộ giao tác).
--Chỉ cần có một lệnh rollback tran (ở bất cứ cấp nào) là toàn bộ giao tác sẽ bị 
--rollback


declare @x int --@@trancount =0 
Begin tran --(T1) 
  
	update TuaSach set TacGia = 'xxx' where MaTS = 1 
	update TuaSach set TacGia = 'yyy' where MaTS = 2 
   
--@@trancount =? 
	
	begin tran T2    
	update TuaSach set TacGia = 'yyy' where MaTS = 3 
   
--@@trancount =? 
	
rollback TRAN T2
 
 
 --Loi??? 
 --Rollback tran + tran_name chỉ hợp lệ khi “tran_name” là tên của transaction
 --ngoài cùng, nếu tran_name ở bên trong thì sẽ bị lỗi
------------------------------------------------
------------------------------------------------

declare @x int
--@@trancount =0 
Begin tran --(T1) 
  
	update TuaSach set TacGia = 'xxx' where MaTS = 1 
	update TuaSach set TacGia = 'yyy' where MaTS = 2 
   
--@@trancount =? 
	BEGIN TRAN
   
   update TuaSach set TacGia = 'zzz' where MaTS = 3 
   
--@@trancount =? 
 rollback TRAN --@@trancount =? 
COMMIT TRAN--/rollback tran; 



