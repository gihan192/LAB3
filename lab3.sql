--Bài 1/1
use QLDA
select MA_NVIEN, MADA, STT, cast (THOIGIAN as decimal (5,1)) as 'Thời gian' from PHANCONG;

select MA_NVIEN, MADA, STT, convert (decimal (5,1),THOIGIAN ) as 'Thời gian' from PHANCONG;

--Bài 1/2
use QLDA

declare @thongke table (MADA int, THOIGIAN float)
insert into @thongke
select MADA, sum(THOIGIAN) as ' Tổng thời gian' from PHANCONG
group by MADA


select TENDA, cast(THOIGIAN as decimal (5,2)) as 'Tổng thời gian'
from @thongke a inner join DEAN b on a.Mada =b.MADA

select TENDA, convert(decimal (5,2), THOIGIAN) as 'Tổng thời gian'
from @thongke a inner join DEAN b on a.Mada =b.MADA

--Bài 1/3
use QLDA

select PHG, convert(decimal(15,2), AVG(luong),1)
	from NHANVIEN
	group by PHG;

select PHG, FORMAT(convert(decimal(15,2), AVG(luong),1), 'N', 'vi-VN')
	from NHANVIEN
	group by PHG;

--Bài 1/4
use QLDA
select PHG, convert(varchar(50),cast( AVG(luong) as money),1)
	from NHANVIEN
	group by PHG;

--Bài 2/1
select a.MADA, b.TENDA,
	sum(thoigian) as 'tổng số giờ làm việc',
	ceiling(sum(thoigian)) as 'tổng số giờ làm việc - ceiling',
	floor(sum(thoigian)) as 'tổng số giờ làm việc - floor',
	round(sum(thoigian),2) as 'tổng số giờ làm việc - round'
	from PHANCONG a inner join DEAN b on a.MADA=b.MADA
	group by a.MADA, b.TENDA;

--Bài 2/2
select HONV, TENLOT, TENNV, round(LUONG,2) as 'lương' from NHANVIEN 
where luong >( select round(AVG(luong),2) from NHANVIEN
where PHG in (select MAPHG from PHONGBAN where TENPHG = N'Nghiên cứu'));

--Bài 3/1
select 
	UPPER (HONV),
	LOWER(TENLOT), tennv,
	lower(left(TENNV,1)) + upper (SUBSTRING(TENNV,2,1)) + lower(SUBSTRING (TENNV,3, LEN(tennv))),
	dchi,
	CHARINDEX(' ', DCHI),
	CHARINDEX(',', dchi),
	SUBSTRING(dchi, CHARINDEX(' ', DCHI) +1, CHARINDEX(',',dchi) - CHARINDEX(' ', dchi)-1)
	from NHANVIEN;

--Bài 3/2
declare @thongke table (MaP int, MaNVTP int, TK int);

insert into @thongke
	select phg, ma_nql, count(manv) from NHANVIEN group by PHG, MA_NQL;

declare @max int;
select @max= max(tk) from @thongke;

select TENPHG, HONV + ' ' + TENLOT + ' ' +TENNV, HONV+ ' ' + TENLOT + ' Fpoly'
from PHONGBAN a inner join(
select * from @thongke where tk = @max) b on a.MAPHG = b.MaP
inner join NHANVIEN C on c.MANV = b.MaNVTP;

--Bài 4/1
select * from NHANVIEN where DATENAME(year, ngsinh)>= 1960 and DATENAME(year, ngsinh)<=1965

--Bài 4/2
select a.*,DATEDIFF(year, ngsinh, getdate())+1 as Age from NHANVIEN a;

--Bài 4/3
select a.*,DATENAME(weekday, ngsinh) from NHANVIEN a;

--Bài 4/4
select a.TRPHG,
	c.HONV+' ' + c.TENLOT+ ' ' +c.TENNV,
	convert(varchar, a.NG_NHANCHUC, 105), b.SL - 1
from PHONGBAN A inner join
( select PHG, count(manv) as SL from NHANVIEN group by PHG) b on a.MAPHG = b.PHG
inner join NHANVIEN c on a.TRPHG = c.MANV;
