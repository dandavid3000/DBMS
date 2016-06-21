# DBMS

>Final project registration system


## Tables of contents
1. [Requirements](#requirements)
2. [System](#system)


---

### Requirements
##### Introduction
* The system has those features
	* Allow teachers to register projects (Personal or Group of student)
	* Teachers can give extra exercises for points, and there is a limit number of student for that.
	* Allow students to join any group, or project
	* Allow leader of a group register their project

##### Rules

* Everytime teachers register projects, they have permissions to give extra assignments to help students get points. There is a limit of number students who register.
* Teachers decide this number of students.
* Can withdraw a project before its deadline.
* After a deadline, students cannot register theis groups.
* Teachers can extend deadlines.

##### Features

###### Teachers
* Give assignments
* Read information his projects, assignments.
* Update status of projects/assignments: deadline, maximum member number, mamximum group number...

###### Students
* Group registration.
* Allow to register or withdraw projects.
* Move to another group / Ungroup.

###### Administration
* User creations
* Enable/Unenable projects.

###### Others
* Login/logout features.
* Add, delete, modify, update projects
...

---

### Deployed System

##### Features 

* Allow teachers to register projects `(add, delete, upgrade their projects)` with constrains `(group project, personal, max number...)`.
* Allow practical teachers to register his assistant.
* Allow students to register projects, withdraw projects with personal projects.
* Allow group leader to register projects, groups, and withdraw projects or groups.

##### Database design

* Abbreviation
	* `HINHTHUC`=`TYPE` table: Group or Personal.
		* `MaHT` = `TypeID` **PK**
		* `TenHT` = 'TypeName`
	* `DOAN` = `PROJECT` table
		* `MaDoAn` = `ProjectID` **PK**
		* `TenDoAn` = `ProjectName`
		* `DeadLine`
		* `MaHT` = `TypeID`
		* `SoLuongNhomToiDa` = `MaxGroupNumber`
		* `SoLuongNhomDaDangKy` = `GroupRegistrationNumber`
		* `SoLuongGiaoVienToiDa` = `MaxTeacherNumber`
	* `CHITIETDOAN` = `PROJECTDETAIL` table
		* `MaCTDA` = `ProjectDetailID` **PK**
		* `MaDoAn` = `ProjectID`
		* `MaGiaoVien` = `TeacherID`
	* `SINHVIEN` = `STUDENT` table
		* `MaSinhVien` = `StudentID` **PK**
		* `TenSinhVien` = `StudentName`
		* `DienThoai` = `PhoneNumber`
		* `Email`
	* `GIAOVIEN` = `TEACHER` table
		* `MaGiaoVien` = `TeacherID` **PK**
		* `TenGiaoVien` = `TeacherName` 
		* `DienThoai` = `PhoneNumber`
		* `Email`
	* `DANGKIDOAN` = `PROJECTREGISTRATION` table
		* `MaDKDA` = `RegistrationID` **PK**
		* `MaDoAn` = `Project ID`
		* `MaNhom` = `GroupID`
		* `NgayDangKy` = `RegistrationDay`
	* `NHOM` = `GROUP` table
		* `MaNhom` = `GroupID` **PK**
		* `TenNhom` = `GroupName`
		* `SoLuongSV` = `MemberNumber`
		* `MaNhomTruong` = `LeaderID`
	* `CHITIETNHOM` = `GROUPDETAIL` table
		* `MaCTNhom` = `GroupDetailID` **PK**
		* `MaNhom` = `GroupID`
		* `MaSinhVien` = `StudentID`
	* `QUIDINH` = `RULE` table
		* `SoLuongSinhVienToiDaCuaMotNhom` = `MaxStudentOfaGroup`
		* `SoLuongGVToiDaPhuTrachDA` = `MaxTeacherOfaProject`
		* `SoLuongNhomToiDaPhuTrachMotDoAn` = `MaxGroupOfaProJect`

* Description

* Database diagram

	![DB design](../images/dbdesign.jpg "DB design")






