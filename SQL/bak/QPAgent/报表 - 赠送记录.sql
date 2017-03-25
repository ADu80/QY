USE QPTreasureDB
GO

-----------统计数据 - 充值记录
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetGift')=id AND xtype='P')
	DROP PROC p_Report_GetGift
GO
CREATE PROC p_Report_GetGift
	@Accounts VARCHAR(30),
	@OperationType INT,
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@byUserID INT,
	@userType VARCHAR(10),
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @Where2 VARCHAR(1000)=''
	--DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	DECLARE @tempTable VARCHAR(50)
	DECLARE @tempTable2 VARCHAR(50)
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')
	SET @tempTable2 = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	--条件
	IF @startDate<>''
		SET @Where=@Where+' AND s.CollectDate >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND s.CollectDate < '''+@endDate+''''
	SET @Where2=@Where
	
	IF @Accounts<>''
	BEGIN
		SET @Where=@Where+' AND a.Accounts LIKE ''%'+@Accounts+'%'''		
		SET @Where2=@Where2+' AND a.UserName LIKE ''%'+@Accounts+'%'''
	END

	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@byUserID)

	IF @userType='agent'
	BEGIN
		IF @OperationType=0 --赠送
		BEGIN
			SET @Where=@Where+' AND (b.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))'
			SET @Where2=@Where2+' AND (b.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))'
		END
		ELSE IF @OperationType=1
		BEGIN
			SET @Where=@Where+' AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.SendUserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))'
			SET @Where2=@Where2+' AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.MasterID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))'
		END
		ELSE
		BEGIN
			--代理赠送直接玩家或下级代理
			SET @Where=@Where+' AND ((b.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))
				OR (a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.SendUserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+')))'
			--平台赠送
			SET @Where2=@Where2+' AND ((b.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.UserID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+'))
				OR (a.AgentID IN ('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+') OR s.MasterID IN('+CONVERT(VARCHAR(30),@byUserID)+','+@AllSubAgentIds+')))'
		END
	END
	ELSE IF @userType='gamer'
	BEGIN
		IF @OperationType=0
		BEGIN
			SET @Where=@Where+' AND s.UserID='+CONVERT(VARCHAR(20),@byUserID)
			SET @Where2=@Where2+' AND s.UserID='+CONVERT(VARCHAR(20),@byUserID)
		END
		ELSE IF @OperationType=1
		BEGIN
			SET @Where=@Where+' AND s.SendUserID='+CONVERT(VARCHAR(20),@byUserID)
			SET @Where2=@Where2+' AND s.MasterID='+CONVERT(VARCHAR(20),@byUserID)
		END
		ELSE
		BEGIN
			SET @Where=@Where+'AND (s.SendUserID='+CONVERT(VARCHAR(20),@byUserID)+' OR s.UserID='+CONVERT(VARCHAR(20),@byUserID)+')'
			SET @Where2=@Where2+'AND (s.MasterID='+CONVERT(VARCHAR(20),@byUserID)+' OR s.UserID='+CONVERT(VARCHAR(20),@byUserID)+')'
		END
	END

	--赠送记录
	SET @SQL='
	CREATE TABLE '+@tempTable+'(
		SendorID INT,
		Sendor VARCHAR(30),
		ReceiptorID INT,
		Receiptor VARCHAR(30),
		GiftGold BIGINT,
		Revenue BIGINT,
		OperateClient VARCHAR(10),
		GiftDate DateTime
	)

	INSERT '+@tempTable+'(SendorID,Sendor,ReceiptorID,Receiptor,GiftGold,Revenue,OperateClient,GiftDate)
	SELECT DISTINCT a.GameID SendorID,a.Accounts Sendor,b.GameID ReceiptorID,b.Accounts Receiptor
		,IsNull(s.AddGold,0) GiftGold,0 Revenue,''PC'' OperateClient,s.CollectDate GiftDate
	FROM QPRecordDB.dbo.RecordGrantTreasure s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo b ON b.IsAndroid=0 AND s.UserID=b.UserID
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.SendUserID=a.UserID
	WHERE s.SendUserID IS NOT NULL
'	+@Where + '
	UNION ALL 
	SELECT DISTINCT s.MasterID SendorID,a.UserName Sendor,b.GameID ReceiptorID,b.Accounts Receiptor
		,IsNull(s.AddGold,0) GiftGold,0 Revenue,''PC'' OperateClient,s.CollectDate GiftDate
	FROM QPRecordDB.dbo.RecordGrantTreasure s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo b ON b.IsAndroid=0 AND s.UserID=b.UserID
	INNER JOIN QPPlatformManagerDB.dbo.Base_Users a ON s.MasterID=a.UserID
	WHERE s.SendUserID IS NULL
'	+@Where2 + '

	SELECT *,ROW_NUMBER() OVER(ORDER BY GiftDate DESC) RowNo INTO '+@tempTable2+' FROM '+@tempTable+'

	SELECT totalCount=Count(1) FROM '+ @tempTable2 + '

	SELECT * FROM ' + @tempTable2 + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNo
	DROP TABLE '+@tempTable+'
	DROP TABLE '+@tempTable2
	
	--SELECT @SQL
	EXEC(@SQL)
END

GO







