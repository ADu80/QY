USE [QPTreasureDB]
GO

----------------------------------------------------------------------
-----------Stored Procedure
-----------统计数据 - 金币消耗
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetGameWaste')=id AND xtype='P')
	DROP PROC p_Report_GetGameWaste
GO
CREATE PROC p_Report_GetGameWaste
	@GameID INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@byUserID INT,
	@userType VARCHAR(10),
	@pageIndex INT=1,
	@pageSize INT=20
AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;	

	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)
	
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件
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

	IF @GameID<>-1
		SET @Where=@Where+' AND s.KindID='+CONVERT(VARCHAR(30),@GameID)
	IF @startDate<>''
		SET @Where=@Where+' AND s.LastTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND s.LastTime < '''+@endDate+''''
		
	--玩家游戏记录
	SET @SQL='
	SELECT g.GameName Game,IsNull(SUM(s.ChangeScore),0) GameWaste,ROW_NUMBER() OVER(ORDER BY g.GameName) RowNo
	INTO '+@tempTable+'
	FROM [QPRecordDB].[dbo].[RecordRichChange](NOLOCK) s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	INNER JOIN [QPPlatformDB].[dbo].[GameGameItem] g ON s.KindID=g.GameID
	WHERE 1=1 AND s.Reason IN (0,1)
'
	SET @SQL=@SQL+@Where
	SET @SQL = @SQL + '
	GROUP BY g.GameName

	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	DROP TABLE '+@tempTable

	--SELECT @SQL
	EXEC(@SQL)


END

GO

