use QPNativeWebDB
GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameFeedbackInfo')=id AND name = 'QQ')
	ALTER TABLE GameFeedbackInfo
	ADD QQ VARCHAR(15)
	
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameFeedbackInfo')=id AND name = 'ftype')
	ALTER TABLE GameFeedbackInfo
	ADD ftype VARCHAR(15)

GO
	
IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('GameIssueInfo')=id AND name = 'QQ')
	ALTER TABLE GameIssueInfo
	ADD QQ VARCHAR(15)

GO


----------------------------------------------------------------------------------------------------
--drop procedure [dbo].[NET_PW_InsertGameFeedback]
-- 问题反馈
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PW_InsertGameFeedback') AND xtype='P')
	DROP PROC NET_PW_InsertGameFeedback
GO
Create PROCEDURE NET_PW_InsertGameFeedback
	@strAccounts		NVARCHAR(31),			-- 用户帐号

	@strTitle			NVARCHAR(512),			-- 反馈主题
	@strContent			NVARCHAR(50),			-- 反馈内容
	@strEMail			NVARCHAR(50),	-- 联系方式
	@strphone			NVARCHAR(50),
	@strQQ				NVARCHAR(15),
	@strClientIP		NVARCHAR(15),			-- 反馈地址
	@strErrorDescribe	NVARCHAR(127) OUTPUT,	--输出信息	
	@ftype				INT
  AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @Nullity BIT
DECLARE @StunDown BIT

-- 执行逻辑
BEGIN
	IF @strAccounts<>''
	BEGIN
		-- 查询用户
		SELECT @UserID=UserID,@Nullity=Nullity, @StunDown=StunDown
		--FROM QPAccountsDBLink.QPAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts
		FROM QPAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts

		-- 用户存在
		IF @UserID IS NULL
		BEGIN
			SET @strErrorDescribe=N'您的帐号不存在，请查证后再次输入！'
			RETURN 1
		END	

		-- 帐号禁止
		IF @Nullity<>0
		BEGIN
			SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
			RETURN 2
		END	

		-- 帐号关闭
		IF @StunDown<>0
		BEGIN
			SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
			RETURN 3
		END	
	END	

	-- 新增反馈
	INSERT INTO GameFeedbackInfo(FeedbackTitle,FeedbackContent,Accounts,EMail,ClientIP,Phone,QQ,Nullity,ftype)
	VALUES(@strTitle,@strContent,@strAccounts,@strEMail,@strClientIP,@strphone,@strQQ,1,@ftype)

	SET @strErrorDescribe=N'问题反馈新增成功！'
END
RETURN 0

GO


----------------------------------------------------------------------------------------------------
--drop procedure [dbo].[NET_PW_InsertGameFeedback]
-- 问题反馈
IF EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('NET_PW_InsertGameIssueInfo') AND xtype='P')
	DROP PROC NET_PW_InsertGameIssueInfo
GO
Create PROCEDURE NET_PW_InsertGameIssueInfo
	@strAccounts VARCHAR(50),
	@strQQ VARCHAR(50),
	@issueTitle VARCHAR(50),
	@issueContent VARCHAR(MAX),
	@nullity BIT,
	@collectDate DATETIME,
	@modifyDate DATETIME,
	@strErrorDescribe	NVARCHAR(127) OUTPUT	--输出信息	
AS

-- 属性设置
SET NOCOUNT ON

-- 基本信息
DECLARE @UserID INT
DECLARE @StunDown BIT

-- 执行逻辑
BEGIN
	IF @strAccounts<>''
	BEGIN
		-- 查询用户
		SELECT @UserID=UserID,@Nullity=Nullity, @StunDown=StunDown
		FROM QPAccountsDB.dbo.AccountsInfo WHERE Accounts=@strAccounts

		-- 用户存在
		IF @UserID IS NULL
		BEGIN
			SET @strErrorDescribe=N'您的帐号不存在，请查证后再次输入！'
			RETURN 1
		END	

		-- 帐号禁止
		IF @Nullity<>0
		BEGIN
			SET @strErrorDescribe=N'您的帐号暂时处于冻结状态，请联系客户服务中心了解详细情况！'
			RETURN 2
		END	

		-- 帐号关闭
		IF @StunDown<>0
		BEGIN
			SET @strErrorDescribe=N'您的帐号使用了安全关闭功能，必须重新开通后才能继续使用！'
			RETURN 3
		END	
	END	

	-- 新增反馈
	INSERT  GameIssueInfo([IssueTitle],[IssueContent],[Nullity],[CollectDate],[ModifyDate],QQ)
	VALUES(@issueTitle,@issueContent,@nullity,@collectDate,@modifyDate,@strQQ)

	SET @strErrorDescribe=N'问题反馈新增成功！'
END
RETURN 0

GO

