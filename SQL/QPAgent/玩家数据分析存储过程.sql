USE [QPTreasureDB]
GO
   
---------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('UserData_LIST_NewUser')=id AND type='P')
	DROP PROC UserData_LIST_NewUser
GO

CREATE  PROC  [dbo].[UserData_LIST_NewUser]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@DaType INT 
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	DECLARE @MyUserID INT
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
	 

	IF(@DaType=1)--每月
	BEGIN
	IF @startDate<>''
		SET @Where=@Where+' AND a.RegisterDate >= '''+@startDate+' '''
	IF @endDate<>''
		SET @Where=@Where+' AND a.RegisterDate < '''+@endDate+' '''

		SET @SQL='with tmp as (SELECT   count(a.UserID) as shuliang, Month(a.RegisterDate) as itemname ,  ROW_NUMBER() OVER(ORDER BY Month(a.RegisterDate) DESC) as RowNo 
        FROM   [QPAccountsDB].[dbo].[AccountsInfo] a  
		where  a.IsAndroid=0 '+@Where+' 
		group by   Month(a.RegisterDate) )  
		select * into '+@tempTable+' from tmp
		SELECT totalCount=Count(1) FROM '+@tempTable+' 
		select * from '+@tempTable+'  
		drop table '+@tempTable

	EXEC(@SQL)
	END 


	IF(@DaType=2)--每天
	BEGIN
	IF @startDate<>''
		SET @Where=@Where+' AND a.RegisterDate >= '''+@startDate+' '''
	IF @endDate<>''
		SET @Where=@Where+' AND a.RegisterDate < '''+@endDate+' '''
 
		SET @SQL='with tmp as (SELECT   count(a.UserID) as shuliang, day(a.RegisterDate) as itemname ,  ROW_NUMBER() OVER(ORDER BY day(a.RegisterDate) DESC) as RowNo 
        FROM   [QPAccountsDB].[dbo].[AccountsInfo] a  
		where  a.IsAndroid=0 '+@Where+' 
		group by   day(a.RegisterDate) )  
		select * into '+@tempTable+' from tmp
		SELECT totalCount=Count(1) FROM '+@tempTable+' 
		select * from '+@tempTable+'  
		drop table '+@tempTable

	EXEC(@SQL)
	END 

	
	IF(@DaType=3)--每小时
	BEGIN
	IF @startDate<>''
		SET @Where=@Where+' AND a.RegisterDate >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND a.RegisterDate <  DATEADD(DAY,1,'''+@startDate+''') '

		SET @SQL='with tmp as (SELECT   count(a.UserID) as shuliang, DATEPART(hh,a.RegisterDate) as itemname ,  ROW_NUMBER() OVER(ORDER BY DATEPART(hh,a.RegisterDate) DESC) as RowNo 
        FROM   [QPAccountsDB].[dbo].[AccountsInfo] a  
		where  a.IsAndroid=0 '+@Where+' 
		group by   DATEPART(hh,a.RegisterDate) )  
		select * into '+@tempTable+' from tmp
		SELECT totalCount=Count(1) FROM '+@tempTable+' 
		select * from '+@tempTable+'  
		drop table '+@tempTable
		 
	EXEC(@SQL)

	IF(DATEDIFF(DAY,@startDate,GETDATE())=0)
	BEGIN
	select  count(UserID) as shuliang from  [QPAccountsDB].[dbo].[AccountsInfo] where   DATEDIFF(DAY,RegisterDate,GETDATE())=0
	select  count(UserID) as shuliang from  [QPAccountsDB].[dbo].[AccountsInfo] where   DATEDIFF(DAY,RegisterDate,GETDATE())=1
	select  count(UserID) as shuliang from  [QPAccountsDB].[dbo].[AccountsInfo] where   DATEDIFF(WEEK,RegisterDate,GETDATE()) < 1 
	select  count(UserID) as shuliang from  [QPAccountsDB].[dbo].[AccountsInfo] where   DATEDIFF(MONTH,RegisterDate,GETDATE()) < 1
	END

	END 

END
GO


 