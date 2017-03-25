/********************数据库[QPTreasureDB]*******************/
USE [QPTreasureDB]
GO

--
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameScoreInfo')=id AND name ='RCard')
	ALTER TABLE GameScoreInfo
	ADD RCard BIGINT

GO

--
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameScoreInfo')=id AND name ='Diamond')
	ALTER TABLE GameScoreInfo
	ADD Diamond BIGINT

GO

----------------------------------------------------------------------
-----------Stored Procedure
-----------统计数据 - 代理
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('NET_PM_StatInfo_Agent')=id AND xtype='P')
	DROP PROC NET_PM_StatInfo_Agent
GO
CREATE PROC NET_PM_StatInfo_Agent
	@UserID INT
AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON;	

	--用户统计
	DECLARE @OnLineCount BIGINT					--在线人数
	DECLARE @Recharge BIGINT					--充值金额
	DECLARE @DirectGamerWaste BIGINT			--直接玩家金币消耗
	DECLARE @DirectGamerScore BIGINT			--直接玩家金币库存
	DECLARE @DirectGamerCount BIGINT			--直接玩家人数
	DECLARE @DirectAgentCount BIGINT			--直接代理商数
	DECLARE @AllGamerWaste BIGINT				--全部玩家金币消耗
	DECLARE @AllGamerScore BIGINT				--全部玩家金币库存
	DECLARE @AllGamerCount BIGINT				--全部玩家人数
	DECLARE @AllAgentCount BIGINT				--全部代理商数
	DECLARE @SpreadSum BIGINT

	--条件
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @AllSubAgentIds VARCHAR(300)			--全部子代理商UserID
	SET @AllSubAgentIds=QPPlatformManagerDB.dbo.f_GetChildAgentID(@UserID)	

	--在线人数
	SET @SQL=N'SELECT @OnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s
				INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 
					AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))
					AND s.UserID=a.UserID'
	EXEC sp_executesql @SQL	, N'@OnLineCount BIGINT OUT'	, @OnLineCount OUT
	
	--充值金额
	SELECT @Recharge=SUM(PayAmount) FROM QPTreasureDB.dbo.PayOrder
		WHERE UserID=@UserID

	--**玩家人数**--
	SELECT @DirectGamerCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) WHERE (AgentID=@UserID) OR (UserID=@UserID)
	SET @SQL=N'SELECT @AllGamerCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK)  a
				WHERE a.IsAndroid=0 AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))'
	EXEC sp_executesql @SQL	, N'@AllGamerCount BIGINT OUT'	, @AllGamerCount OUT
	SELECT @DirectAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) WHERE IsAgent=1 AND AgentID=@UserID	
	SET @SQL=N'SELECT @AllAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a WHERE a.IsAndroid=0 AND a.IsAgent=1 AND (a.UserID IN('+@AllSubAgentIds+'))'
	EXEC sp_executesql @SQL	, N'@AllAgentCount BIGINT OUT'	, @AllAgentCount OUT

	--**金币库存**--
	SELECT  @DirectGamerScore=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.UserID=s.UserID 
		WHERE (a.AgentID=@UserID) OR (a.UserID=@UserID)
	SET @SQL=N'SELECT @AllGamerScore=SUM(s.Score) FROM dbo.GameScoreInfo(NOLOCK) s 
				INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0  
					AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))
					AND s.UserID=a.UserID'
	EXEC sp_executesql @SQL	, N'@AllGamerScore BIGINT OUT'	, @AllGamerScore OUT	

	--**金币损耗**--
	SELECT @DirectGamerWaste=SUM(s.ChangeScore) FROM QPRecordDB.dbo.RecordRichChange(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.UserID=s.UserID
		WHERE (a.AgentID=@UserID OR a.UserID=@UserID) AND s.Reason IN (0,1)
	SET @SQL=N'SELECT @AllGamerWaste=SUM(s.ChangeScore) FROM QPRecordDB.dbo.RecordRichChange(NOLOCK) s 
				INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0  
					AND (a.AgentID IN ('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+') OR a.UserID IN('+CONVERT(VARCHAR(30),@UserID)+','+@AllSubAgentIds+'))
					AND a.UserID=s.UserID
				WHERE s.Reason IN (0,1)'
	EXEC sp_executesql @SQL	, N'@AllGamerWaste BIGINT OUT'	, @AllGamerWaste OUT

	--总返利
	SELECT @SpreadSum=IsNull(SUM(CONVERT(BIGINT,SubString(AttachmentList,3,len(AttachmentList)-2))),0)
		FROM [QPTreasureDB].[dbo].[UserSystemMail] s
		WHERE Title='代理返利'

	--返回
	SELECT  a.UserID,a.GameID,a.Accounts,a.NickName,
			IsNull(@OnLineCount,0) AS OnLineCount,						--在线人数
			IsNull(@Recharge,0) AS Recharge,												--充值金额
			ISNULL(@DirectGamerWaste,0) AS DirectGamerWaste,			--直接玩家金币消耗
			ISNULL(@DirectGamerScore,0) AS DirectGamerScore,			--直接玩家金币库存
			ISNULL(@DirectGamerCount,0) AS DirectGamerCount,			--直接玩家人数
			ISNULL(@DirectAgentCount,0) AS DirectAgentCount,			--直接代理商数
			ISNULL(@AllGamerWaste,0) AS AllGamerWaste,					--全部玩家金币消耗
			ISNULL(@AllGamerScore,0) AS AllGamerScore,					--全部玩家金币库存
			ISNULL(@AllGamerCount,0) AS AllGamerCount,					--全部玩家人数
			ISNULL(@AllAgentCount,0) AS AllAgentCount,					--全部代理商数
			u.Nullity AgentStatus,CASE WHEN IsNull(u.canHasSubAgent,0)=0 THEN '否' ELSE '是' END canHasSubAgent,u.AgentLevelLimit,u.Percentage ProfitRate,aa.[InviteCode] SpreaderID,a.RegisterDate SpreaderDate,a.SpreaderURL
	FROM QPAccountsDB.dbo.AccountsInfo a 
	INNER JOIN [QPPlatformManagerDB].dbo.Base_Users u ON a.UserID=u.AgentID
	LEFT JOIN QPAccountsDB.[dbo].[AccountsInfoEx] aa ON a.UserID=aa.UserID
	WHERE a.UserID=@UserID

END

GO




----------------------------------------------------------------------
-----------Stored Procedure
-----------统计数据 - 总代
IF EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('NET_PM_StatInfo_Admin')=id AND xtype='P')
	DROP PROC NET_PM_StatInfo_Admin
GO
CREATE PROC NET_PM_StatInfo_Admin
AS
BEGIN
	-- 属性设置
	SET NOCOUNT ON;	
	--用户统计
	DECLARE @OnLineCount BIGINT					--在线人数（全部）
	DECLARE @AgentOnLineCount BIGINT			--在线人数（代理）
	DECLARE @PlatformOnLineCount BIGINT			--在线人数（平台）
	DECLARE @AllCount BIGINT					--玩家人数（全部）
	DECLARE @AgentCount BIGINT					--玩家人数（代理）
	DECLARE @TopAgentCount BIGINT				--玩家人数（总代理）
	DECLARE @SubAgentCount BIGINT				--玩家人数（分代理）
	DECLARE @PlatformCount BIGINT				--玩家人数（平台）
	DECLARE @Recharge BIGINT=0					--充值金额（全部）
	DECLARE @AgentRecharge BIGINT=0				--充值金额（代理）
	DECLARE @PlatformRecharge BIGINT=0			--充值总量（平台）
	DECLARE @Score BIGINT						--金币总量（全部）
	DECLARE @AgentScore BIGINT					--金币总量（代理）
	DECLARE @PlatformScore BIGINT				--金币总量（平台）
	DECLARE @Waste BIGINT						--损耗总量
	DECLARE @AgentWaste BIGINT					--损耗总量（代理）
	DECLARE @PlatformWaste BIGINT				--损耗总量（平台）
	DECLARE @SpreadSum BIGINT

	DECLARE @SQL NVARCHAR(MAX)=''

	--在线人数
	SELECT @OnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s
		WHERE EXISTS(SELECT 1 FROM  QPAccountsDB.dbo.AccountsInfo WHERE IsAndroid=0 AND UserID=s.UserID)
	SELECT @AgentOnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
	SELECT @PlatformOnLineCount=COUNT(1) FROM  QPTreasureDB.dbo.GameScoreLocker(NOLOCK) s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID

	--玩家人数
	SELECT  @AllCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0
	SELECT  @AgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND (a.AgentID IS NOT NULL AND a.AgentID<>0)
	SELECT  @PlatformCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND IsNull(a.AgentID,0)=0
	SELECT  @TopAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND UserID IN (
			SELECT AgentID FROM QPPlatformManagerDB.dbo.Base_Users u
			INNER JOIN QPPlatformManagerDB.dbo.Base_Roles r ON u.RoleID=r.RoleID
			WHERE r.AgentLevel=1
		)
	SELECT  @SubAgentCount=COUNT(UserID) FROM QPAccountsDB.dbo.AccountsInfo(NOLOCK) a 
		WHERE a.IsAndroid=0 AND UserID IN (
			SELECT AgentID FROM QPPlatformManagerDB.dbo.Base_Users u
			INNER JOIN QPPlatformManagerDB.dbo.Base_Roles r ON u.RoleID=r.RoleID
			WHERE r.AgentLevel<>1
		)

	--充值金额
	SELECT @Recharge=SUM(s.PayAmount) FROM QPTreasureDB.dbo.PayOrder s	
	SELECT @AgentRecharge=SUM(s.PayAmount) FROM QPTreasureDB.dbo.PayOrder s	
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
	SELECT @PlatformRecharge=SUM(s.PayAmount) FROM QPTreasureDB.dbo.PayOrder s	
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID

	--金币库存
	SELECT  @Score=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
	SELECT  @AgentScore=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
	SELECT  @PlatformScore=SUM(IsNull(Score,0)) FROM dbo.GameScoreInfo(NOLOCK) s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID

	--金币消耗
	SELECT @Waste=SUM(IsNull(s.ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange s 
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND s.UserID=a.UserID
		WHERE s.Reason IN (0,1)
	SELECT @AgentWaste=SUM(IsNull(s.ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND a.AgentID IS NOT NULL AND a.AgentID<>0 AND s.UserID=a.UserID
		WHERE s.Reason IN (0,1)
	SELECT @PlatformWaste=SUM(IsNull(s.ChangeScore,0)) FROM QPRecordDB.dbo.RecordRichChange s
		INNER JOIN QPAccountsDB.dbo.AccountsInfo a ON a.IsAndroid=0 AND IsNULL(a.AgentID,0)=0 AND s.UserID=a.UserID
		WHERE s.Reason IN (0,1)

	--总返利
	SELECT @SpreadSum=IsNull(SUM(CONVERT(BIGINT,SubString(AttachmentList,3,len(AttachmentList)-2))),0)
		FROM [QPTreasureDB].[dbo].[UserSystemMail] s
		WHERE Title='幸运玩家奖励'

	--返回
	SELECT  IsNull(@OnLineCount,0) AS OnLineCount,						--在线人数（全部）
			IsNull(@AgentOnLineCount,0) AS AgentOnLineCount,			--在线人数（代理）
			IsNull(@PlatformOnLineCount,0) AS PlatformOnLineCount,		--在线人数（平台）
			IsNull(@Recharge,0) Recharge,								--充值金额（全部）
			IsNull(@AgentRecharge,0) AgentRecharge,						--充值金额（代理）
			IsNull(@PlatformRecharge,0) PlatformRecharge,				--充值金额（平台）
			IsNull(@AllCount,0) AS AllCount,							--玩家人数（全部）
			IsNull(@AgentCount,0) AS AgentCount,						--玩家人数（代理）
			IsNull(@TopAgentCount,0) AS TopAgentCount,					--玩家人数（总代理）
			IsNull(@SubAgentCount,0) AS SubAgentCount,					--玩家人数（子代理）
			IsNull(@PlatformCount,0) AS PlatformCount,					--玩家人数（平台）

			ISNULL(@Score,0) AS Score,									--金币总量（全部）
			ISNULL(@AgentScore,0) AS AgentScore,						--金币总量（代理）
			ISNULL(@PlatformScore,0) AS PlatformScore,					--金币总量（平台）

			ISNULL(@Waste,0) AS Waste,									--损耗总量（全部）
			ISNULL(@AgentWaste,0) AS AgentWaste,						--损耗总量（代理）
			ISNULL(@PlatformWaste,0) AS PlatformWaste,					--损耗总量（平台）
			ISNULL(@SpreadSum,0) AS SpreadSum							--玩家总返利

END


GO


---------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantRcard') AND [type]='P')
	DROP PROC NET_PM_GrantRcard
GO
CREATE PROC [dbo].[NET_PM_GrantRcard]
(	
	@strUserIDList	NVARCHAR(1000),	--用户标识的字符串
	@dwAddRcard		DECIMAL(18,2),	--赠送房卡
	@strReason 		NVARCHAR(32),	--赠送原因
	@strClientIP	VARCHAR(15),		--IP地址
	@dwMasterID		INT			--操作者标识
)
			
  AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- 赠送对象的数量	
			@dwTotalRcard	DECIMAL(18,2),	-- 赠送的总房卡
			@dtCurrentDate	DATETIME		-- 操作日期
	SET @dtCurrentDate =  GETDATE()
	
	
	-- 执行逻辑
	BEGIN TRY
	-- 验证
	IF @dwAddRcard IS NULL OR @dwAddRcard = 0
		RETURN -2;		-- 赠送金额不能为零
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- 未选中赠送对象
	SET @dwTotalRcard = @dwCounts * @dwTotalRcard	
	
	BEGIN TRAN
			--插入赠送金币记录		
			INSERT QPRecordDB.dbo.RecordGrantRCard(MasterID,ClientIP,CollectDate,UserID,CurRCard,RCard,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,a.rs,b.RCard,@dwAddRcard,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行金币
			UPDATE GameScoreInfo SET Rcard=(CASE WHEN Rcard+@dwAddRcard<0 THEN 0 WHEN Rcard+@dwAddRcard>=0 THEN Rcard+@dwAddRcard end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,Rcard) 
			SELECT rs,@dwAddRcard FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
		
	COMMIT TRAN			
		RETURN 0;--成功
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW;
	END CATCH
END

GO

---------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantRcard_Agent') AND [type]='P')
	DROP PROC NET_PM_GrantRcard_Agent
GO
CREATE PROC [dbo].NET_PM_GrantRcard_Agent
(	
	@byUserID		INT,
	@strUserIDList	NVARCHAR(1000),	--用户标识的字符串
	@UserIDListCount INT,			--批量用户数量
	@dwAddRcard		DECIMAL(18,2),	--赠送房卡
	@strReason 		NVARCHAR(32),	--赠送原因
	@strClientIP	VARCHAR(15),		--IP地址
	@dwMasterID		INT			--操作者标识
)
			
  AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- 赠送对象的数量	
			@dwTotalRcard	DECIMAL(18,2),	-- 赠送的总房卡
			@dtCurrentDate	DATETIME		-- 操作日期
	SET @dtCurrentDate =  GETDATE()	
	
	-- 执行逻辑
	BEGIN TRY
	-- 验证
	IF @dwAddRcard IS NULL OR @dwAddRcard = 0
		RETURN -2;		-- 赠送金额不能为零
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- 未选中赠送对象
	SET @dwTotalRcard = @dwCounts * @dwTotalRcard
	DECLARE @Rcard BIGINT
	SELECT @Rcard=SUM(RCard) FROM [dbo].[GameScoreInfo] WHERE UserID=@byUserID
	IF @dwAddRcard>@Rcard
	BEGIN
		RETURN -4		-- 房卡超出代理商可用房卡
	END
			
	BEGIN TRAN
			--插入赠送房卡记录		
			INSERT QPRecordDB.dbo.RecordGrantRCard(MasterID,SendUserID,ClientIP,CollectDate,UserID,CurRCard,RCard,Reason)
				SELECT -1,@dwMasterID,@strClientIP,@dtCurrentDate,a.rs,b.RCard,@dwAddRcard,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行房卡
			UPDATE GameScoreInfo SET Rcard=(CASE WHEN Rcard+@dwAddRcard<0 THEN 0 WHEN Rcard+@dwAddRcard>=0 THEN Rcard+@dwAddRcard end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			UPDATE s SET s.Rcard=s.Rcard-@dwAddRcard*@UserIDListCount
			FROM GameScoreInfo s
			WHERE UserID=@byUserID

			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,Rcard) 
			SELECT rs,@dwAddRcard FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)			
		
	COMMIT TRAN			
		RETURN 0;--成功
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW;
	END CATCH
END

GO


----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantTreasure') AND [type]='P')
	DROP PROC NET_PM_GrantTreasure
GO
Create PROC NET_PM_GrantTreasure
(	
	@strUserIDList	NVARCHAR(1000),	--用户标识的字符串
	@dwAddGold		DECIMAL(18,2),	--赠送金额
	@dwMasterID		INT,			--操作者标识
	@strReason 		NVARCHAR(32),	--赠送原因
	@strClientIP	VARCHAR(15)		--IP地址
)
			
AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- 赠送对象的数量	
			@dwTotalGold	DECIMAL(18,2),	-- 赠送的总金额
			@dtCurrentDate	DATETIME		-- 操作日期
	SET @dtCurrentDate =  GETDATE()
	
	
	-- 执行逻辑
	BEGIN TRY
	-- 验证
	IF @dwAddGold IS NULL OR @dwAddGold = 0
		RETURN -2;		-- 赠送金额不能为零
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- 未选中赠送对象
	SET @dwTotalGold = @dwCounts * @dwAddGold	
	
	BEGIN TRAN
			--插入赠送金币记录		
			INSERT QPRecordDB.dbo.RecordGrantTreasure(MasterID,ClientIP,CollectDate,UserID,CurGold,AddGold,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,a.rs,ISNULL(b.Score,0),@dwAddGold,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行金币
			UPDATE GameScoreInfo SET Score=(CASE WHEN Score+@dwAddGold<0 THEN 0 WHEN Score+@dwAddGold>=0 THEN Score+@dwAddGold end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,Score) 
			SELECT rs,@dwAddGold FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
			
	COMMIT TRAN			
		RETURN 0;--成功
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW;
	END CATCH
END

GO



----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantTreasure_Agent') AND [type]='P')
	DROP PROC NET_PM_GrantTreasure_Agent
GO

Create PROC NET_PM_GrantTreasure_Agent
(	
	@byUserID		INT,			--代理商UserID
	@strUserIDList	NVARCHAR(1000),	--用户标识的字符串
	@UserIDListCount INT,
	@dwAddGold		DECIMAL(18,2),	--赠送金额
	@dwMasterID		INT,			--操作者标识
	@strReason 		NVARCHAR(32),	--赠送原因
	@strClientIP	VARCHAR(15)		--IP地址
)
			
AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- 赠送对象的数量	
			@dwTotalGold	DECIMAL(18,2),	-- 赠送的总金额
			@dtCurrentDate	DATETIME		-- 操作日期
	SET @dtCurrentDate =  GETDATE()
	
	
	-- 执行逻辑
	BEGIN TRY
	-- 验证
	IF @dwAddGold IS NULL OR @dwAddGold = 0
		RETURN -2;		-- 赠送金额不能为零
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- 未选中赠送对象
	SET @dwTotalGold = @dwCounts * @dwAddGold	

	DECLARE @score BIGINT
	SELECT @score=SUM(Score) FROM [dbo].[GameScoreInfo] WHERE UserID=@byUserID
	IF @dwAddGold>@Score
	BEGIN
		RETURN -4		-- 金币超出代理商可用金币
	END
	
	BEGIN TRAN
			--插入赠送金币记录		
			INSERT QPRecordDB.dbo.RecordGrantTreasure(MasterID,SendUserID,ClientIP,CollectDate,UserID,CurGold,AddGold,Reason)
				SELECT -1,@dwMasterID,@strClientIP,@dtCurrentDate,a.rs,ISNULL(b.Score,0),@dwAddGold,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行金币
			UPDATE GameScoreInfo SET Score=(CASE WHEN Score+@dwAddGold<0 THEN 0 WHEN Score+@dwAddGold>=0 THEN Score+@dwAddGold end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			UPDATE s SET s.Score=s.Score-@dwAddGold*@UserIDListCount
			FROM GameScoreInfo s
			WHERE UserID=@byUserID

			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,Score) 
			SELECT rs,@dwAddGold FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
			
	COMMIT TRAN			
		RETURN 0;--成功
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW;
	END CATCH
END

GO


IF NOT EXISTS(SELECT 1 FROM [dbo].syscolumns WHERE object_id('UserSystemMail')=id AND name='SpreadDate')
BEGIN
	ALTER TABLE [dbo].[UserSystemMail]
	ADD SpreadDate VARCHAR(10)
END
GO




