USE [QPTreasureDB]
GO

----------------------------------------------------------------------
-----------Stored Procedure
-----------统计数据 - 金币消耗
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('p_Report_GetAllSum')=id AND xtype='P')
	DROP PROC p_Report_GetAllSum
GO
CREATE PROC p_Report_GetAllSum
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@byUserID INT,
	@userType VARCHAR(10),
	@pageIndex INT=1,
	@pageSize INT=20
AS

BEGIN
	DECLARE @SQL NVARCHAR(MAX)=''
	DECLARE @Where NVARCHAR(1000)=''
	DECLARE @dateWhere NVARCHAR(1000)=''

	-- 属性设置
	SET NOCOUNT ON;	

	DECLARE @GoldWaste BIGINT					--在线人数
	DECLARE @Recharge BIGINT					--在线人数
	DECLARE @OnlineRecharge BIGINT					--在线人数
	DECLARE @CardRecharge BIGINT					--在线人数
	DECLARE @ReceiptGold BIGINT					--在线人数
	DECLARE @GiftGold BIGINT					--在线人数
	DECLARE @AddGamerCount BIGINT					--在线人数

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

	IF(@startDate<>'')
	BEGIN
		SET @dateWhere=@dateWhere+' AND #pre#.#datecol#>='''+@startDate+''''
	END
	IF(@endDate<>'')
	BEGIN
		SET @dateWhere=@dateWhere+'	AND #pre#.#datecol#<='''+@endDate+''''
	END


	--金币消耗
	SET @SQL=N'
	SELECT @GoldWaste=SUM(s.ChangeScore)
	FROM [QPRecordDB].[dbo].[RecordRichChange](NOLOCK) s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.UserID=a.UserID
	WHERE 1=1 AND s.Reason IN (0,1)
'	+@Where+REPLACE(REPLACE(@dateWhere,'#datecol#','LastTime'),'#pre#','s')
	EXEC sp_executesql @SQL	, N'@GoldWaste BIGINT out'	, @GoldWaste OUT



	--充值统计 在线充值金额 实卡充值金额
	SET @SQL=N'
	SELECT @Recharge=SUM(IsNull(s.PayAmount,0))
	,@OnlineRecharge=SUM(CASE WHEN SerialID IS NULL THEN s.PayAmount ELSE 0 END)
	,@CardRecharge=SUM(CASE WHEN SerialID IS NOT NULL THEN s.PayAmount ELSE 0 END)
	FROM dbo.ShareDetailInfo(NOLOCK) s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	WHERE 1=1
'	+@Where+REPLACE(@dateWhere,'#datecol#','ApplyDate')
	EXEC sp_executesql @SQL	, N'@Recharge BIGINT out,@OnlineRecharge BIGINT out,@CardRecharge BIGINT out', @Recharge OUT,@OnlineRecharge OUT,@CardRecharge OUT

	-- 被赠金币
	SET @SQL=N'
	SELECT @ReceiptGold=SUM(s.AddGold)
 	FROM QPRecordDB.dbo.RecordGrantTreasure s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON s.UserID=a.UserID
	WHERE 1=1
'	+@Where+REPLACE(REPLACE(@dateWhere,'#datecol#','CollectDate'),'#pre#','s')
	EXEC sp_executesql @SQL	, N'@ReceiptGold BIGINT out'	, @ReceiptGold OUT

	-- 赠送金币
	SET @SQL=N'
	SELECT @GiftGold=SUM(s.AddGold)
	FROM QPRecordDB.dbo.RecordGrantTreasure s
	INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.SendUserID=a.UserID
	WHERE 1=1
'	+@Where+REPLACE(REPLACE(@dateWhere,'#datecol#','CollectDate'),'#pre#','s')
	EXEC sp_executesql @SQL	, N'@GiftGold BIGINT out'	, @GiftGold OUT

	--新增玩家
	SET @SQL=N'
	SELECT @AddGamerCount=Count(1) FROM QPAccountsDB.dbo.AccountsInfo a 
	WHERE a.IsAndroid=0
'	+@Where+REPLACE(REPLACE(@dateWhere,'#datecol#','RegisterDate'),'#pre#','a')
	EXEC sp_executesql @SQL	, N'@AddGamerCount BIGINT out'	, @AddGamerCount OUT

	SELECT totalCount=1

	SELECT IsNull(@GoldWaste,0)			GoldWaste				,
		   IsNull(@Recharge,0)			RechargeAmount			,	
		   IsNull(@OnlineRecharge,0)		OnlineRechargeAmount	,
		   IsNull(@CardRecharge,0)		CardRechargeAmount		,
		   IsNull(@ReceiptGold,0)			ReceiptGold				,
		   IsNull(@GiftGold,0)			GiftGold				,
		   IsNull(@AddGamerCount,0)		NewGamerCount			
END

GO
