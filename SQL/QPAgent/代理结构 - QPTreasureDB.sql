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
	DECLARE @AgentSpreadSum BIGINT

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
	SELECT @AgentSpreadSum=IsNull(SUM(CONVERT(BIGINT,SubString(AttachmentList,3,len(AttachmentList)-2))),0)
		FROM [QPTreasureDB].[dbo].[UserSystemMail] s
		WHERE Title='代理返利' AND UserID=@UserID

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
			ISNULL(@AgentSpreadSum,0) AS AgentSpreadSum,
			CASE u.Nullity WHEN 0 THEN '正常' ELSE '冻结' END AgentStatus,CASE WHEN IsNull(u.canHasSubAgent,0)=0 THEN '否' ELSE '是' END canHasSubAgent,isnull(u.AgentLevelLimit,0) AgentLevelLimit,u.Percentage ProfitRate,aa.[InviteCode] SpreaderID,a.RegisterDate SpreaderDate,a.SpreaderURL
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
	@strClientIP	VARCHAR(15),	--IP地址
	@dwMasterID		INT				--操作者标识
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

			INSERT QPRecordDB.dbo.RecordRichChange(UserID,KindID,ServerID,BeforeScore,ChangeScore,AfterScore,BeforeDiamond,ChangeDiamond,AfterDiamond,BeforeRCard,ChangeRCard,AfterRCard,Reason,LastTime)
			SELECT a.rs,0,0,b.Score,0,b.Score,b.Diamond,0,b.Diamond,b.RCard,@dwAddRcard,b.RCard+@dwAddRcard,7,GETDATE()
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行金币
			UPDATE GameScoreInfo SET Rcard=(CASE WHEN Rcard+@dwAddRcard<0 THEN 0 WHEN Rcard+@dwAddRcard>=0 THEN Rcard+@dwAddRcard end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,Rcard) 
			SELECT rs,@dwAddRcard FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
			SELECT * FROM QPRecordDB.dbo.RecordRichChange


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
		
			INSERT QPRecordDB.dbo.RecordRichChange(UserID,KindID,ServerID,BeforeScore,ChangeScore,AfterScore,BeforeDiamond,ChangeDiamond,AfterDiamond,BeforeRCard,ChangeRCard,AfterRCard,Reason,LastTime)
			SELECT a.rs,0,0,b.Score,0,b.Score,b.Diamond,0,b.Diamond,b.RCard,@dwAddRcard,b.RCard+@dwAddRcard,7,GETDATE()
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
			--@dwTotalGold	DECIMAL(18,2),	-- 赠送的总金额
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
	--SET @dwTotalGold = @dwCounts * @dwAddGold	
	
	BEGIN TRAN
			--插入赠送金币记录		
			INSERT QPRecordDB.dbo.RecordGrantTreasure(MasterID,ClientIP,CollectDate,UserID,CurGold,AddGold,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,a.rs,ISNULL(b.Score,0),@dwAddGold,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 

			INSERT QPRecordDB.dbo.RecordRichChange(UserID,KindID,ServerID,BeforeScore,ChangeScore,AfterScore,BeforeDiamond,ChangeDiamond,AfterDiamond,BeforeRCard,ChangeRCard,AfterRCard,Reason,LastTime)
			SELECT a.rs,0,0,b.Score,@dwAddGold,b.Score+@dwAddGold,b.Diamond,0,b.Diamond,b.RCard,0,b.RCard,7,GETDATE()
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
			--@dwTotalGold	DECIMAL(18,2),	-- 赠送的总金额
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
	--SET @dwTotalGold = @dwCounts * @dwAddGold	

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

			INSERT QPRecordDB.dbo.RecordRichChange(UserID,KindID,ServerID,BeforeScore,ChangeScore,AfterScore,BeforeDiamond,ChangeDiamond,AfterDiamond,BeforeRCard,ChangeRCard,AfterRCard,Reason,LastTime)
			SELECT a.rs,0,0,b.Score,@dwAddGold,b.Score+@dwAddGold,b.Diamond,0,b.Diamond,b.RCard,0,b.RCard,7,GETDATE()
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--没有金币记录的玩家银行金币更新
			INSERT INTO GameScoreInfo(UserID,Score) 
			SELECT rs,@dwAddGold FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)

			--更新玩家银行金币
			UPDATE GameScoreInfo SET Score=(CASE WHEN Score+@dwAddGold<0 THEN 0 WHEN Score+@dwAddGold>=0 THEN Score+@dwAddGold end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			UPDATE s SET s.Score=s.Score-@dwAddGold*@UserIDListCount
			FROM GameScoreInfo s
			WHERE UserID=@byUserID
			
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


 


----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('WSP_PM_GrantGameScore') AND [type]='P')
	DROP PROC WSP_PM_GrantGameScore
GO 
CREATE PROCEDURE [dbo].[WSP_PM_GrantGameScore]
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址	
	@UserID INT,				-- 用户标识
	@KindID INT,				-- 游戏标识
	@AddScore BIGINT,			-- 赠送积分
	@Reason NVARCHAR(32)		-- 赠送原因
	
  AS

-- 属性设置
SET NOCOUNT ON

-- 用户积分
DECLARE @CurScore BIGINT

-- 执行逻辑
BEGIN
	
	-- 获取用户积分
	SELECT 	@CurScore = Score FROM GameScoreInfo WHERE UserID=@UserID
	IF @CurScore IS NULL
	BEGIN
		SET @CurScore = 0
	END

	-- 新增记录信息
	INSERT INTO QPRecordDB.dbo.RecordGrantGameScore(MasterID,ClientIP,UserID,KindID,CurScore,AddScore,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@KindID,@CurScore,@AddScore,@Reason)

	-- 赠送积分
	UPDATE GameScoreInfo SET Score = Score + @AddScore
	WHERE UserID=@UserID
	
	IF @@ROWCOUNT = 0 
	BEGIN
		INSERT INTO GameScoreInfo(UserID,Score,RegisterIP,LastLogonIP)
		VALUES(@UserID,@AddScore,@ClientIP,@ClientIP)
	END
END
RETURN 0

go



----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('WSP_PM_GrantClearFlee') AND [type]='P')
	DROP PROC WSP_PM_GrantClearFlee
GO 
CREATE PROCEDURE [dbo].[WSP_PM_GrantClearFlee]
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 清零地址
	@UserID INT,				-- 用户标识
	@KindID INT,				-- 游戏标识
	@Reason NVARCHAR(32)		-- 清零原因
  AS

-- 属性设置
SET NOCOUNT ON

-- 用户逃跑次数
DECLARE @CurFlee INT

-- 返回信息
DECLARE @ReturnValue NVARCHAR(127)

-- 执行逻辑
BEGIN
	
	-- 获取用户逃率次数
	SELECT @CurFlee = FleeCount FROM GameScoreInfo WHERE UserID=@UserID
	IF @CurFlee = 0 OR @CurFlee IS NULL
	BEGIN
		SET @ReturnValue = N'没有逃跑记录，不需要清零！'
		SELECT @ReturnValue
		RETURN 1
	END

	-- 新增记录信息
	INSERT INTO QPRecordDB.dbo.RecordGrantClearFlee(MasterID,ClientIP,UserID,KindID,CurFlee,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@KindID,@CurFlee,@Reason)

	-- 清零逃率
	UPDATE GameScoreInfo SET FleeCount = 0 WHERE UserID=@UserID	

	SELECT ''
END
RETURN 0


GO



----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('WSP_PM_GrantClearScore') AND [type]='P')
	DROP PROC WSP_PM_GrantClearScore
GO 
CREATE PROCEDURE [dbo].[WSP_PM_GrantClearScore]
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址
	@UserID INT,				-- 用户标识
	@KindID INT,				-- 游戏标识
	@Reason NVARCHAR(32)		-- 清零原因
  AS

-- 属性设置
SET NOCOUNT ON

-- 用户积分
DECLARE @CurScore BIGINT

-- 返回信息
DECLARE @ReturnValue NVARCHAR(127)

-- 执行逻辑
BEGIN
	
	-- 获取用户积分
	SELECT 	@CurScore = Score FROM GameScoreInfo WHERE UserID=@UserID
	IF @CurScore>=0 OR @CurScore IS NULL
	BEGIN
		SET @ReturnValue = N'没有负分信息，不需要清零！'
		SELECT @ReturnValue
		RETURN 1
	END

	-- 新增记录信息
	INSERT INTO QPRecordDB.dbo.RecordGrantClearScore(MasterID,ClientIP,UserID,KindID,CurScore,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@KindID,@CurScore,@Reason)

	-- 清零积分
	UPDATE GameScoreInfo SET Score = 0 WHERE UserID=@UserID	

	SELECT ''
END
RETURN 0


GO


----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('WSP_PM_GrantExperience') AND [type]='P')
	DROP PROC WSP_PM_GrantExperience
GO 
CREATE PROCEDURE [dbo].[WSP_PM_GrantExperience]
	@MasterID INT,				-- 管理员标识
	@ClientIP VARCHAR(15),		-- 赠送地址
	@UserID INT,				-- 用户标识
	@AddExperience INT,			-- 赠送经验
	@Reason NVARCHAR(32)		-- 赠送原因
  AS

-- 属性设置
SET NOCOUNT ON

-- 用户经验
DECLARE @CurExperience INT

-- 执行逻辑
BEGIN
	
	-- 获取用户经验
	SELECT @CurExperience = Experience FROM QPAccountsDB.dbo.AccountsInfo
	WHERE UserID = @UserID

	-- 新增记录信息
	INSERT INTO [QPRecordDB].dbo.RecordGrantExperience(MasterID,ClientIP,UserID,CurExperience,AddExperience,Reason)
	VALUES(@MasterID,@ClientIP,@UserID,@CurExperience,@AddExperience,@Reason)

	-- 赠送经验
	UPDATE QPAccountsDB.dbo.AccountsInfo SET Experience = Experience + @AddExperience
	WHERE UserID = @UserID
END
RETURN 0
GO


----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('p_Report_GetProfit') AND [type]='P')
	DROP PROC p_Report_GetProfit
GO 
 
CREATE PROC [dbo].[p_Report_GetProfit] 
	@KindID INT, 
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
	--玩家盈利
	SET @SQL=' select top 100 d.*, a.GameID ,a.Accounts , a.NickName, ROW_NUMBER() OVER(ORDER BY d.profit DESC) RowNo
	INTO '+@tempTable+' from (select UserID ,sum(ChangeScore) as Profit
	FROM [QPRecordDB].[dbo].[RecordRichChange]  
	WHERE 1=1  and Reason IN (0,1) '	+@Where + ' 
	group by UserID   )d  
	left join [QPAccountsDB].[dbo].[AccountsInfo] a on a.UserID = d.UserID
	order by d.profit desc
	SELECT totalCount=Count(1) FROM '+ @tempTable + '
	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable
   
	EXEC(@SQL)
END

go


----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('p_Report_TimeCount') AND [type]='P')
	DROP PROC p_Report_TimeCount
GO 
CREATE PROC [dbo].[p_Report_TimeCount] 
	@KindID INT, 
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
	--玩家游戏时间
	SET @SQL=' select top 100  [UserID]  ,[GameID]   ,[Accounts]   ,[NickName]   ,[PlayTimeCount]
      ,[OnLineTimeCount] , ROW_NUMBER() OVER(order by PlayTimeCount desc) RowNo
	INTO '+@tempTable+' from [QPAccountsDB].[dbo].[AccountsInfo]   
	order by PlayTimeCount desc
	SELECT totalCount=Count(1) FROM '+ @tempTable + '
	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable
   
	EXEC(@SQL)
END 

GO

----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PM_GrantDiamond') AND [type]='P')
	DROP PROC NET_PM_GrantDiamond
GO 
CREATE  PROC [dbo].[NET_PM_GrantDiamond]
(	
	@strUserIDList	NVARCHAR(1000),	--用户标识的字符串
	@dwAddRdiamond		DECIMAL(18,2),	--赠送钻石
	@strReason 		NVARCHAR(32),	--赠送原因
	@strClientIP	VARCHAR(15),		--IP地址
	@dwMasterID		INT			--操作者标识
)
			
  AS

BEGIN
	-- 属性设置
	SET NOCOUNT ON

	DECLARE @dwCounts		INT,			-- 赠送对象的数量	
			@dwTotalRdiamond	DECIMAL(18,2),	-- 赠送的总钻石
			@dtCurrentDate	DATETIME		-- 操作日期
	SET @dtCurrentDate =  GETDATE()
	
	
	-- 执行逻辑
	BEGIN TRY
	-- 验证
	IF @dwAddRdiamond IS NULL OR @dwAddRdiamond = 0
		RETURN -2;		-- 赠送钻石不能为零
	SELECT @dwCounts=COUNT(*) FROM dbo.WF_Split(@strUserIDList,',')
	IF @dwCounts<=0 
		RETURN -3;		-- 未选中赠送对象
	SET @dwTotalRdiamond = @dwCounts * @dwTotalRdiamond	
	
	BEGIN TRAN
			--插入赠送钻石记录		
			INSERT QPRecordDB.dbo.RecordGrantDiamond(MasterID,ClientIP,CollectDate,UserID,CurRDiamond,RDiamond,Reason)
				SELECT @dwMasterID,@strClientIP,@dtCurrentDate,
						a.rs,ISNULL(b.Score,0),@dwAddRdiamond,@strReason
				FROM WF_Split(@strUserIDList,',') a LEFT JOIN GameScoreInfo b ON a.rs = b.UserID			 
			
			--更新玩家银行钻石
			UPDATE GameScoreInfo SET Diamond=(CASE WHEN Diamond+@dwAddRdiamond<0 THEN 0 WHEN Diamond+@dwAddRdiamond>=0 THEN Diamond+@dwAddRdiamond end) 
			WHERE UserID IN (SELECT rs FROM dbo.WF_Split(@strUserIDList,','))
			
			--没有钻石记录的玩家银行钻石更新
			INSERT INTO GameScoreInfo(UserID,Diamond) 
			SELECT rs,@dwAddRdiamond FROM dbo.WF_Split(@strUserIDList,',') WHERE rs NOT IN (SELECT UserID FROM dbo.GameScoreInfo)
			
		
	COMMIT TRAN			
		RETURN 0;--成功
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRAN
		END;
		THROW
	END CATCH
END
GO


--玩家充值记录
----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('WEB_LIST_PayOrder') AND [type]='P')
	DROP PROC WEB_LIST_PayOrder
GO 
CREATE  PROC  [dbo].[WEB_LIST_PayOrder]
	@OrderID VARCHAR(64),
	@Accounts VARCHAR(31),
	@startDate VARCHAR(30),
	@endDate VARCHAR(30),
	@UserID INT,
	@GameID INT,
	@pageIndex INT=1,
	@pageSize INT=20
AS
BEGIN
	DECLARE @SQL VARCHAR(MAX)=''
	DECLARE @Where VARCHAR(1000)=''
	DECLARE @tempTable VARCHAR(50)=''
	SET @tempTable = Replace('##'+CONVERT(VARCHAR(50), NEWID()),'-','')

	 
	IF @OrderID<>''
	    SET @Where=@Where+' AND a.OrderID  LIKE ''%'+@OrderID+'%''' 

    IF @GameID<>''
	    SET @Where=@Where+' AND b.GameID  ='+Convert(VARCHAR(30),@GameID)

    IF @UserID<>''
	    SET @Where=@Where+' AND a.UserID  ='+Convert(VARCHAR(30),@UserID)

    IF @Accounts<>''
	    SET @Where=@Where+' AND b.Accounts  LIKE ''%'+@Accounts+'%''' 

		


	IF @startDate<>''
		SET @Where=@Where+' AND a.CreateTime >= '''+@startDate+''''
	IF @endDate<>''
		SET @Where=@Where+' AND a.CreateTime < '''+@endDate+'  23:59:59'''

	
	SET @SQL='

	select  a.OrderID
      , case when LEN(a.ChannelOrderID)=0 then ''无'' else a.ChannelOrderID end ChannelOrderID 
      , a.UserID   ,   b.GameID  , case when  a.GoodsType =0 then ''钻石'' when  a.GoodsType =1 then ''房卡'' else ''无'' end   GoodsType  ,
	  case when  a.PayType =1 then ''苹果'' when  a.PayType =2 then ''微信'' when  a.PayType =3 then ''威富通'' when  a.PayType =4 then ''盾行天下'' end PayType   , a.[PayAmount]  , a.[BackCount]
      ,  case when  a.PayState =0 then ''生成'' when  a.PayState =1 then ''充值中''  when  a.PayState =2 then ''充值成功''  when  a.PayState =3 then ''充值失败'' when  a.PayState =4 then ''订单过期'' end   PayState
	   , a.UpdateTime  , a.CreateTime  , case when LEN(a.ErrorCode)=0 then ''无'' else isnull(a.ErrorCode,''无'') end ErrorCode , 
	  case when LEN(b.Accounts)=0 then ''无'' else isnull(b.Accounts,''无'') end Accounts  ,
	  case when LEN( b.NickName)=0 then ''无'' else isnull( b.NickName,''无'') end  NickName  ,
	  ROW_NUMBER() OVER(ORDER BY a.OrderID DESC) RowNo
	  INTO '+@tempTable+'
	   from [QPTreasureDB].[dbo].[PayOrder] a 
     left join [QPAccountsDB].[dbo].[AccountsInfo] b
      on b.UserID =a.UserID 
	WHERE 1=1  '	+@Where + '
	SELECT totalCount=Count(1) FROM '+ @tempTable + '

	SELECT * FROM ' + @tempTable + '
	WHERE RowNo BETWEEN '+CONVERT(VARCHAR(10),(@pageIndex-1)*@pageSize+1)+' AND '+CONVERT(VARCHAR(10),@pageIndex*@pageSize)+'
	ORDER BY RowNO 

	DROP TABLE '+@tempTable

	--SELECT @SQL
	EXEC(@SQL)
END
