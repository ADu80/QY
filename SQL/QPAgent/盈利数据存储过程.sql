USE [QPTreasureDB]
GO
--USE [QPRecordDB]
--GO

 
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_GamesProfit')=id AND type='P')
	DROP PROC WEB_LIST_GamesProfit
GO

CREATE  PROC  [dbo].[WEB_LIST_GamesProfit]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@ServerID INT,
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @SQL2 VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)='' 
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
   IF @ServerID<>'-1'
	    SET @Where=@Where+' AND ServerID  ='+Convert(VARCHAR(30),@ServerID)

	IF @startDate<>''
		SET @Where=@Where+' AND ConcludeTime >= '''+@startDate+' 00:00:00'''
	IF @endDate<>''
		SET @Where=@Where+' AND ConcludeTime < '''+@endDate+'  23:59:59'''

 

		SET @SQL='with tmp as (SELECT  [ServerID]    ,sum([Waste]) as Waste   ,sum([Revenue]) as Revenue 
  FROM [QPTreasureDB].[dbo].[RecordDrawInfo] 
  where 1=1  '+@Where+'
  group by ServerID ),tmp2 as (
  select c.* , s.ServerName, g.GameName from tmp c
  left join [QPPlatformDB].[dbo].[GameRoomInfo] s on s.ServerID= c.ServerID
  left join [QPPlatformDB].[dbo].[GameGameItem] g on g.GameID= s.GameID)
  ,tmp3 as (select Waste,Revenue,ServerName+''-''+GameName as showname, ROW_NUMBER() OVER(ORDER BY Waste DESC) as RowNo from tmp2)
  select * into '+@tempTable+' from tmp3
  SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
  select * from '+@tempTable+' 
  WHERE LEN(showname)>0 AND  RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
  ORDER BY Waste  DESC
  DROP TABLE '+@tempTable
  	


	SET @SQL2='with tmp as (SELECT  [ServerID]    ,sum([Waste]) as Waste   ,sum([Revenue]) as Revenue 
  FROM [QPTreasureDB].[dbo].[RecordDrawInfo] 
  where 1=1  '+@Where+'
  group by ServerID ),tmp2 as (
  select c.* , s.ServerName, g.GameName from tmp c
  left join [QPPlatformDB].[dbo].[GameRoomInfo] s on s.ServerID= c.ServerID
  left join [QPPlatformDB].[dbo].[GameGameItem] g on g.GameID= s.GameID)
  ,tmp3 as (select Waste,Revenue,ServerName+''-''+GameName as showname,  GameName , ROW_NUMBER() OVER(ORDER BY Waste DESC) as RowNo from tmp2 )
  select sum([Waste]) as Waste   ,sum([Revenue]) as Revenue , GameName     into '+@tempTable+' from tmp3   group by GameName
  SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
  select * from '+@tempTable+' 
  WHERE LEN(GameName)>0  
  ORDER BY Waste  DESC
  DROP TABLE '+@tempTable
	 
	EXEC(@SQL)
	EXEC(@SQL2)
END
GO

------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_GamesProfit_Day')=id AND type='P')
	DROP PROC WEB_LIST_GamesProfit_Day
GO
CREATE  PROC  [dbo].[WEB_LIST_GamesProfit_Day]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@ServerID INT,
	@pageIndex INT=1,
	@pageSize INT=2000
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
   IF @ServerID<>'-1'
	    SET @Where=@Where+' AND ServerID  ='+Convert(VARCHAR(30),@ServerID)

	IF @startDate<>''
		SET @Where=@Where+' AND ConcludeTime >= '''+@startDate+'  00:00:00'''
	IF @endDate<>''
		SET @Where=@Where+' AND ConcludeTime <= '''+@endDate+'  23:59:59'''

		SET @SQL='with tmp as (SELECT  sum([Waste]) as Waste  , Day(ConcludeTime) as itemname ,  ROW_NUMBER() OVER(ORDER BY Day(ConcludeTime) DESC) as RowNo 
		FROM [QPTreasureDB].[dbo].[RecordDrawInfo] 
		where 1=1  '+@Where+'
		group by  Day(ConcludeTime))

		select * into '+@tempTable+' from tmp 
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		WHERE   RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
		ORDER BY RowNo  DESC
		DROP TABLE '+@tempTable
  	
	 
	EXEC(@SQL)
END
GO


---------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_GamesProfit_Hour')=id AND type='P')
	DROP PROC WEB_LIST_GamesProfit_Hour
GO
CREATE  PROC  [dbo].[WEB_LIST_GamesProfit_Hour]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@ServerID INT,
	@pageIndex INT=1,
	@pageSize INT=2000
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
   IF @ServerID<>'-1'
	    SET @Where=@Where+' AND ServerID  ='+Convert(VARCHAR(30),@ServerID)

	IF @startDate<>''
		SET @Where=@Where+' AND ConcludeTime >= '''+@startDate+' 00:00:00'''
	IF @endDate<>''
		SET @Where=@Where+' AND ConcludeTime <= '''+@endDate+'  23:59:59'''

		SET @SQL='with tmp as (SELECT  sum([Waste]) as Waste  , DATEPART(hh,ConcludeTime) as itemname
		,  ROW_NUMBER() OVER(ORDER BY DATEPART(hh,ConcludeTime) DESC) as RowNo 
		FROM [QPTreasureDB].[dbo].[RecordDrawInfo] 
		where 1=1  '+@Where+'
		group by   DATEPART(hh,ConcludeTime)) 

		select * into '+@tempTable+' from tmp
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		WHERE  RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
		ORDER BY RowNo  DESC
		DROP TABLE '+@tempTable
  	
	 
	EXEC(@SQL)
END
GO

---------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_GamesProfit_Month')=id AND type='P')
	DROP PROC WEB_LIST_GamesProfit_Month
GO
CREATE  PROC  [dbo].[WEB_LIST_GamesProfit_Month]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@ServerID INT,
	@pageIndex INT=1,
	@pageSize INT=2000
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
   IF @ServerID<>'-1'
	    SET @Where=@Where+' AND ServerID  ='+Convert(VARCHAR(30),@ServerID)

	IF @startDate<>''
		SET @Where=@Where+' AND ConcludeTime >= '''+@startDate+'  00:00:00'''
	IF @endDate<>''
		SET @Where=@Where+' AND ConcludeTime <= '''+@endDate+'  23:59:59'''

		SET @SQL='with tmp as (SELECT   sum([Waste]) as Waste  , Month(ConcludeTime) as itemname, ROW_NUMBER() OVER(ORDER BY Month(ConcludeTime) DESC) as RowNo
		FROM [QPTreasureDB].[dbo].[RecordDrawInfo] 
		where 1=1  '+@Where+'
		group by  Month(ConcludeTime)) 

		select * into '+@tempTable+' from tmp 
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		WHERE   RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
		ORDER BY RowNo  DESC
		DROP TABLE '+@tempTable
  	
	 
	EXEC(@SQL)
END
GO


---------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_GamesProfit_Year')=id AND type='P')
	DROP PROC WEB_LIST_GamesProfit_Year
GO
CREATE  PROC  [dbo].[WEB_LIST_GamesProfit_Year]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@ServerID INT,
	@pageIndex INT=1,
	@pageSize INT=2000
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
   IF @ServerID<>'-1'
	    SET @Where=@Where+' AND ServerID  ='+Convert(VARCHAR(30),@ServerID)

	IF @startDate<>''
		SET @Where=@Where+' AND ConcludeTime >= '''+@startDate+' '''
	IF @endDate<>''
		SET @Where=@Where+' AND ConcludeTime < '''+@endDate+' '''

		SET @SQL='with tmp as (SELECT   sum([Waste]) as Waste  , year(ConcludeTime) as itemname, ROW_NUMBER() OVER(ORDER BY year(ConcludeTime) DESC) as RowNo
		FROM [QPTreasureDB].[dbo].[RecordDrawInfo] 
		where 1=1  '+@Where+'
		group by  year(ConcludeTime)) 

		select * into '+@tempTable+' from tmp 
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		WHERE   RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
		ORDER BY RowNo  DESC
		DROP TABLE '+@tempTable
  	
	 
	EXEC(@SQL)
END
GO


---------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_LIST_UserProfit_ALL')=id AND type='P')
	DROP PROC WEB_LIST_UserProfit_ALL
GO

CREATE  PROC  [dbo].[WEB_LIST_UserProfit_ALL]
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@DaType INT,
	@SerTxt NVARCHAR(50),
	@SerType INT 
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	DECLARE @MyUserID INT
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
	IF(@SerType=1)--按userid
	BEGIN
	    SET @Where=@Where+' AND UserID  ='+Convert(VARCHAR(30),@SerTxt)
	END

	IF(@SerType=2)--按gameID 
	BEGIN  
        select @MyUserID =UserID from  [QPAccountsDB].[dbo].[AccountsInfo]  where GameID = @SerTxt
	    SET @Where=@Where+' AND UserID  ='+Convert(VARCHAR(30),@MyUserID)
	END

	IF(@SerType=3)--按accounts
	BEGIN  
         select @MyUserID =UserID from  [QPAccountsDB].[dbo].[AccountsInfo]  where Accounts = @SerTxt
	    SET @Where=@Where+' AND UserID ='+Convert(VARCHAR(30),@MyUserID)
	END

	IF(@DaType=1)--每月
	BEGIN
	IF @startDate<>''
		SET @Where=@Where+' AND LastTime >= '''+@startDate+' '''
	IF @endDate<>''
		SET @Where=@Where+' AND LastTime < '''+@endDate+' '''

		SET @SQL='with tmp as (SELECT   sum(ChangeScore) as Waste , Month(LastTime) as itemname 
		FROM [QPRecordDB].[dbo].[RecordRichChange]
		where 1=1  AND Reason in (0,1) '+@Where+'
		group by  Month(LastTime)) 

		select * into '+@tempTable+' from tmp 
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		 
		DROP TABLE '+@tempTable
	EXEC(@SQL)
	END 


	IF(@DaType=2)--每天
	BEGIN
	IF @startDate<>''
		SET @Where=@Where+' AND LastTime >= '''+@startDate+' '''
	IF @endDate<>''
		SET @Where=@Where+' AND LastTime < '''+@endDate+' '''

		SET @SQL='with tmp as (SELECT   sum(ChangeScore) as Waste , Day(LastTime) as itemname 
		FROM [QPRecordDB].[dbo].[RecordRichChange]
		where 1=1  AND Reason in (0,1) '+@Where+'
		group by  Day(LastTime)) 

		select * into '+@tempTable+' from tmp 
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		 
		DROP TABLE '+@tempTable
	EXEC(@SQL)
	END 


	IF(@DaType=3)--每小时
	BEGIN
	IF @startDate<>''
		SET @Where=@Where+' AND LastTime >= '''+@startDate+' 00:00:00'''
	IF @endDate<>''
		SET @Where=@Where+' AND LastTime <= '''+@endDate+' 23:59:59'''

		SET @SQL='with tmp as (SELECT   sum(ChangeScore) as Waste ,  DATEPART(hh,LastTime) as itemname 
		FROM [QPRecordDB].[dbo].[RecordRichChange]
		where 1=1 AND Reason in (0,1) '+@Where+'
		group by   DATEPART(hh,LastTime)) 

		select * into '+@tempTable+' from tmp 
		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		 
		DROP TABLE '+@tempTable
	EXEC(@SQL)
	END 

END
GO



-----------------------------------------------------------------玩家盈利排行----------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetProfit')=id AND type='P')
	DROP PROC p_Report_GetProfit
GO 
CREATE PROC [dbo].[p_Report_GetProfit] 
	@KindID INT, 
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件 
	IF @KindID<>-1
	BEGIN 
			SET @Where=@Where+' AND KindID='+Convert(VARCHAR(30),@KindID)
	END 
	 
	IF @startDate<>''
		SET @Where=@Where+' AND LastTime >= '''+@startDate+' 00:00:00'''
	IF @endDate<>''
		SET @Where=@Where+' AND LastTime < '''+@endDate+'  23:59:59'''



	--玩家盈利
	SET @SQL=' select top 100 d.*, a.GameID ,a.Accounts , a.NickName, case when LEN(gonline.ServerID)>0 then ''<span style=color:blue>在线</span>'' ELSE ''<span style=color:red>离线</span>'' END as gameonline,   ROW_NUMBER() OVER(ORDER BY d.profit DESC) RowNo
	INTO '+@tempTable+' from (select UserID ,sum(ChangeScore) as Profit
	FROM [QPRecordDB].[dbo].[RecordRichChange]  
	WHERE 1=1  and Reason IN (0,1) '	+@Where + ' 
	group by UserID   )d  
	left join [QPAccountsDB].[dbo].[AccountsInfo] a on a.UserID = d.UserID
	left join  [QPTreasureDB].[dbo].[GameScoreLocker] gonline on gonline.UserID = d.UserID
	order by d.profit desc
	SELECT totalCount=Count(1) FROM '+ @tempTable + '
	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable
   
	EXEC(@SQL)
END
go

use [QPRecordDB]
go
------------------------------------------赠送钻石记录 
 IF  EXISTS(SELECT 1 FROM sys.views WHERE name='vw_RecordGrantDiamond')
 DROP　VIEW [vw_RecordGrantDiamond]
 GO
 
CREATE VIEW [dbo].[vw_RecordGrantDiamond]
AS
SELECT  QPAccountsDB.dbo.AccountsInfo.Accounts, QPAccountsDB.dbo.AccountsInfo.NickName, 
                   QPAccountsDB.dbo.AccountsInfo.GameID, dbo.RecordGrantDiamond.MasterID, dbo.RecordGrantDiamond.ClientIP, 
                   dbo.RecordGrantDiamond.CollectDate, dbo.RecordGrantDiamond.UserID, dbo.RecordGrantDiamond.CurRDiamond, 
                   dbo.RecordGrantDiamond.RDiamond, dbo.RecordGrantDiamond.Reason, dbo.RecordGrantDiamond.SendUserID
FROM      dbo.RecordGrantDiamond INNER JOIN
                   QPAccountsDB.dbo.AccountsInfo ON dbo.RecordGrantDiamond.UserID = QPAccountsDB.dbo.AccountsInfo.UserID

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "RecordGrantDiamond"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AccountsInfo (QPAccountsDB.dbo)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 145
               Right = 448
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_RecordGrantDiamond'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_RecordGrantDiamond'
GO



------------------------------------------赠送房卡记录 
 IF  EXISTS(SELECT 1 FROM sys.views WHERE name='vw_RecordGrantCard')
 DROP　VIEW [vw_RecordGrantCard]
 GO

 
CREATE VIEW [dbo].[vw_RecordGrantCard]
AS
SELECT  QPAccountsDB.dbo.AccountsInfo.Accounts, QPAccountsDB.dbo.AccountsInfo.NickName, 
                   QPAccountsDB.dbo.AccountsInfo.GameID, dbo.RecordGrantRCard.MasterID, dbo.RecordGrantRCard.ClientIP, 
                   dbo.RecordGrantRCard.CollectDate, dbo.RecordGrantRCard.UserID, dbo.RecordGrantRCard.CurRCard, 
                   dbo.RecordGrantRCard.RCard, dbo.RecordGrantRCard.Reason, dbo.RecordGrantRCard.SendUserID
FROM      dbo.RecordGrantRCard INNER JOIN
                   QPAccountsDB.dbo.AccountsInfo ON dbo.RecordGrantRCard.UserID = QPAccountsDB.dbo.AccountsInfo.UserID

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "RecordGrantRCard"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 145
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AccountsInfo (QPAccountsDB.dbo)"
            Begin Extent = 
               Top = 6
               Left = 234
               Bottom = 145
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_RecordGrantCard'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_RecordGrantCard'
GO




use [QPTreasureDB]
go

  
---新增玩家数据分析------------------------------------------------------------------------------------------------------
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


 
--------------------------------------------------------------实时在线人数-------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('UserData_LIST_OnlineUser')=id AND type='P')
	DROP PROC UserData_LIST_OnlineUser
GO
CREATE  PROC  [dbo].[UserData_LIST_OnlineUser]
	@kindID INT 
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
   
		SET @SQL=' ;with tmp as (SELECT*  FROM [QPPlatformDB].[dbo].[OnLineStreamInfo]  e CROSS APPLY  [QPPlatformManagerDB].[dbo].[f_splitStr](e.OnLineCountKind,'';'') ) 
		 ,  tmpaaa as( select a.* , case  when CHARINDEX ('':'',stuff(a.col ,1,charindex('':'',a.col ),''''))>0 then convert(int,substring(stuff(a.col,1,charindex('':'',a.col),''''),1,charindex('':'',stuff(a.col,1,charindex('':'',a.col),''''))-1)) else convert(int,stuff(a.col ,1,charindex('':'',a.col ),'''')) end    zhenrenshu  
 		,convert(int,stuff(stuff(a.col,1,charindex('':'',a.col),''''),1,charindex('':'',stuff(a.col,1,charindex('':'',a.col),'''')),''''))  jiqirenshu 
		 ,substring(a.col,0,charindex('':'',a.col))  KindId from tmp a   
		where InsertDateTime = (select top 1 InsertDateTime from [QPPlatformDB].[dbo].[OnLineStreamInfo] order by InsertDateTime desc)) 
		select    aaa.zhenrenshu, aaa.jiqirenshu, aaa.InsertDateTime , aaa.KindId,    bbb.KindName into '+@tempTable+'  from tmpaaa  aaa
 		left join [QPPlatformDB].[dbo].[GameKindItem] bbb on bbb.KindID= aaa.KindId
 		where LEN(aaa.KindId)>0 order by aaa.InsertDateTime desc 

     	SELECT totalCount=Count(1) FROM '+@tempTable+' 
		select * from '+@tempTable+'  
		drop table '+@tempTable
	 
	EXEC(@SQL)
END
GO

use [QPPlatformDB]
go
--------------------------------------------------------------WhiteList-------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_GetWhiteList')=id AND type='P')
	DROP PROC p_GetWhiteList
GO
create PROC [dbo].[p_GetWhiteList]
	@keyword VARCHAR(100),
	@pageIndex INT,
	@pageSize INT
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(MAX)=''
	DECLARE @tempTable VARCHAR(50)=''
	IF @keyword<>''
		SET @Where=' AND a.GameID ='+Convert(VARCHAR(30),@keyword)

	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
	SET @SQL='
	SELECT a.*,b.Accounts, b.NickName, ROW_NUMBER() OVER(ORDER BY a.InsertTime DESC) AS RowNo INTO '+@tempTable+' FROM  [QPPlatformDB].[dbo].[WhiteList] a
	LEFT JOIN [QPAccountsDB].[dbo].[AccountsInfo] b on b.GameID =a.GameID
	WHERE 1=1 
	'+@Where+'

	SELECT totalCount=Count(1) FROM '+@tempTable+'

	SELECT * FROM '+@tempTable+' 	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)

	EXEC(@SQL)
END
go

--------------------------------------------------------------add WhiteList-------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_OperWhiteList')=id AND type='P')
	DROP PROC p_OperWhiteList
GO
Create PROC [dbo].[p_OperWhiteList]
	@GameID INT ,
	@WID INT ,--delete --editt
	@eType INT ,--0 add 1del 2edit
	@wDes INT OUTPUT
AS
BEGIN
     DECLARE @orgGameID INT
     IF @eType=0--add
	 BEGIN
     IF   EXISTS (select 1 from [QPPlatformDB].[dbo].[WhiteList] where GameID =@GameID)
	 BEGIN 
	 set @wDes=-1--玩家已经在列表[WhiteList]
	 return
	 END 
	 ELSE 
	 BEGIN
	 IF  NOT EXISTS (select 1 from  [QPAccountsDB].[dbo].[AccountsInfo] where GameID =@GameID)
	 BEGIN 
	 set @wDes=-2--玩家不存在[AccountsInfo]
	 return 
	 END 

	 INSERT INTO [QPPlatformDB].[dbo].[WhiteList] (GameID,InsertTime) VALUES(@GameID,GETDATE()) 
	 IF EXISTS (select 1 from QPAccountsDB.dbo.UserFriend where GameID =@GameID)
	 BEGIN 

	 UPDATE QPAccountsDB.dbo.UserFriend SET UserRight =1 where GameID =@GameID
	 END

	 set @wDes=0

	 END
	 END

	 IF @eType=1--delete
	 BEGIN
	 IF  NOT  EXISTS (select 1 from [QPPlatformDB].[dbo].[WhiteList] where  WID =@WID)
	 BEGIN 
	 set @wDes=-1
	 return 
	 END 
	 ELSE 
	 BEGIN
	 
	 SELECT @orgGameID=GameID from [QPPlatformDB].[dbo].[WhiteList] where  WID =@WID
	 DELETE FROM [QPPlatformDB].[dbo].[WhiteList] where  WID =@WID

	 IF EXISTS (select 1 from QPAccountsDB.dbo.UserFriend where GameID =@orgGameID)
	 BEGIN  
	 UPDATE QPAccountsDB.dbo.UserFriend SET UserRight =NULL where GameID =@orgGameID
	 END

	 set @wDes=0
	 END
	 END

	 IF @eType=2--edit
	 BEGIN
	  IF NOT EXISTS (select 1 from [QPPlatformDB].[dbo].[WhiteList] where  WID =@WID)
	 BEGIN 
	 set @wDes=-1
	 return 
	 END 
	 ELSE 
	 BEGIN
	 IF  NOT EXISTS (select 1 from  [QPAccountsDB].[dbo].[AccountsInfo] where GameID =@GameID)
	 BEGIN 
	 set @wDes=-2--玩家不存在[AccountsInfo]
	 return 
	 END 

	 SELECT @orgGameID=GameID from [QPPlatformDB].[dbo].[WhiteList] where  WID =@WID
	 
	 UPDATE [QPPlatformDB].[dbo].[WhiteList] SET GameID=@GameID where WID =@WID

	 
	 IF EXISTS (select 1 from QPAccountsDB.dbo.UserFriend where GameID =@orgGameID)
	 BEGIN  
	 UPDATE QPAccountsDB.dbo.UserFriend SET UserRight =NULL where GameID =@orgGameID
	 END

	 IF EXISTS (select 1 from QPAccountsDB.dbo.UserFriend where GameID =@GameID)
	 BEGIN  
	 UPDATE QPAccountsDB.dbo.UserFriend SET UserRight =1 where GameID =@GameID
	 END

	 set @wDes=0
	 END
	 END
END
go

use [QPAccountsDB]
go
--------------------------------------------------------------设置代理-------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('WEB_AccountsSetAgent')=id AND type='P')
	DROP PROC WEB_AccountsSetAgent
GO
CREATE PROC [dbo].[WEB_AccountsSetAgent]
	@UserID INT,
	@myRoleID INT,
	@myGradeID INT
AS
BEGIN
    IF EXISTS(SELECT UserID FROM AccountsInfo WHERE UserID=@UserID AND AgentID IS NULL AND AgentPath IS NULL AND (IsAgent IS NULL OR IsAgent=0))
	BEGIN
		DECLARE @RoleID INT
		DECLARE @Username VARCHAR(30)
		DECLARE @Password VARCHAR(32)
		UPDATE AccountsInfo SET AgentID=0,AgentPath=CONVERT(VARCHAR,@UserID),IsAgent=1 WHERE UserID = @UserID AND AgentID IS NULL AND AgentPath IS NULL AND (IsAgent IS NULL OR IsAgent=0)
		SELECT @Username=Accounts,@Password=LogonPass FROM AccountsInfo whEre UserID = @UserID
		--SELECT @RoleID=RoleID FROM QPPlatformManagerDB.dbo.Base_Roles WHERE AgentLevel=1
		INSERT INTO QPPlatformManagerDB.dbo.Base_Users(Username,[Password],RoleID,AgentID,[GradeID]) VALUES(@Username,@Password,@myRoleID,@UserID,@myGradeID)
	END
	ELSE
	BEGIN
	UPDATE QPPlatformManagerDB.dbo.Base_Users
	SET RoleID=@myRoleID,GradeID=@myGradeID
	WHERE AgentID=@UserID
	END
END
GO

use [QPTreasureDB]
go
-------------------------------------------------在线用户--------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('UserData_LIST_RealOnline')=id AND type='P')
	DROP PROC UserData_LIST_RealOnline
GO
CREATE  PROC  [dbo].[UserData_LIST_RealOnline]
	@GameID INT,  
	@ServerID INT,
	@SerTxt NVARCHAR(50),
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
  
   IF @ServerID<>'-1'
	    SET @Where=@Where+' AND a.ServerID  ='+Convert(VARCHAR(30),@ServerID)

   
   IF @GameID<>''
	    SET @Where=@Where+' AND b.GameID  ='+Convert(VARCHAR(30),@GameID)
 
    
   IF @SerTxt<>''
	    SET @Where=@Where+' AND b.Accounts  LIKE ''%'+@SerTxt+'%''' 

   
	 

		SET @SQL=' select a.*, b.GameID,b.Accounts ,b.NickName, k.GameName , s.ServerName, STR(CAST(DATEDIFF(SECOND,a.CollectDate,GETDATE()) as float)/60,6,2) as RetentionMinute,  ROW_NUMBER() OVER(ORDER BY year(a.UserID) DESC) as RowNo 
		into '+@tempTable+'
		FROM [QPTreasureDB].[dbo].[GameScoreLocker] a 
 		left join [QPAccountsDB].[dbo].[AccountsInfo] b on a.UserID =b.UserID
 		left join [QPPlatformDB].[dbo].[GameGameItem] k on k.GameID =a.KindID
 		left join [QPPlatformDB].[dbo].[GameRoomInfo] s on s.ServerID =a.ServerID
        where 1=1  '+@Where+'  

		SELECT totalCount=Count(1) FROM '+@tempTable+'  
  
		select * from '+@tempTable+' 
		WHERE   RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
		ORDER BY RowNo  DESC
		DROP TABLE '+@tempTable
  	
	 
	EXEC(@SQL)
END
GO