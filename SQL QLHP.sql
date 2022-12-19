create database QuanLyHocPhi
GO
use QuanLyHocPhi
GO
CREATE TABLE TaiKhoan(
	id int identity primary key,
	UserName nvarchar(50) not null,
	PassWord nvarchar(50) not null,
	HoTen nvarchar(50) not null,
	DiaChi nvarchar(50) not null,
	CMND nvarchar(50) not null,
)
GO
CREATE TABLE Lop(
	id int identity primary key,
	TenLop nvarchar(50) not null,
)
GO
CREATE TABLE NienKhoa(
	id int identity primary key,
	TenNienKhoa nvarchar(50) not null,
)
GO
CREATE TABLE HocSinh(
	id int identity primary key,
	TenHocSinh nvarchar(50) not null,
	Lop int foreign key references Lop(id),
	NgaySinh datetime not null,
	DiaChi nvarchar(150) not null,
	TongNo real default 0,
	MaNienKhoa int foreign key references NienKhoa(id),
)
GO
CREATE TABLE HocKy(
	id int identity primary key,
	TenHocKy nvarchar(50) not null,
	MaNienKhoa int foreign key references NienKhoa(id),
	SoTien nvarchar(50) not null,
)
GO
CREATE TABLE NopHocPhi(
	id int identity primary key,
	NguoiNhan int foreign key references TaiKhoan(id),
	MaHocKy int foreign key references HocKy(id),
	MaHocSinh int foreign key references HocSinh(id),
	ThoiGianNop Datetime not null,
	NoiDung nvarchar(50) not null,
	GhiChu nvarchar(50) not null,
	SoTien real not null,
)
--- Thêm sửa xoá lớp
GO
CREATE PROCEDURE sp_AddLop(@tenLop nvarchar(150))
as 
begin
	insert into Lop (TenLop) values (@tenLop)
end
GO
CREATE PROCEDURE sp_EditLop(@malop int,@tenLop nvarchar(150))
as 
begin
	update Lop set TenLop = @tenLop where id = @malop
end
GO
CREATE PROCEDURE sp_DeleteLop(@malop int)
as 
begin
	delete Lop where id = @malop
end
---Niên khoá
GO
CREATE PROCEDURE sp_AddNienKhoa(@tenNienKhoa nvarchar(150))
as 
begin
	insert into NienKhoa (TenNienKhoa) values (@tenNienKhoa)
end
GO
CREATE PROCEDURE sp_EditNienKhoa(@maNienKhoa int,@tenNienKhoa nvarchar(150))
as 
begin
	update NienKhoa set TenNienKhoa = @tenNienKhoa where id = @maNienKhoa
end
GO
CREATE PROCEDURE sp_DeleteNienKhoa(@maNienKhoa int)
as 
begin
	delete NienKhoa where id = @maNienKhoa
end
---Học sinh
GO
CREATE PROCEDURE sp_AddHocSinh(@tenHocSinh nvarchar(150),@Lop int, @ngaySinh datetime ,@DiaChi nvarchar(150),@MaNienKhoa int)
as 
begin
	insert into HocSinh(TenHocSinh,Lop,NgaySinh,DiaChi,MaNienKhoa) values (@tenHocSinh,@Lop,@ngaySinh,@DiaChi,@MaNienKhoa)
end
GO
CREATE PROCEDURE sp_EditHocSinh(@tenHocSinh nvarchar(150),@Lop int, @ngaySinh datetime ,@DiaChi nvarchar(150),@MaNienKhoa int,@maHocSinh int)
as 
begin
	update HocSinh set TenHocSinh = @tenHocSinh, Lop = @Lop,NgaySinh = @ngaySinh, DiaChi = @DiaChi,MaNienKhoa = @MaNienKhoa where id = @maHocSinh
end
GO
CREATE PROCEDURE sp_DeleteHocSinh(@maHocSinh int)
as 
begin
	delete HocSinh where id = @maHocSinh
end
---Học kỳ
GO
CREATE PROCEDURE sp_AddHocKy(@tenHocKy nvarchar(150),@MaNienKhoa int, @SoTien real)
as 
begin
	insert into HocKy (TenHocKy,MaNienKhoa,SoTien) values (@tenHocKy,@MaNienKhoa,@SoTien)
end
GO
CREATE PROCEDURE sp_EditHocKy(@tenHocKy nvarchar(150),@MaNienKhoa int, @SoTien real,@maHocKy int)
as 
begin
	update HocKy set TenHocKy = @tenHocKy, MaNienKhoa = @MaNienKhoa, SoTien = @SoTien where id = @maHocKy
end
GO
CREATE PROCEDURE sp_DeleteHocKy(@maHocKy int)
as 
begin
	delete HocKy where id = @maHocKy
end
---Nộp học phí
GO
CREATE PROCEDURE sp_AddNopHocPhi(
	@nguoiNhanTien int,
	@MaHocKy int,
	@MaHocSinh int,
	@ThoiGian Datetime,
	@NoiDung nvarchar(100),
	@GhiChu nvarchar(100),
	@SoTien real )
as 
begin
	insert into NopHocPhi (NguoiNhan,MaHocKy,MaHocSinh,SoTien,NoiDung,GhiChu,ThoiGianNop) values (@nguoiNhanTien,@MaHocKy,@MaHocSinh,@SoTien,@NoiDung,@GhiChu,@ThoiGian)
end
GO
CREATE PROCEDURE sp_EditNopHocPhi
(
	@nguoiNhanTien int,
	@MaHocKy int,
	@MaHocSinh int,
	@ThoiGian Datetime,
	@NoiDung nvarchar(100),
	@GhiChu nvarchar(100),
	@SoTien real,
	@MaNopHoc int)
as 
begin
	update NopHocPhi set NguoiNhan = @nguoiNhanTien,ThoiGianNop = @ThoiGian, MaHocKy = @MaHocKy, @MaHocSinh = @MaHocSinh, SoTien = @SoTien,NoiDung = @NoiDung, GhiChu = @GhiChu where id = @MaNopHoc
end
GO
CREATE PROCEDURE sp_DeleteNopHocPhi(@MaNopHoc int)
as 
begin
	delete NopHocPhi where id = @MaNopHoc
end
GO
CREATE trigger trigger_HocPhi On HocKy 
after insert, update, delete
as begin 
	if exists (select * from deleted)
		begin
			if exists (select * from inserted)
			begin
				update HocSinh set TongNo = TongNo - (select SoTien from deleted) + (select SoTien from inserted) where MaNienKhoa =  (select MaNienKhoa from inserted)
			end
			else
			begin
				update HocSinh set TongNo = TongNo - (select SoTien from deleted)  where MaNienKhoa =  (select MaNienKhoa from inserted)
			end
		end
	else if exists (select * from inserted)
	begin
		update HocSinh set TongNo = TongNo + (select SoTien from inserted) where MaNienKhoa =  (select MaNienKhoa from inserted)
	end
end
GO
CREATE trigger trigger_NopHocPhi On NopHocPhi
after insert, update, delete
as begin 
	if exists (select * from deleted)
		begin
			if exists (select * from inserted)
			begin
				update HocSinh set TongNo = TongNo + (select SoTien from deleted) - (select SoTien from inserted) where MaNienKhoa =  (select MaNienKhoa from inserted)
			end
			else
			begin
				update HocSinh set TongNo = TongNo + (select SoTien from deleted)  where MaNienKhoa =  (select MaNienKhoa from inserted)
			end
		end
	else if exists (select * from inserted)
	begin
		update HocSinh set TongNo = TongNo - (select SoTien from inserted) where MaNienKhoa =  (select MaNienKhoa from inserted)
	end
end
