>Final project registration system


## Table of contents
1. [Requirements](#requirements)
2. [Deployed System](#deployed-system)


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

Check the script [here](src/dbscript.sql) for this database 

* Abbreviation
	* `HINHTHUC`=`TYPE` table: Group or Personal.
		* `MaHT` = `TypeID` **PK**
		* `TenHT` = 'TypeName`
	* `DOAN` = `PROJECT` table
		* `MaDoAn` = `ProjectID` **PK**
		* `TenDoAn` = `ProjectName`
		* `DeadLine`
		* `YeuCau` = `Requirements`
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
	* `PROJECT` table includes information about the project. Every project has `ProjectID` to distinguish with other projects. Every project has its name `ProjectName`, along with other information such as `DeadLine`, `Requirements`, `TypeID`, and maximum group number `MaxGroupNumber`.

	* `TYPE` table stores information about how to do this project. We have 
`TypeID` which means that `Project for groups` or `Personal project`, or `Extra assignment`

	* `PROJECTDETAIL` table shows which teacher is responsible for that project by using `ProjectDetailID`, and `TeacherID`. Many teachers are responsible for one project.

	* `PROJECTREGISTRATION` table includes information of sudents who registered (or groups). Which project did they register `ProjectID`, ID of students `GroupID`, and the day they registered `RegistrationDay`

	* `TEACHER` table shows information of teachers. Every teacher has his own ID `TeacherID` along with other information such as name of teachers `TeacherName`, phone number `PhoneNumber`, and email address `Email`

	* `STUDENT` table is similar to `TEACHER` table

	* `GROUP` shows information of registration groups. If the project is a personal project, group has only one student who is a group leader. There are `GroupID`, `GroupName`, `MemberNumber` How many member are there in the group, `LeaderID` ID of a group leader.

	* `GROUPDETAIL` table shows information of members in a group

	* `RULE` contains rules that set by teachers.


* Database diagram

	![DB design](../images/dbdesign.jpg "DB design")


##### Store Procedure

Build store procedures to perform requirements.

* `sp_GVUpdateDA`
	* *Purpose*: A teacher wants to update old projects
	* *Variables*:
		* `@Ma_DA` *int* : Projet ID
		* `@TenDoAn` *nvarchar(50)* : Project name
		* `@dead_Lone` *datatime* : Deadline
		* `@yeu_cau` *nvarchar(50)* : Project requirements
		* `@MaHT` *int* : Type ID
		* `@SoLuongNhomToiDa` *int* : Max group number
		* `@SoLuongNhomToiDaDangKy` *int* : Number of group who registered projects
		* `@SoLuongGiaoVienToiDa` *int* : Max teacher number
		* `@SoLuongGiaoDaVienPhuTrach` *int* : Reponsible teacher number
	* *Process*:
		* Check the project
			* See if the project exists or not? If not shows errors, and quit.
			* Check the maximum group number
		* If it satisfies
			* Check max teacher number > reponsible teacher number
				* If it satisfies, then update new information
				* Else show errors.
		* If it doesn't satisfy, show errors

	* [Code](src/sp_GVUpdateDA.sql)

* `sp_SVDangKyDA`
	* *Purpose*: Students want to update old projects
	* *Variables*:
		* `@Ma_DA` *int* : Projet ID
		* `@Ma_Nhom` *int* : Group ID
		* `@NgayDangKy` *datatime* : Registration day
	* *Process*:
		* Check the project
			* See if the project exists or not? If not shows errors, and quit.
			* Check if the group registered or not. If yes, show errors and quit.
		* Check if the project is able to register
			* Check the deadline
			* Check max group number
		* Check if the group exists or not.
		* Register the project.

	* [Code](src/sp_SVDangKyDA.sql)


