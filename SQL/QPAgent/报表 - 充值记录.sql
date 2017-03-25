USE QPTreasureDB
GO

-----------统计数据 - 充值记录
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetRecharge')=id AND xtype='P')
	DROP PROC p_Report_GetRecharge
GO
CREATE PROC p_Report_GetRecharge
	@Accounts VARCHAR(30),
	@Nullity INT,
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
	--代理
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@byUserID)

	IF @userType='agent' 
	BEGIN
		SET @Where=@Where+' AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+')) OR (a.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))'
	END
	ELSE IF @userType='gamer'
	BEGIN	
		SET @Where=@Where+' AND a.UserID='+Convert(VARCHAR(30),@byUserID)
	END

	IF @Accounts<>''
		SET @Where=@Where+' AND a.Accounts LIKE ''%'+@Accounts+'%'''
	IF @Nullity<>-1
		SET @Where=@Where+' AND a.Nullity='+CONVERT(VARCHAR(2),@Nullity)
	IF @startDate<>''
		SET @Where=@Where+' AND s.ApplyDate >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND s.ApplyDate <= '''+@endDate+'  23:59:59'''

	--充值统计
	SET @SQL='
	SELECT DISTINCT s.ApplyDate RechargeDate,s.Accounts
		,IsNull(s.OrderAmount,0) OrderAmount,IsNull(s.PayAmount,0) PayAmount,IsNull(s.CardGold,0) GiftGold
		,ag.Accounts Agent,s.OrderID OrderCode,s.SerialID RechargeCard,ROW_NUMBER() OVER(ORDER BY s.ApplyDate DESC) RowNo
	INTO '+@tempTable+'
	FROM [dbo].[ShareDetailInfo](NOLOCK) s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	INNER JOIN QPAccountsDB.dbo.AccountsInfo ag ON a.AgentID=ag.UserID
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



