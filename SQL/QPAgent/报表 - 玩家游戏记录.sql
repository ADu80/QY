USE QPTreasureDB
GO

-----------统计数据 - 充值记录
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetPlayGame')=id AND xtype='P')
	DROP PROC p_Report_GetPlayGame
GO
CREATE PROC p_Report_GetPlayGame
	@Accounts VARCHAR(30),
	@GameID INT,
	@RoomID INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@byUserID INT,
	@userType VARCHAR(10),
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)
	DECLARE @Where VARCHAR(1000)
	DECLARE @tempTable VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件
	SET @Where=''
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@byUserID)

	IF @userType='agent' 
	BEGIN
		SET @Where=@Where+' AND ((a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+')) OR (a.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+')))'
	END
	ELSE IF @userType='gamer'
	BEGIN	
		SET @Where=@Where+' AND a.UserID='+Convert(VARCHAR(30),@byUserID)
	END

	IF @Accounts<>''
		SET @Where=@Where+' AND a.Accounts LIKE ''%'+@Accounts+'%'''
	IF @GameID<>-1
		SET @Where=@Where+' AND s.KindID='+CONVERT(VARCHAR(30),@GameID)
	IF @RoomID<>-1
		SET @Where=@Where+' AND s.ServerID='+CONVERT(VARCHAR(30),@RoomID)
	IF @startDate<>''
		SET @Where=@Where+' AND s.InsertTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND s.InsertTime < '''+@endDate+' 23:59:59'''

	--玩家游戏记录
	SET @SQL='
	SELECT DISTINCT s.InsertTime RecordTime,r.ServerName Room,''服务'' PointsType,a.Accounts,IsNull(ag.Accounts,''admin'') Agent
		,IsNull(sd.Score,0) WinGold,IsNull(sd.Revenue,0) Revenue,s.StartTime StartDate,s.ConcludeTime EndDate
		,g.GameName Game,s.TableID DeskID,sd.ChairID,ROW_NUMBER() OVER(ORDER BY s.InsertTime DESC) RowNo,s.DrawID
	INTO '+@tempTable+'
	FROM [dbo].[RecordDrawInfo](NOLOCK) s
	INNER JOIN dbo.RecordDrawScore sd ON s.DrawID=sd.DrawID
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND sd.UserID=a.UserID
	LEFT JOIN QPAccountsDB.dbo.AccountsInfo ag ON a.AgentID=ag.UserID
	INNER JOIN [QPPlatformDB].[dbo].[GameRoomInfo] r ON s.ServerID=r.ServerID AND s.KindID=r.GameID
	INNER JOIN [QPPlatformDB].[dbo].[GameGameItem] g ON s.KindID=g.GameID
	WHERE 1=1
'
	SET @SQL=@SQL+@Where
	SET @SQL = @SQL + '
	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNo
	DROP TABLE '+@tempTable

	--SELECT @SQL
	EXEC(@SQL)
END

GO


